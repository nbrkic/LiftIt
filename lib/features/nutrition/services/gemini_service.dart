import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'food_search_result.dart';

// Photo-based food recognition, and a free-text fallback for anything the
// structured databases (Open Food Facts/USDA) don't have — mostly homemade
// or mixed dishes. Uses Gemini's JSON mode (responseMimeType +
// responseSchema) instead of just hoping a prompt produces valid JSON.
//
// Model is pinned to one constant deliberately: this app has no backend, so
// when Google eventually retires this model there's no server-side fix,
// only a new app release with an updated constant here.
class GeminiService {
  final http.Client _client;
  GeminiService({http.Client? client}) : _client = client ?? http.Client();

  // gemini-3.8-flash (GA barely a week at the time this was written)
  // reproducibly stalled on every single attempt for structured-JSON +
  // vision requests, even across fresh connections — not the occasional
  // flakiness the retry logic above is meant to paper over, but something
  // specific to that model/request combo. 3.5 Flash has been GA for
  // months and is Google's own recommended migration target off the now
  // fully-deprecated 2.0 Flash, so it's the safer choice here.
  static const _model = 'gemini-3.5-flash';
  static const _base = 'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent';

  // Gemini's flash-tier models have a documented failure mode where a
  // request occasionally stalls at the socket level — connection stays
  // open, no data ever arrives, no error, nothing to catch except a client
  // timeout (confirmed: the network path itself responds in ~250ms; a
  // 90s single wait still hit this with zero response). Mitigated with a
  // short per-attempt timeout plus a couple of retries on a brand-new
  // connection each time, rather than one long wait on a connection that
  // may already be stuck.
  // Capped at 2, not 3 — every attempt costs up to _perAttemptTimeout, and
  // this is a foreground wait a user is staring at (a "Describe Food" or
  // photo-scan dialog). Google's own guidance for a *sustained* overload is
  // "wait ~5 minutes", which one more in-app retry can't fix anyway — this
  // budget is only meant to ride out a genuinely brief blip, not to keep
  // hammering a service that's actually down, and shouldn't leave someone
  // watching a spinner for the better part of a minute either way.
  static const _perAttemptTimeout = Duration(seconds: 25);
  static const _maxAttempts = 2;

  static const _itemSchema = {
    'type': 'ARRAY',
    'items': {
      'type': 'OBJECT',
      'properties': {
        'name': {'type': 'STRING'},
        'quantityLabel': {'type': 'STRING'},
        'calories': {'type': 'NUMBER'},
        'proteinG': {'type': 'NUMBER'},
        'carbsG': {'type': 'NUMBER'},
        'fatG': {'type': 'NUMBER'},
      },
      'required': ['name', 'quantityLabel', 'calories', 'proteinG', 'carbsG', 'fatG'],
    },
  };

  Future<List<GeminiFoodItem>> recognizeFood(Uint8List imageBytes, String apiKey) {
    const prompt = 'Identify each distinct food item visible in this photo. For each item, '
        'estimate a realistic serving size and its total calories, protein, carbs, and fat '
        'for that portion. Respond only with the requested structured data.';
    return _generateItems(
      apiKey,
      parts: [
        {'text': prompt},
        {
          'inline_data': {'mime_type': 'image/jpeg', 'data': base64Encode(imageBytes)},
        },
      ],
    );
  }

  Future<List<GeminiFoodItem>> estimateFromDescription(String description, String apiKey) {
    final prompt = 'The user describes food they ate: "$description". Estimate a realistic '
        'serving and its total calories, protein, carbs, and fat. If multiple foods are '
        'mentioned, list each one separately. Respond only with the requested structured data.';
    return _generateItems(apiKey, parts: [
      {'text': prompt},
    ]);
  }

  // Plain free-text generation (no JSON schema) — used for prose like the
  // workout summary, where the output is meant to be read directly, not
  // parsed.
  Future<String> generateText(String prompt, String apiKey) {
    return _generateText(apiKey, parts: [
      {'text': prompt},
    ]);
  }

  // Same as generateText, but with one or more images attached alongside
  // the prompt — e.g. comparing two progress photos in a single request.
  Future<String> generateTextWithImages(String prompt, List<Uint8List> images, String apiKey) {
    return _generateText(apiKey, parts: [
      {'text': prompt},
      for (final image in images)
        {
          'inline_data': {'mime_type': 'image/jpeg', 'data': base64Encode(image)},
        },
    ]);
  }

  Future<String> _generateText(String apiKey, {required List<Map<String, Object>> parts}) async {
    final uri = Uri.parse(_base).replace(queryParameters: {'key': apiKey});
    final requestBody = jsonEncode({
      'contents': [
        {'parts': parts},
      ],
    });

    final response = await _postWithRetry(uri, requestBody);

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw const NutritionApiException('Gemini: invalid API key');
    }
    if (response.statusCode != 200) {
      throw NutritionApiException('Gemini: HTTP ${response.statusCode}');
    }

    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = body['candidates'] as List?;
      final parts = ((candidates?.first as Map<String, dynamic>?)?['content']
          as Map<String, dynamic>?)?['parts'] as List?;
      final text = (parts?.first as Map<String, dynamic>?)?['text'] as String?;
      if (text == null || text.trim().isEmpty) {
        throw const NutritionApiException('Gemini: empty response');
      }
      return text.trim();
    } on NutritionApiException {
      rethrow;
    } catch (_) {
      throw const NutritionApiException('Gemini: could not read the response');
    }
  }

  Future<List<GeminiFoodItem>> _generateItems(
    String apiKey, {
    required List<Map<String, Object>> parts,
  }) async {
    final uri = Uri.parse(_base).replace(queryParameters: {'key': apiKey});
    final requestBody = jsonEncode({
      'contents': [
        {'parts': parts},
      ],
      'generationConfig': {
        'responseMimeType': 'application/json',
        'responseSchema': _itemSchema,
      },
    });

    final response = await _postWithRetry(uri, requestBody);

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw const NutritionApiException('Gemini: invalid API key');
    }
    if (response.statusCode != 200) {
      throw NutritionApiException('Gemini: HTTP ${response.statusCode}');
    }

    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = body['candidates'] as List?;
      final text = ((candidates?.first as Map<String, dynamic>?)?['content']
          as Map<String, dynamic>?)?['parts'] as List?;
      final jsonText = (text?.first as Map<String, dynamic>?)?['text'] as String?;
      if (jsonText == null) throw const NutritionApiException('Gemini: empty response');

      final items = jsonDecode(jsonText) as List;
      return items.cast<Map<String, dynamic>>().map((item) {
        return GeminiFoodItem(
          name: item['name'] as String? ?? '',
          quantityLabel: item['quantityLabel'] as String? ?? '',
          calories: (item['calories'] as num?)?.toDouble() ?? 0,
          proteinG: (item['proteinG'] as num?)?.toDouble() ?? 0,
          carbsG: (item['carbsG'] as num?)?.toDouble() ?? 0,
          fatG: (item['fatG'] as num?)?.toDouble() ?? 0,
        );
      }).toList();
    } on NutritionApiException {
      rethrow;
    } catch (_) {
      throw const NutritionApiException('Gemini: could not read the response');
    }
  }

  Future<http.Response> _postWithRetry(Uri uri, String body) async {
    for (var attempt = 1; attempt <= _maxAttempts; attempt++) {
      // A fresh client per attempt guarantees a fresh connection — reusing
      // one that already stalled would just risk hitting the same stall.
      final client = attempt == 1 ? _client : http.Client();
      final stopwatch = Stopwatch()..start();
      try {
        final response = await client
            .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
            .timeout(_perAttemptTimeout);
        debugPrint('[Gemini] attempt $attempt responded in ${stopwatch.elapsedMilliseconds}ms '
            '(status ${response.statusCode})');
        // 503 (model overloaded) and 429 (rate limited) are Google's own
        // documented "safe to retry shortly" statuses, unlike a 4xx
        // auth/validation error which retrying can't fix — back off a
        // little longer each attempt rather than hammering an already
        // overloaded model.
        if ((response.statusCode == 503 || response.statusCode == 429) && attempt < _maxAttempts) {
          debugPrint('[Gemini] attempt $attempt got HTTP ${response.statusCode}, retrying after backoff');
          await Future.delayed(const Duration(seconds: 2));
          continue;
        }
        return response;
      } on TimeoutException {
        debugPrint('[Gemini] attempt $attempt stalled past ${_perAttemptTimeout.inSeconds}s, '
            '${attempt < _maxAttempts ? "retrying" : "giving up"}');
        if (attempt == _maxAttempts) {
          throw const NutritionApiException('Gemini: request timed out');
        }
      } on SocketException catch (e) {
        throw NutritionApiException('Gemini: ${e.message}');
      } finally {
        if (attempt != 1) client.close();
      }
    }
    throw const NutritionApiException('Gemini: request timed out');
  }
}

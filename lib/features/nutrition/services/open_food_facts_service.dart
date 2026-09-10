import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../database/enums.dart';
import 'food_search_result.dart';

// Free, keyless, no rate limit that matters at our scale — see
// https://openfoodfacts.github.io. Every nutrient value is read from the
// "_100g"-suffixed keys (never "_serving", which is unstructured free text)
// and treated as nullable/missing since community-submitted products often
// lack a full nutrition breakdown.
//
// Text search goes through the search-a-licious service at a different
// domain (search.openfoodfacts.org) — the legacy /api/v2/search on
// world.openfoodfacts.org only supports structured field filters, not
// free-text relevance ranking, and silently returns near-random matches for
// a plain keyword query. Barcode lookup is unaffected and still uses the v2
// per-product endpoint on world.openfoodfacts.org.
class OpenFoodFactsService {
  final http.Client _client;
  OpenFoodFactsService({http.Client? client}) : _client = client ?? http.Client();

  static const _searchBase = 'https://search.openfoodfacts.org';
  static const _productBase = 'https://world.openfoodfacts.org';
  static const _timeout = Duration(seconds: 10);

  Future<List<FoodSearchResult>> searchByName(String query) async {
    final uri = Uri.parse('$_searchBase/search').replace(queryParameters: {
      'q': query,
      'page_size': '25',
      'fields': 'product_name,brands,code,nutriments',
    });
    final body = await _get(uri);
    final hits = (body['hits'] as List?) ?? const [];
    return hits
        .cast<Map<String, dynamic>>()
        .map(_parseProduct)
        .whereType<FoodSearchResult>()
        .toList();
  }

  Future<FoodSearchResult?> lookupBarcode(String barcode) async {
    final uri = Uri.parse('$_productBase/api/v2/product/$barcode.json').replace(queryParameters: {
      'fields': 'product_name,brands,code,nutriments',
    });
    final body = await _get(uri);
    if (body['status'] != 1) return null;
    final product = body['product'] as Map<String, dynamic>?;
    if (product == null) return null;
    return _parseProduct(product);
  }

  static const _kcalPerKj = 1 / 4.184;

  FoodSearchResult? _parseProduct(Map<String, dynamic> product) {
    final name = _stringOrNull(product['product_name'])?.trim();
    final nutriments = product['nutriments'] as Map<String, dynamic>?;
    if (name == null || name.isEmpty || nutriments == null) return null;

    // Some products only carry energy in kJ, not the kcal-suffixed field.
    final kcal = _numOrNull(nutriments['energy-kcal_100g']);
    final kj = _numOrNull(nutriments['energy-kj_100g']);
    final calories = kcal ?? (kj == null ? null : kj * _kcalPerKj);
    if (calories == null) return null;

    return FoodSearchResult(
      name: name,
      brand: _stringOrNull(product['brands'])?.split(',').first.trim(),
      caloriesPer100g: calories,
      proteinPer100g: _numOrNull(nutriments['proteins_100g']) ?? 0,
      carbsPer100g: _numOrNull(nutriments['carbohydrates_100g']) ?? 0,
      fatPer100g: _numOrNull(nutriments['fat_100g']) ?? 0,
      source: FoodLogSource.openFoodFacts,
      sourceId: _stringOrNull(product['code']),
    );
  }

  double? _numOrNull(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse('$value');
  }

  // Search-a-licious's indexed schema doesn't always match the raw product
  // schema types 1:1 — e.g. a field that's a plain string on the classic
  // product API can come back as a list (per-language values) or a map here.
  // Every text field is read defensively instead of a strict `as String?`.
  String? _stringOrNull(Object? value) {
    if (value == null) return null;
    if (value is String) return value.isEmpty ? null : value;
    if (value is List) {
      for (final item in value) {
        final s = _stringOrNull(item);
        if (s != null) return s;
      }
      return null;
    }
    if (value is Map) {
      final fallback = value.values.isEmpty ? null : value.values.first;
      return _stringOrNull(value['en']) ?? _stringOrNull(fallback);
    }
    return '$value';
  }

  Future<Map<String, dynamic>> _get(Uri uri) async {
    try {
      final response = await _client.get(uri, headers: {
        'User-Agent': 'LiftIt/1.0 (Flutter; Android)',
      }).timeout(_timeout);
      if (response.statusCode != 200) {
        throw NutritionApiException('Open Food Facts: HTTP ${response.statusCode}');
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } on NutritionApiException {
      rethrow;
    } on SocketException catch (e) {
      throw NutritionApiException('Open Food Facts: ${e.message}');
    } on TimeoutException {
      throw const NutritionApiException('Open Food Facts: request timed out');
    } on FormatException {
      throw const NutritionApiException('Open Food Facts: invalid response');
    }
  }
}

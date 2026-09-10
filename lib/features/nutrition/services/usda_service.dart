import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../database/enums.dart';
import 'food_search_result.dart';

// USDA FoodData Central — free forever, needs a free (non-billed,
// rate-limit-only) API key from api.data.gov. Strong for generic/raw foods,
// where Open Food Facts (a branded-product database) is weak.
// https://fdc.nal.usda.gov/api-guide
class UsdaService {
  final http.Client _client;
  UsdaService({http.Client? client}) : _client = client ?? http.Client();

  static const _base = 'https://api.nal.usda.gov/fdc/v1';
  static const _timeout = Duration(seconds: 10);

  // Standard USDA nutrient IDs. Energy has duplicate/derived entries in the
  // FDC nutrient list (e.g. Atwater General/Specific factors, ids 2047/2048)
  // — match id AND unit precisely rather than taking "the first energy-like
  // entry", or results silently come out wrong for some foods.
  static const _energyId = 1008;
  static const _proteinId = 1003;
  static const _fatId = 1004;
  static const _carbsId = 1005;

  Future<List<FoodSearchResult>> searchByName(String query, String apiKey) async {
    final uri = Uri.parse('$_base/foods/search').replace(queryParameters: {
      'query': query,
      'api_key': apiKey,
      'pageSize': '25',
    });
    final body = await _get(uri);
    final foods = (body['foods'] as List?) ?? const [];
    return foods
        .cast<Map<String, dynamic>>()
        .map(_parseFood)
        .whereType<FoodSearchResult>()
        .toList();
  }

  FoodSearchResult? _parseFood(Map<String, dynamic> food) {
    final name = (food['description'] as String?)?.trim();
    final nutrients = food['foodNutrients'] as List?;
    if (name == null || name.isEmpty || nutrients == null) return null;

    double? calories, protein, fat, carbs;
    for (final entry in nutrients.cast<Map<String, dynamic>>()) {
      final id = entry['nutrientId'] as int?;
      final value = (entry['value'] as num?)?.toDouble();
      if (value == null) continue;
      switch (id) {
        case _energyId:
          if ((entry['unitName'] as String?)?.toUpperCase() == 'KCAL') calories = value;
        case _proteinId:
          protein = value;
        case _fatId:
          fat = value;
        case _carbsId:
          carbs = value;
      }
    }
    if (calories == null) return null;

    return FoodSearchResult(
      name: name,
      brand: (food['brandOwner'] as String?)?.trim(),
      caloriesPer100g: calories,
      proteinPer100g: protein ?? 0,
      carbsPer100g: carbs ?? 0,
      fatPer100g: fat ?? 0,
      source: FoodLogSource.usda,
      sourceId: food['fdcId']?.toString(),
    );
  }

  Future<Map<String, dynamic>> _get(Uri uri) async {
    try {
      final response = await _client.get(uri).timeout(_timeout);
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const NutritionApiException('USDA: invalid API key');
      }
      if (response.statusCode != 200) {
        throw NutritionApiException('USDA: HTTP ${response.statusCode}');
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } on NutritionApiException {
      rethrow;
    } on SocketException catch (e) {
      throw NutritionApiException('USDA: ${e.message}');
    } on TimeoutException {
      throw const NutritionApiException('USDA: request timed out');
    } on FormatException {
      throw const NutritionApiException('USDA: invalid response');
    }
  }
}

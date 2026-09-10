import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/api_keys_provider.dart';
import '../services/food_search_result.dart';
import '../services/open_food_facts_service.dart';
import '../services/usda_service.dart';

final _openFoodFactsServiceProvider = Provider((ref) => OpenFoodFactsService());
final _usdaServiceProvider = Provider((ref) => UsdaService());

// True once the user has pasted their own free USDA key into Settings —
// watched separately from the search results so the search screen can show
// an explicit "USDA search is off" hint instead of silently only ever
// returning Open Food Facts matches.
final usdaKeyMissingProvider = Provider<bool>((ref) {
  return ref.watch(apiKeysProvider).usdaApiKey.trim().isEmpty;
});

Future<({List<FoodSearchResult> results, Object? error})> _safeSearch(
  Future<List<FoodSearchResult>> Function() search,
) async {
  try {
    return (results: await search(), error: null);
  } catch (e) {
    return (results: const <FoodSearchResult>[], error: e);
  }
}

// Submit-triggered (not live-as-you-type) — there's no debounce precedent in
// this app, and hammering a free-tier API on every keystroke is a good way
// to get a hobby project's IP rate-limited. Each source is queried
// concurrently and its failure caught independently, so one source going
// down (or USDA simply having no key set) never blanks the other's results.
// An error only surfaces to the caller when every source that was actually
// queried failed — otherwise an empty list would misleadingly read as "no
// results" instead of "the network/API is down".
final foodSearchResultsProvider =
    FutureProvider.family<List<FoodSearchResult>, String>((ref, query) async {
  final off = ref.watch(_openFoodFactsServiceProvider);
  final usda = ref.watch(_usdaServiceProvider);
  final usdaKey = ref.watch(apiKeysProvider).usdaApiKey.trim();
  final usdaQueried = usdaKey.isNotEmpty;

  final results = await Future.wait([
    _safeSearch(() => off.searchByName(query)),
    usdaQueried
        ? _safeSearch(() => usda.searchByName(query, usdaKey))
        : Future.value((results: const <FoodSearchResult>[], error: null)),
  ]);

  final merged = [...results[0].results, ...results[1].results];
  final allFailed = results[0].error != null && (!usdaQueried || results[1].error != null);
  if (merged.isEmpty && allFailed) {
    throw results[0].error!;
  }
  return merged;
});

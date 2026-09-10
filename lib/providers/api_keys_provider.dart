import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _geminiKeyPrefKey = 'geminiApiKey';
const _usdaKeyPrefKey = 'usdaApiKey';

class ApiKeysState {
  final String geminiApiKey;
  final String usdaApiKey;

  const ApiKeysState({this.geminiApiKey = '', this.usdaApiKey = ''});

  ApiKeysState copyWith({String? geminiApiKey, String? usdaApiKey}) {
    return ApiKeysState(
      geminiApiKey: geminiApiKey ?? this.geminiApiKey,
      usdaApiKey: usdaApiKey ?? this.usdaApiKey,
    );
  }
}

// User-provided, free-tier keys pasted into Settings — never a compiled-in
// secret, since this app has no backend to hide one behind. Kept in
// SharedPreferences (same tier as theme/locale), which is why these are
// intentionally NOT included in the SQLite backup/restore file.
class ApiKeysNotifier extends Notifier<ApiKeysState> {
  @override
  ApiKeysState build() {
    _load();
    return const ApiKeysState();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = ApiKeysState(
      geminiApiKey: prefs.getString(_geminiKeyPrefKey) ?? '',
      usdaApiKey: prefs.getString(_usdaKeyPrefKey) ?? '',
    );
  }

  // A plain `ref.read(apiKeysProvider).geminiApiKey` right after cold start
  // can race _load()'s SharedPreferences read and see the empty default
  // even when a key really is saved — the first camera-scan attempt would
  // wrongly report "key missing", then work on the very next tap once
  // _load() had caught up. Go straight to SharedPreferences when the
  // cached state still looks empty so that check is never wrong just
  // because of this timing.
  Future<String> ensureGeminiApiKey() async {
    if (state.geminiApiKey.isNotEmpty) return state.geminiApiKey;
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(_geminiKeyPrefKey) ?? '';
    if (key.isNotEmpty) state = state.copyWith(geminiApiKey: key);
    return key;
  }

  Future<void> setGeminiApiKey(String value) async {
    state = state.copyWith(geminiApiKey: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_geminiKeyPrefKey, value);
  }

  Future<void> setUsdaApiKey(String value) async {
    state = state.copyWith(usdaApiKey: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usdaKeyPrefKey, value);
  }
}

final apiKeysProvider = NotifierProvider<ApiKeysNotifier, ApiKeysState>(ApiKeysNotifier.new);

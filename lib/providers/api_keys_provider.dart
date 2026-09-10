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

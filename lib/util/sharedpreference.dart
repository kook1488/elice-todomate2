import 'package:shared_preferences/shared_preferences.dart';

//간단한 sqlite DB, 간편한 저장소,,로그인페이지에서
class TodoSharedPreference {
  static TodoSharedPreference? _instance;
  static SharedPreferences? _prefs;

  TodoSharedPreference._internal();

  factory TodoSharedPreference() =>
      _instance ??= TodoSharedPreference._internal();

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  // 데이터 저장
  Future<void> setPreferenceWithKey(String key, String value) async {
    SharedPreferences preferences = await prefs;
    preferences.setString(key, value);
  }

  // 데이터 읽기
  Future<String> getPreferenceWithKey(String key) async {
    SharedPreferences preferences = await prefs;
    return preferences.getString(key) ?? "";
  }

  // 데이터 삭제
  Future<void> removePreferenceWithKey(String key) async {
    SharedPreferences preferences = await prefs;
    await preferences.remove(key);
  }

  // 전체 데이터 삭제
  Future<void> clearPreference() async {
    SharedPreferences preferences = await prefs;
    await preferences.clear();
  }
}

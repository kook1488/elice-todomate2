import 'package:shared_preferences/shared_preferences.dart';

class TodoSharedPreference{
  static final TodoSharedPreference _instance = TodoSharedPreference._internal();
  factory TodoSharedPreference() => _instance;

  static SharedPreferences? _prefs;

  TodoSharedPreference._internal()

  Future<SharedPreferences?> get prefs async{
    if(_prefs != null) return _prefs;

    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }
}

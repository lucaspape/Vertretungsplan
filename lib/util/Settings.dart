import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  bool _initialized = false;

  late SharedPreferences sharedPreferences;

  Future _init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    _initialized = true;
  }

  Future reset() async {
    if (!_initialized) {
      await _init();
    }

    return sharedPreferences.clear();
  }

  setString(String key, String string) async {
    if (!_initialized) {
      await _init();
    }

    sharedPreferences.setString(key, string);
  }

  getString(String key) async {
    if (!_initialized) {
      await _init();
    }

    return sharedPreferences.getString(key);
  }

  setInt(String key, int integer) async {
    if (!_initialized) {
      await _init();
    }

    return sharedPreferences.setInt(key, integer);
  }

  getInt(String key) async {
    if (!_initialized) {
      await _init();
    }

    return sharedPreferences.getInt(key);
  }
}

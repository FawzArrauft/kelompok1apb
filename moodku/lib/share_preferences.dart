import 'package:shared_preferences/shared_preferences.dart';

class prefs {
  static Future<SharedPreferences> getPref() async =>
      await SharedPreferences.getInstance();

  static Future setString(String key, String value) async =>
      (await getPref()).setString(key, value);

  static Future<String?> getString(String key) async =>
      (await getPref()).getString(key);

  static Future remove(String key) async => (await getPref()).remove(key);
}

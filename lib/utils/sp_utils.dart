import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static SharedPreferences preferences;

  static Future<SharedPreferences> init() async {
    preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  static bool checkNotNull() {
    return preferences != null;
  }

  static String getString(String key, String defValue) {
    if (!checkNotNull()) {
      return defValue;
    }
    return preferences.getString(key) ?? defValue;
  }

  static int getInt(String key, int defValue) {
    if (!checkNotNull()) {
      return defValue;
    }
    return preferences.getInt(key) ?? defValue;
  }

  static void setString(String key, String value) {
    if (!checkNotNull()) {
      return;
    }
    preferences.setString(key, value);
  }

  static void setInt(String key, int value) {
    if (!checkNotNull()) {
      return;
    }
    preferences.setInt(key, value);
  }
}

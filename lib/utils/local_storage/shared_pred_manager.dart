import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPredManager extends GetxService {
  late SharedPreferences prefs;

  Future<SharedPredManager> init() async {
    prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> saveString(String key, String value) async {
    try {
      await prefs.setString(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  String? getString(String key) {
    return prefs.getString(key);
  }

  Future<void> deleteString(String key) async {
    await prefs.remove(key);
  }

  Future<void> clearAll() async {
    try {
      await prefs.clear();
    } catch (e) {
      throw Exception(e);
    }
  }
}
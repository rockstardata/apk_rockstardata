import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Servicio para manejar la persistencia de datos
class StorageService {
  static final StorageService instance = StorageService._internal();
  StorageService._internal();

  Future<SharedPreferences> get _prefs async =>
      SharedPreferences.getInstance();

  // Métodos genéricos
  Future<void> setString(String key, String value) async {
    final prefs = await _prefs;
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    final prefs = await _prefs;
    return prefs.getBool(key);
  }

  Future<void> setInt(String key, int value) async {
    final prefs = await _prefs;
    await prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    final prefs = await _prefs;
    return prefs.getInt(key);
  }

  Future<void> setDouble(String key, double value) async {
    final prefs = await _prefs;
    await prefs.setDouble(key, value);
  }

  Future<double?> getDouble(String key) async {
    final prefs = await _prefs;
    return prefs.getDouble(key);
  }

  Future<void> setStringList(String key, List<String> value) async {
    final prefs = await _prefs;
    await prefs.setStringList(key, value);
  }

  Future<List<String>?> getStringList(String key) async {
    final prefs = await _prefs;
    return prefs.getStringList(key);
  }

  // Métodos específicos para la app
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await _prefs;
    await prefs.setString('user_data', jsonEncode(userData));
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await _prefs;
    final data = prefs.getString('user_data');
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> saveMetrics(Map<String, double> metrics) async {
    final prefs = await _prefs;
    await prefs.setString('metrics', jsonEncode(metrics));
  }

  Future<Map<String, double>?> getMetrics() async {
    final prefs = await _prefs;
    final data = prefs.getString('metrics');
    if (data != null) {
      final map = jsonDecode(data) as Map<String, dynamic>;
      return map.map((key, value) => MapEntry(key, (value as num).toDouble()));
    }
    return null;
  }

  Future<void> saveList(String key, List<double> list) async {
    final prefs = await _prefs;
    await prefs.setString(key, jsonEncode(list));
  }

  Future<List<double>?> getList(String key) async {
    final prefs = await _prefs;
    final data = prefs.getString(key);
    if (data != null) {
      final list = jsonDecode(data) as List<dynamic>;
      return list.map((e) => (e as num).toDouble()).toList();
    }
    return null;
  }

  Future<void> clear() async {
    final prefs = await _prefs;
    await prefs.clear();
  }

  Future<void> remove(String key) async {
    final prefs = await _prefs;
    await prefs.remove(key);
  }
}


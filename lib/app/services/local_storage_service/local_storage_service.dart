import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService._internal();

  static final LocalStorageService _instance = LocalStorageService._internal();

  factory LocalStorageService() => _instance;

  SharedPreferences? _prefs;

  SharedPreferences get prefs {
    final instance = _prefs;
    if (instance == null) {
      throw StateError(
        'LocalStorageService is not initialized. Call init() first.',
      );
    }
    return instance;
  }

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<bool> saveString(String key, String value) {
    return prefs.setString(key, value);
  }

  String? getString(String key) {
    return prefs.getString(key);
  }

  Future<bool> saveBool(String key, bool value) {
    return prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return prefs.getBool(key);
  }

  Future<bool> saveInt(String key, int value) {
    return prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return prefs.getInt(key);
  }

  Future<bool> saveDouble(String key, double value) {
    return prefs.setDouble(key, value);
  }

  double? getDouble(String key) {
    return prefs.getDouble(key);
  }

  Future<bool> saveStringList(String key, List<String> value) {
    return prefs.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return prefs.getStringList(key);
  }

  Future<bool> saveMap(String key, Map<String, dynamic> value) {
    return prefs.setString(key, jsonEncode(value));
  }

  Map<String, dynamic>? getMap(String key) {
    final jsonString = prefs.getString(key);
    if (jsonString == null || jsonString.isEmpty) return null;

    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return Map<String, dynamic>.from(decoded as Map);
    } catch (error) {
      log('LocalStorageService.getMap error for key "$key": $error');
      return null;
    }
  }

  Future<bool> saveJsonList(String key, List<Map<String, dynamic>> value) {
    return prefs.setString(key, jsonEncode(value));
  }

  List<Map<String, dynamic>>? getJsonList(String key) {
    final jsonString = prefs.getString(key);
    if (jsonString == null || jsonString.isEmpty) return null;

    try {
      final decoded = jsonDecode(jsonString);

      if (decoded is! List) return null;

      return decoded
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } catch (error) {
      log('LocalStorageService.getJsonList error for key "$key": $error');
      return null;
    }
  }

  Future<bool> saveDynamicList(String key, List<dynamic> value) {
    return prefs.setString(key, jsonEncode(value));
  }

  List<dynamic>? getDynamicList(String key) {
    final jsonString = prefs.getString(key);
    if (jsonString == null || jsonString.isEmpty) return null;

    try {
      final decoded = jsonDecode(jsonString);
      return decoded is List ? decoded : null;
    } catch (error) {
      log('LocalStorageService.getDynamicList error for key "$key": $error');
      return null;
    }
  }

  Future<bool> remove(String key) {
    return prefs.remove(key);
  }

  Future<bool> clear() {
    return prefs.clear();
  }

  bool containsKey(String key) {
    return prefs.containsKey(key);
  }
}

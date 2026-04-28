import 'package:flutter/material.dart';
import 'package:dreamhome/app/services/local_storage_service/storage_key.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';

class GlobalDetails extends ChangeNotifier {
  static final GlobalDetails instance = GlobalDetails._();

  GlobalDetails._();

  bool _isInitialized = false;

  bool? _firstLaunch;
  bool? _isLogin;
  String? _token;
  String? _refreshToken;

  // ---------------- INIT ----------------
  Future<void> init() async {
    _token = localStorageService.getString(StorageKeys.token);
    _refreshToken = localStorageService.getString(StorageKeys.refreshToken);
    _firstLaunch = localStorageService.getBool(StorageKeys.firstLunch);
    _isLogin = localStorageService.getBool(StorageKeys.isLogin);

    _isInitialized = true;
    notifyListeners();
  }

  bool get isInitialized => _isInitialized;

  // ---------------- TOKEN ----------------
  Future<void> setToken(String? value) async {
    _token = value;

    if (value == null || value.isEmpty) {
      await localStorageService.remove(StorageKeys.token);
    } else {
      await localStorageService.saveString(StorageKeys.token, value);
    }

    notifyListeners();
  }

  // ---------------- REFRESH TOKEN ----------------
  Future<void> setRefreshToken(String? value) async {
    _refreshToken = value;

    if (value == null || value.isEmpty) {
      await localStorageService.remove(StorageKeys.refreshToken);
    } else {
      await localStorageService.saveString(StorageKeys.refreshToken, value);
    }

    notifyListeners();
  }

  // ---------------- LOGIN ----------------
  Future<void> setLogin(bool value) async {
    _isLogin = value;

    await localStorageService.saveBool(StorageKeys.isLogin, value);

    notifyListeners();
  }

  // ---------------- FIRST LAUNCH ----------------
  Future<void> setFirstLaunch(bool value) async {
    _firstLaunch = value;

    await localStorageService.saveBool(StorageKeys.firstLunch, value);

    notifyListeners();
  }

  // ---------------- CLEAR SESSION ----------------
  Future<void> clearAuth() async {
    _token = null;
    _refreshToken = null;
    _isLogin = false;

    await localStorageService.remove(StorageKeys.token);
    await localStorageService.remove(StorageKeys.refreshToken);
    await localStorageService.saveBool(StorageKeys.isLogin, false);

    notifyListeners();
  }

  // ---------------- GETTERS ----------------
  String? get token => _token;
  String? get refreshToken => _refreshToken;
  bool get isLogin => _isLogin ?? false;
  bool get isFirstLaunch => _firstLaunch ?? true;
}

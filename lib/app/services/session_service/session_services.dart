import 'dart:async';
import 'dart:developer';

import 'package:dreamhome/app/services/local_storage_service/storage_key.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:dreamhome/app/views/login_screen/login_screen.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SessionServices {
  Timer? _authTimer;
  bool _isLoggingOut = false;

  void startAuthCheck({required String token}) {
    _authTimer?.cancel();

    if (JwtDecoder.isExpired(token)) {
      refreshOrLogout();
      return;
    }

    final expiryDate = JwtDecoder.getExpirationDate(token);
    final timeToExpiry = expiryDate.difference(DateTime.now());

    if (timeToExpiry.isNegative) {
      refreshOrLogout();
      return;
    }

    final refreshBeforeExpiry = timeToExpiry - const Duration(minutes: 1);

    log('Access token expires in: $timeToExpiry');

    _authTimer = Timer(
      refreshBeforeExpiry.isNegative ? Duration.zero : refreshBeforeExpiry,
      refreshOrLogout,
    );
  }

  void checkNow() {
    final token = globalDetails.token;

    if (token == null || token.isEmpty || JwtDecoder.isExpired(token)) {
      _authTimer?.cancel();
      refreshOrLogout();
    }
  }

  Future<void> refreshOrLogout() async {
    final refreshed = await tokenRefreshService.refreshToken();

    if (refreshed && globalDetails.token != null) {
      startAuthCheck(token: globalDetails.token!);
      return;
    }

    await logout();
  }

  Future<void> logout() async {
    if (_isLoggingOut) return;

    _isLoggingOut = true;
    _authTimer?.cancel();

    await globalDetails.setToken(null);
    await globalDetails.setRefreshToken(null);
    await globalDetails.setLogin(false);

    await localStorageService.remove(StorageKeys.token);
    await localStorageService.remove(StorageKeys.refreshToken);
    await localStorageService.remove(StorageKeys.isLogin);
    await localStorageService.saveBool(StorageKeys.isLogin, false);

    navigationService.pushAndRemoveUntil(LoginScreen());

    _isLoggingOut = false;
  }

  Future<void> stopAuthCheck() async {
    _authTimer?.cancel();
    await logout();
  }
}

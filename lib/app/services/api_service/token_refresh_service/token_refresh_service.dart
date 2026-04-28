import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dreamhome/app/apis/base_url/endpoint_url.dart';
import 'package:dreamhome/app/services/local_storage_service/storage_key.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';

class TokenRefreshService {
  final Dio _dio;

  TokenRefreshService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: Endpoints.baseUrl,
              connectTimeout: const Duration(seconds: 60),
              receiveTimeout: const Duration(seconds: 60),
              sendTimeout: const Duration(seconds: 60),
              responseType: ResponseType.json,
              validateStatus: (_) => true,
            ),
          );

  static const String refreshEndpoint = '/auth/refresh-token';

  Future<bool> refreshToken() async {
    final currentRefreshToken = globalDetails.refreshToken;

    log('CALLING REFRESH TOKEN...');
    log('CURRENT REFRESH TOKEN: $currentRefreshToken');

    if (currentRefreshToken == null || currentRefreshToken.isEmpty) {
      log('No refresh token available');
      return false;
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        refreshEndpoint,
        data: {'refreshToken': currentRefreshToken},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Cookie': 'refreshToken=$currentRefreshToken',
          },
          extra: {'skipAuth': true},
        ),
      );

      log('REFRESH URL: ${response.realUri}');
      log('REFRESH STATUS: ${response.statusCode}');
      log('REFRESH BODY: ${response.data}');

      final statusCode = response.statusCode ?? 0;

      if (statusCode < 200 || statusCode >= 300) {
        return false;
      }

      final responseBody = response.data;
      if (responseBody == null) return false;

      final tokenData = responseBody['data'];

      if (tokenData is! Map<String, dynamic>) {
        log('Invalid refresh response: data missing');
        return false;
      }

      final newAccessToken = tokenData['accessToken']?.toString();
      final newRefreshToken = tokenData['refreshToken']?.toString();

      if (newAccessToken == null ||
          newAccessToken.isEmpty ||
          newRefreshToken == null ||
          newRefreshToken.isEmpty) {
        log('Invalid refresh response: missing tokens');
        return false;
      }

      await globalDetails.setToken(newAccessToken);
      await globalDetails.setRefreshToken(newRefreshToken);
      await globalDetails.setLogin(true);

      await localStorageService.saveString(StorageKeys.token, newAccessToken);
      await localStorageService.saveString(
        StorageKeys.refreshToken,
        newRefreshToken,
      );
      await localStorageService.saveBool(StorageKeys.isLogin, true);

      log('REFRESH SUCCESS');

      return true;
    } catch (error) {
      log('REFRESH EXCEPTION: $error');
      return false;
    }
  }
}

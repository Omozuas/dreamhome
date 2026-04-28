import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dreamhome/app/apis/base_service/api_failure.dart';
import 'package:dreamhome/app/apis/base_service/dio_client.dart';

class ApiService {
  ApiService({required this.path});

  final String path;

  String _normalizePath(String subPath) {
    final base = path.endsWith('/') ? path.substring(0, path.length - 1) : path;
    final cleanPath = subPath.startsWith('/') ? subPath : '/$subPath';
    return '$base$cleanPath';
  }

  Future<dynamic> get({
    required String path,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) {
    return _request(
      method: 'GET',
      path: path,
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
    );
  }

  Future<dynamic> post({
    required String path,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) {
    return _request(
      method: 'POST',
      path: path,
      body: body ?? <String, dynamic>{},
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
    );
  }

  Future<dynamic> put({
    required String path,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) {
    return _request(
      method: 'PUT',
      path: path,
      body: body ?? <String, dynamic>{},
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
    );
  }

  Future<dynamic> patch({
    required String path,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) {
    return _request(
      method: 'PATCH',
      path: path,
      body: body ?? <String, dynamic>{},
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
    );
  }

  Future<dynamic> delete({
    required String path,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) {
    return _request(
      method: 'DELETE',
      path: path,
      body: body,
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
    );
  }

  Future<dynamic> _request({
    required String method,
    required String path,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    required bool requiresAuth,
  }) {
    return _retryWithBackoff<dynamic>(() async {
      final isFormData = body is FormData;

      final response = await DioClient.instance.request<dynamic>(
        _normalizePath(path),
        data: body,
        queryParameters: queryParameters,
        options: Options(
          method: method,
          contentType: isFormData ? 'multipart/form-data' : null,
          extra: {'skipAuth': !requiresAuth},
        ),
      );

      final statusCode = response.statusCode ?? 0;

      log('$method ${_normalizePath(path)}');
      log('STATUS: $statusCode');
      log('RESPONSE BODY: ${response.data}');

      if (statusCode >= 200 && statusCode < 300) {
        return response.data;
      }

      throw ApiFailure.fromError(response);
    });
  }

  Future<T> _retryWithBackoff<T>(
    Future<T> Function() action, {
    int maxRetries = 3,
    Duration initialDelay = const Duration(milliseconds: 500),
  }) async {
    var attempt = 0;
    var delay = initialDelay;

    while (true) {
      try {
        return await action();
      } catch (error) {
        if (!_shouldRetry(error)) {
          throw ApiFailure.fromError(error);
        }

        attempt++;

        if (attempt > maxRetries) {
          throw ApiFailure.fromError(error);
        }

        log('Retry #$attempt after $delay due to: $error');

        await Future.delayed(delay);
        delay *= 2;
      }
    }
  }

  bool _shouldRetry(Object error) {
    if (error is SocketException ||
        error is TimeoutException ||
        error is HandshakeException ||
        error is OSError) {
      return true;
    }

    if (error is DioException) {
      return error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.unknown;
    }

    return false;
  }
}

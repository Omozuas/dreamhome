import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dreamhome/app/apis/base_service/api_failure.dart';
import 'package:dreamhome/app/apis/base_url/endpoint_url.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';

class ApiBaseService {
  ApiBaseService({required this.path, Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      baseUrl: _normalizedBaseUrl,
      connectTimeout: timeoutDuration,
      receiveTimeout: timeoutDuration,
      sendTimeout: timeoutDuration,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers.addAll(_headers);

          log('${options.method} ${options.uri}');

          if (options.data != null) {
            log('REQUEST BODY: ${options.data}');
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          log('STATUS: ${response.statusCode}');
          log('RESPONSE BODY: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          log('DIO ERROR: ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  final String path;
  final Dio _dio;

  static const Duration timeoutDuration = Duration(seconds: 60);

  String get _normalizedBaseUrl {
    final baseUrl = Endpoints.baseUrl.endsWith('/')
        ? Endpoints.baseUrl.substring(0, Endpoints.baseUrl.length - 1)
        : Endpoints.baseUrl;

    final servicePath = path.startsWith('/') ? path : '/$path';
    final cleanServicePath = servicePath.endsWith('/')
        ? servicePath.substring(0, servicePath.length - 1)
        : servicePath;

    return '$baseUrl$cleanServicePath';
  }

  Map<String, dynamic> get _headers => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    if (globalDetails.token != null && globalDetails.token!.isNotEmpty)
      'Authorization': 'Bearer ${globalDetails.token}',
  };

  String _normalizePath(String subPath) {
    return subPath.startsWith('/') ? subPath : '/$subPath';
  }

  Future<dynamic> get({
    required String path,
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      method: 'GET',
      path: path,
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> post({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      method: 'POST',
      path: path,
      body: body ?? <String, dynamic>{},
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> put({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      method: 'PUT',
      path: path,
      body: body ?? <String, dynamic>{},
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> patch({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      method: 'PATCH',
      path: path,
      body: body ?? <String, dynamic>{},
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> delete({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      method: 'DELETE',
      path: path,
      body: body,
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> _request({
    required String method,
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) {
    return retryWithBackoff<dynamic>(() async {
      final response = await _dio.request<dynamic>(
        _normalizePath(path),
        data: body,
        queryParameters: queryParameters,
        options: Options(method: method),
      );

      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        return response.data;
      }

      throw ApiFailure.fromError(response);
    });
  }

  Future<T> retryWithBackoff<T>(
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

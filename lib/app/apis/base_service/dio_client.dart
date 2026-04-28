import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dreamhome/app/apis/base_service/api_failure.dart';
import 'package:dreamhome/app/apis/base_url/endpoint_url.dart';
import 'package:dreamhome/app/services/api_service/token_refresh_service/token_refresh_service.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';

class DioClient {
  DioClient._();

  static Completer<bool>? _refreshCompleter;

  static final Dio instance =
      Dio(
          BaseOptions(
            baseUrl: Endpoints.baseUrl,
            connectTimeout: const Duration(seconds: 60),
            receiveTimeout: const Duration(seconds: 60),
            sendTimeout: const Duration(seconds: 60),
            responseType: ResponseType.json,
            validateStatus: (_) => true,
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              if (options.extra['skipAuth'] != true) {
                final token = globalDetails.token;
                final refresh = globalDetails.refreshToken;

                if (token != null && token.isNotEmpty) {
                  options.headers['Authorization'] = 'Bearer $token';
                }

                if (refresh != null && refresh.isNotEmpty) {
                  options.headers['Cookie'] = 'refreshToken=$refresh';
                }
              }

              options.headers['Accept'] = 'application/json';

              if (options.data is FormData) {
                options.contentType = 'multipart/form-data';
                options.headers.remove('Content-Type');
              } else {
                options.contentType = 'application/json';
              }

              log('${options.method} ${options.uri}');

              if (options.data != null) {
                log('REQUEST BODY: ${options.data}');
              }

              handler.next(options);
            },
            onResponse: (response, handler) async {
              log('STATUS: ${response.statusCode}');
              log('RESPONSE BODY: ${response.data}');

              if (_shouldHandleUnauthorized(response)) {
                final retryResponse = await _handleUnauthorizedResponse(
                  response,
                );

                if (retryResponse != null) {
                  handler.resolve(retryResponse);
                  return;
                }

                await sessionService.logout();

                handler.reject(
                  DioException(
                    requestOptions: response.requestOptions,
                    response: response,
                    type: DioExceptionType.badResponse,
                    error: ApiFailure.fromError(response),
                  ),
                );
                return;
              }

              handler.next(response);
            },
            onError: (error, handler) async {
              if (error.response != null &&
                  _shouldHandleUnauthorized(error.response!)) {
                final retryResponse = await _handleUnauthorizedResponse(
                  error.response!,
                );

                if (retryResponse != null) {
                  handler.resolve(retryResponse);
                  return;
                }

                await sessionService.logout();
              }

              handler.next(error);
            },
          ),
        );

  static bool _shouldHandleUnauthorized(Response<dynamic> response) {
    log('CHECKING 401 HANDLER...');
    log('STATUS CODE: ${response.statusCode}');
    log('SKIP AUTH: ${response.requestOptions.extra['skipAuth']}');
    log('RETRIED: ${response.requestOptions.extra['retried']}');
    log('PATH: ${response.requestOptions.path}');

    if (response.statusCode != 401 || response.statusCode != 403) return false;

    final requestOptions = response.requestOptions;

    if (requestOptions.extra['skipAuth'] == true) return false;
    if (requestOptions.extra['retried'] == true) return false;

    final path = requestOptions.path;

    if (path.contains(TokenRefreshService.refreshEndpoint)) {
      return false;
    }

    return true;
  }

  static Future<Response<dynamic>?> _handleUnauthorizedResponse(
    Response<dynamic> response,
  ) async {
    log('401 DETECTED. TRYING REFRESH TOKEN...');

    final refreshed = await _refreshAccessToken();

    log('REFRESH RESULT: $refreshed');

    if (!refreshed) {
      return null;
    }

    return _retryRequest(response.requestOptions);
  }

  static Future<bool> _refreshAccessToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    final completer = Completer<bool>();
    _refreshCompleter = completer;

    try {
      final refreshed = await tokenRefreshService.refreshToken();
      completer.complete(refreshed);
      return refreshed;
    } catch (error) {
      completer.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  static Future<Response<dynamic>> _retryRequest(
    RequestOptions requestOptions,
  ) {
    final token = globalDetails.token;

    final headers = Map<String, dynamic>.from(requestOptions.headers);

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return instance.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      cancelToken: requestOptions.cancelToken,
      onReceiveProgress: requestOptions.onReceiveProgress,
      onSendProgress: requestOptions.onSendProgress,
      options: Options(
        method: requestOptions.method,
        headers: headers,
        contentType: requestOptions.contentType,
        responseType: requestOptions.responseType,
        followRedirects: requestOptions.followRedirects,
        receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
        validateStatus: (_) => true,
        extra: {...requestOptions.extra, 'retried': true},
      ),
    );
  }
}

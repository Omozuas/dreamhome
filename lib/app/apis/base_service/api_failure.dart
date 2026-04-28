// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

class ApiFailure implements Exception {
  final String message;
  final int? statusCode;

  const ApiFailure(this.message, {this.statusCode});

  factory ApiFailure.fromError(dynamic error) {
    log('ApiFailure: $error');

    if (error is ApiFailure) {
      return error;
    }

    if (error is DioException) {
      return _fromDioException(error);
    }

    if (error is Response) {
      return _fromDioResponse(error);
    }

    if (error is SocketException) {
      return const ApiFailure(
        'No internet connection. Please check your network.',
      );
    }

    if (error is TimeoutException) {
      return const ApiFailure(
        'The connection has timed out. Please try again.',
      );
    }

    if (error is HandshakeException) {
      return const ApiFailure(
        'Secure connection failed. Please try again later.',
      );
    }

    if (error is FormatException) {
      return const ApiFailure('Bad response format. Please try again later.');
    }

    if (error is OSError) {
      return ApiFailure('System network error: ${error.message}');
    }

    if (error is HttpException) {
      return ApiFailure('HTTP Exception: ${error.message}');
    }

    return ApiFailure('Unexpected error occurred: ${error.toString()}');
  }

  static ApiFailure _fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const ApiFailure('Connection timeout. Please try again.');

      case DioExceptionType.sendTimeout:
        return const ApiFailure('Request timeout. Please try again.');

      case DioExceptionType.receiveTimeout:
        return const ApiFailure('Server response timeout. Please try again.');

      case DioExceptionType.badCertificate:
        return const ApiFailure(
          'Secure connection failed. Invalid certificate.',
        );

      case DioExceptionType.connectionError:
        return const ApiFailure(
          'No internet connection. Please check your network.',
        );

      case DioExceptionType.cancel:
        return const ApiFailure('Request was cancelled.');

      case DioExceptionType.badResponse:
        final response = error.response;
        if (response != null) {
          return _fromDioResponse(response);
        }

        return const ApiFailure('Bad server response. Please try again.');

      case DioExceptionType.unknown:
        final originalError = error.error;

        if (originalError is SocketException) {
          return const ApiFailure(
            'No internet connection. Please check your network.',
          );
        }

        if (originalError is HandshakeException) {
          return const ApiFailure(
            'Secure connection failed. Please try again later.',
          );
        }

        return ApiFailure(
          error.message ?? 'Unexpected network error occurred.',
        );
    }
  }

  static ApiFailure _fromDioResponse(Response response) {
    final statusCode = response.statusCode ?? 0;
    final fallbackMessage = _handleStatusCode(statusCode);
    final data = response.data;

    if (data == null) {
      return ApiFailure(fallbackMessage, statusCode: statusCode);
    }

    if (data is String) {
      final trimmed = data.trimLeft();

      final isHtml =
          trimmed.startsWith('<!DOCTYPE') ||
          trimmed.startsWith('<html') ||
          trimmed.contains('<html');

      if (isHtml) {
        return ApiFailure(fallbackMessage, statusCode: statusCode);
      }

      try {
        final decoded = jsonDecode(data);
        return _fromDecodedBody(decoded, fallbackMessage, statusCode);
      } catch (_) {
        return ApiFailure(fallbackMessage, statusCode: statusCode);
      }
    }

    if (data is Map<String, dynamic>) {
      return _fromDecodedBody(data, fallbackMessage, statusCode);
    }

    return ApiFailure(fallbackMessage, statusCode: statusCode);
  }

  static ApiFailure _fromDecodedBody(
    dynamic body,
    String fallbackMessage,
    int statusCode,
  ) {
    if (body is! Map<String, dynamic>) {
      return ApiFailure(fallbackMessage, statusCode: statusCode);
    }

    final message = _extractMessage(body) ?? fallbackMessage;

    return ApiFailure(message, statusCode: statusCode);
  }

  static String? _extractMessage(Map<String, dynamic> body) {
    final message =
        body['message'] ?? body['error'] ?? body['detail'] ?? body['errors'];

    if (message is String && message.trim().isNotEmpty) {
      return message;
    }

    if (message is List && message.isNotEmpty) {
      final first = message.first;
      if (first is String && first.trim().isNotEmpty) {
        return first;
      }
    }

    if (message is Map && message.isNotEmpty) {
      final firstValue = message.values.first;

      if (firstValue is String && firstValue.trim().isNotEmpty) {
        return firstValue;
      }

      if (firstValue is List && firstValue.isNotEmpty) {
        final first = firstValue.first;
        if (first is String && first.trim().isNotEmpty) {
          return first;
        }
      }
    }

    return null;
  }

  static String _handleStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please log in again.';
      case 403:
        return "Forbidden. You don't have permission to access this.";
      case 404:
        return 'Resource not found.';
      case 409:
        return 'Conflict occurred. Item may already exist.';
      case 422:
        return 'Unprocessable data. Please validate your input.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Server error. Please try again later.';
      case 502:
        return 'Bad Gateway. Server is temporarily unreachable.';
      case 503:
        return 'Service unavailable. Please try again shortly.';
      case 504:
        return 'Server timeout. The server took too long to respond.';
      default:
        return 'Unexpected error occurred. [Code: $statusCode]';
    }
  }

  ApiFailure copyWith({String? message, int? statusCode}) {
    return ApiFailure(
      message ?? this.message,
      statusCode: statusCode ?? this.statusCode,
    );
  }

  @override
  String toString() {
    return 'ApiFailure(message: $message, statusCode: $statusCode)';
  }

  @override
  bool operator ==(covariant ApiFailure other) {
    if (identical(this, other)) return true;

    return other.message == message && other.statusCode == statusCode;
  }

  @override
  int get hashCode => Object.hash(message, statusCode);
}

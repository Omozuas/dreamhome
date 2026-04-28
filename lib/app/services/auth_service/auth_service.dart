import 'dart:developer';

import 'package:dreamhome/app/apis/model/api_respond.dart';
import 'package:dreamhome/app/apis/model/login_respons.dart';
import 'package:dreamhome/app/services/api_service/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  AuthService(this.ref);

  final Ref ref;

  final ApiService _apiService = ApiService(path: '/auth');

  Future<ApiResponsModel<LoginResponedModel>> login({
    required Map<String, dynamic> body,
  }) async {
    final response = await _apiService.post(
      path: '/login',
      body: body,
      requiresAuth: false,
    );

    log('Login response: $response');

    return ApiResponsModel.fromJson(response)
      ..data = LoginResponedModel.fromJson(response["data"]);
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});

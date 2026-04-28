import 'package:dreamhome/app/apis/base_service/api_failure.dart';
import 'package:dreamhome/app/apis/model/api_respond.dart';
import 'package:dreamhome/app/apis/model/login_respons.dart';
import 'package:dreamhome/app/services/auth_service/auth_service.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final loginProvider =
    StateNotifierProvider.autoDispose<
      LoginNotifier,
      AsyncValue<ApiResponsModel<LoginResponedModel>?>
    >((ref) {
      return LoginNotifier(authService: ref.read(authServiceProvider));
    });

class LoginNotifier
    extends StateNotifier<AsyncValue<ApiResponsModel<LoginResponedModel>?>> {
  LoginNotifier({required AuthService authService})
    : _authService = authService,
      super(const AsyncValue.data(null));

  final AuthService _authService;

  Future<bool> login({required String email, required String password}) async {
    state = const AsyncValue.loading();

    try {
      final response = await _authService.login(
        body: {'email': email.trim(), 'password': password.trim()},
      );

      await globalDetails.setToken(response.data?.token);
      await globalDetails.setRefreshToken(response.data?.refreshToken);
      await globalDetails.setLogin(true);

      sessionService.startAuthCheck(token: response.data?.token ?? '');

      state = AsyncValue.data(response);
      return true;
    } on ApiFailure catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }
}

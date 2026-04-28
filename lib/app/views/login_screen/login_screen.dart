import 'package:dreamhome/app/apis/base_service/api_failure.dart';
import 'package:dreamhome/app/common/app_text_style.dart';
import 'package:dreamhome/app/common/custom_button.dart';
import 'package:dreamhome/app/common/custom_input.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:dreamhome/app/services/provider_service/login_repo.dart';
import 'package:dreamhome/app/views/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(loginProvider.notifier)
        .login(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

    if (!mounted) return;

    if (success) {
      snackbarService.showSuccessPopup(message: 'Login successful');

      navigationService.pushAndRemoveUntil(const PropertyListScreen());
    } else {
      final error = ref.read(loginProvider).error as ApiFailure;

      snackbarService.showErrorPopup(message: error.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    sizeService.updateFromContext(context);

    final loginState = ref.watch(loginProvider);
    final isLoading = loginState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: sizeService.scalePaddingSymmetric(
              horizontal: 24,
              vertical: 24,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),

                  SizedBox(height: sizeService.scaleH(36)),

                  _buildLoginCard(isLoading),

                  SizedBox(height: sizeService.scaleH(24)),

                  Center(
                    child: Text(
                      'Welcome back to My DreamHome',
                      style: AppTextStyle.caption(color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: sizeService.scaleH(64),
          width: sizeService.scaleW(64),
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: AppColors.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(
            Icons.home_rounded,
            size: sizeService.scaleH(36),
            color: AppColors.primary,
          ),
        ),

        SizedBox(height: sizeService.scaleH(22)),

        Text(
          'My DreamHome',
          style: AppTextStyle.base(
            size: 34,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: sizeService.scaleH(8)),

        Text(
          'Login to continue exploring beautiful properties.',
          style: AppTextStyle.body(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildLoginCard(bool isLoading) {
    return Container(
      padding: sizeService.scalePaddingSymmetric(horizontal: 18, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Login',
            style: AppTextStyle.base(
              size: 24,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: sizeService.scaleH(6)),

          Text(
            'Enter your details below.',
            style: AppTextStyle.caption(color: AppColors.textMuted),
          ),

          SizedBox(height: sizeService.scaleH(24)),

          CustomInput(
            label: 'Email',
            placeholder: 'Enter your email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              final email = value?.trim() ?? '';

              if (email.isEmpty) {
                return 'Email is required';
              }

              if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email)) {
                return 'Enter a valid email';
              }

              return null;
            },
          ),

          SizedBox(height: sizeService.scaleH(18)),

          CustomInput(
            label: 'Password',
            placeholder: 'Enter your password',
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            validator: (value) {
              final password = value?.trim() ?? '';

              if (password.isEmpty) {
                return 'Password is required';
              }

              if (password.length < 6) {
                return 'Password must be at least 6 characters';
              }

              return null;
            },
          ),

          SizedBox(height: sizeService.scaleH(10)),

          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: isLoading
                  ? null
                  : () {
                      snackbarService.showInfoPopup(
                        message: 'Forgot password coming soon',
                      );
                    },
              child: Text(
                'Forgot Password?',
                style: AppTextStyle.base(
                  size: 13,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: sizeService.scaleH(28)),

          AppButton(
            text: 'Login',
            vertical: 12,
            radius: 12,
            isLoading: isLoading,
            onPressed: isLoading ? null : _submit,
          ),
        ],
      ),
    );
  }
}

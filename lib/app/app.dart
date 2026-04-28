import 'package:dreamhome/app/services/app_state_service/app_state_service.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:dreamhome/app/views/home_screen/home_screen.dart';
import 'package:dreamhome/app/views/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:overlay_support/overlay_support.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _isReady = false;
  bool _isAuthenticated = false;

  late final void Function(AppLifecycleEvent event) _lifecycleListener;

  @override
  void initState() {
    super.initState();

    // riverPodService.init(ref);

    _lifecycleListener = _handleLifecycleEvent;
    lifecycleService.addListener(_lifecycleListener);

    _validateAuth();
  }

  @override
  void dispose() {
    lifecycleService.removeListener(_lifecycleListener);
    super.dispose();
  }

  void _handleLifecycleEvent(AppLifecycleEvent event) {
    if (event == AppLifecycleEvent.resumed) {
      sessionService.checkNow();
      _validateAuth();
    }
  }

  Future<void> _validateAuth() async {
    final token = globalDetails.token;
    final refreshToken = globalDetails.refreshToken;

    var isAuthenticated = false;

    final hasValidAccessToken =
        token != null && token.isNotEmpty && !JwtDecoder.isExpired(token);

    if (hasValidAccessToken) {
      sessionService.startAuthCheck(token: token);
      isAuthenticated = true;
    } else if (refreshToken != null && refreshToken.isNotEmpty) {
      final refreshed = await tokenRefreshService.refreshToken();

      final newToken = globalDetails.token;

      if (refreshed &&
          newToken != null &&
          newToken.isNotEmpty &&
          !JwtDecoder.isExpired(newToken)) {
        sessionService.startAuthCheck(token: newToken);
        isAuthenticated = true;
      }
    }

    if (!mounted) return;

    setState(() {
      _isAuthenticated = isAuthenticated;
      _isReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    sizeService.updateFromContext(context);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    return OverlaySupport.global(
      toastTheme: ToastThemeData(
        background: Colors.yellow,
        textColor: Colors.white,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigationService.navigatorKey,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: _isReady
            ? _isAuthenticated
                  ? const PropertyListScreen()
                  : const LoginScreen()
            : const _AppLoadingScreen(),
      ),
    );
  }
}

class _AppLoadingScreen extends StatelessWidget {
  const _AppLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

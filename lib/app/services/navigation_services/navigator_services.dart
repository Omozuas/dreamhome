import 'package:flutter/material.dart';

enum AppRouteTransition {
  material,
  fade,
  slideFromRight,
  slideFromLeft,
  slideFromBottom,
  scale,
  none,
}

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get _state => navigatorKey.currentState;

  bool get canPop => _state?.canPop() ?? false;

  // -------------------- PUSH --------------------
  Future<T?> push<T extends Object?>(
    Widget page, {
    Object? args,
    RouteSettings? settings,
    AppRouteTransition transition = AppRouteTransition.material,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    final state = _state;
    if (state == null) return Future.value(null);

    return state.push<T>(
      _buildRoute(
        page: page,
        args: args,
        settings: settings,
        transition: transition,
        duration: duration,
      ),
    );
  }

  // -------------------- PUSH REPLACEMENT --------------------
  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    Widget page, {
    TO? result,
    Object? args,
    RouteSettings? settings,
    AppRouteTransition transition = AppRouteTransition.material,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    final state = _state;
    if (state == null) return Future.value(null);

    return state.pushReplacement<T, TO>(
      _buildRoute(
        page: page,
        args: args,
        settings: settings,
        transition: transition,
        duration: duration,
      ),
      result: result,
    );
  }

  // -------------------- PUSH & REMOVE --------------------
  Future<T?> pushAndRemoveUntil<T extends Object?>(
    Widget page, {
    Object? args,
    bool keepPreviousPages = false,
    AppRouteTransition transition = AppRouteTransition.material,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    final state = _state;
    if (state == null) return Future.value(null);

    return state.pushAndRemoveUntil<T>(
      _buildRoute(
        page: page,
        args: args,
        transition: transition,
        duration: duration,
      ),
      (route) => keepPreviousPages,
    );
  }

  // -------------------- POP --------------------
  void pop<T extends Object?>([T? result]) {
    if (canPop) _state?.pop(result);
  }

  // -------------------- ROUTE BUILDER --------------------
  Route<T> _buildRoute<T extends Object?>({
    required Widget page,
    Object? args,
    RouteSettings? settings,
    AppRouteTransition transition = AppRouteTransition.material,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    final routeSettings = settings ?? RouteSettings(arguments: args);

    // ✅ DEFAULT (native)
    if (transition == AppRouteTransition.material) {
      return MaterialPageRoute<T>(
        builder: (_) => page,
        settings: routeSettings,
      );
    }

    // ✅ CUSTOM TRANSITIONS
    return PageRouteBuilder<T>(
      settings: routeSettings,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        switch (transition) {
          case AppRouteTransition.fade:
            return FadeTransition(opacity: animation, child: child);

          case AppRouteTransition.slideFromRight:
            return SlideTransition(
              position: Tween(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );

          case AppRouteTransition.slideFromLeft:
            return SlideTransition(
              position: Tween(
                begin: const Offset(-1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );

          case AppRouteTransition.slideFromBottom:
            return SlideTransition(
              position: Tween(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );

          case AppRouteTransition.scale:
            return ScaleTransition(scale: animation, child: child);

          case AppRouteTransition.none:
            return child;

          case AppRouteTransition.material:
            return child;
        }
      },
    );
  }
}

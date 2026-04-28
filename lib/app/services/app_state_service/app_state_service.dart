import 'package:flutter/widgets.dart';

enum AppLifecycleEvent { resumed, paused, inactive, detached, hidden }

class AppLifecycleService with WidgetsBindingObserver {
  final List<void Function(AppLifecycleEvent event)> _listeners = [];

  bool _isInitialized = false;
  AppLifecycleEvent? _lastEvent;

  bool get isInitialized => _isInitialized;
  AppLifecycleEvent? get lastEvent => _lastEvent;

  void initialize() {
    if (_isInitialized) return;

    WidgetsBinding.instance.addObserver(this);
    _isInitialized = true;
  }

  void dispose() {
    if (!_isInitialized) return;

    WidgetsBinding.instance.removeObserver(this);
    _listeners.clear();
    _lastEvent = null;
    _isInitialized = false;
  }

  void addListener(void Function(AppLifecycleEvent event) listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  void removeListener(void Function(AppLifecycleEvent event) listener) {
    _listeners.remove(listener);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final event = _mapFlutterStateToAppEvent(state);
    _lastEvent = event;

    final listenersSnapshot = List<void Function(AppLifecycleEvent event)>.from(
      _listeners,
    );

    for (final listener in listenersSnapshot) {
      try {
        listener(event);
      } catch (error, stackTrace) {
        debugPrint('AppLifecycleService listener error: $error\n$stackTrace');
      }
    }
  }

  AppLifecycleEvent _mapFlutterStateToAppEvent(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        return AppLifecycleEvent.resumed;
      case AppLifecycleState.paused:
        return AppLifecycleEvent.paused;
      case AppLifecycleState.inactive:
        return AppLifecycleEvent.inactive;
      case AppLifecycleState.detached:
        return AppLifecycleEvent.detached;
      case AppLifecycleState.hidden:
        return AppLifecycleEvent.hidden;
    }
  }
}

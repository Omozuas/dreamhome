import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionService {
  final Connectivity _connectivity = Connectivity();

  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  Stream<bool> get connectionChange => _controller.stream;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _lastStatus = false;

  ConnectionService() {
    _init();
  }

  void _init() {
    _subscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
    );

    checkConnection();
  }

  Future<void> _onConnectivityChanged(List<ConnectivityResult> results) async {
    final hasNetwork = results.any(
      (result) => result != ConnectivityResult.none,
    );

    if (!hasNetwork) {
      _emit(false);
      return;
    }

    final hasInternet = await _hasInternetAccess();
    _emit(hasInternet);
  }

  Future<bool> checkConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();

      final hasNetwork = results.any(
        (result) => result != ConnectivityResult.none,
      );

      if (!hasNetwork) {
        _emit(false);
        return false;
      }

      final hasInternet = await _hasInternetAccess();
      _emit(hasInternet);
      return hasInternet;
    } catch (e) {
      log('Connection check error: $e');
      _emit(false);
      return false;
    }
  }

  Future<bool> _hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 3));

      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _emit(bool status) {
    if (_lastStatus == status) return;

    _lastStatus = status;

    if (!_controller.isClosed) {
      _controller.add(status);
    }
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}

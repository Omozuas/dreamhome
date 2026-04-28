import 'dart:developer';

import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

class RefreshService {
  bool _hasSuccessfullyRefreshed = false;
  bool _isRefreshing = false;

  bool get isRefreshing => _isRefreshing;
  bool get hasSuccessfullyRefreshed => _hasSuccessfullyRefreshed;

  Future<void> refreshAll({
    required WidgetRef ref,
    List<ProviderOrFamily> providers = const [],
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 3),
    bool forceRefresh = false,
    bool showErrorSnackbar = true,
  }) async {
    if (_isRefreshing) return;

    if (_hasSuccessfullyRefreshed && !forceRefresh) return;

    final isConnected = await connectionService.checkConnection();

    if (!isConnected) {
      log('No internet connection. Skipping refresh.');

      if (showErrorSnackbar) {
        snackbarService.showErrorPopup(message: 'No internet connection.');
      }

      return;
    }

    _isRefreshing = true;

    try {
      await _withRetry(
        operation: () async {
          log('Refreshing providers...');

          for (final provider in providers) {
            ref.invalidate(provider);
          }

          await Future<void>.delayed(Duration.zero);

          _hasSuccessfullyRefreshed = true;

          log('Providers refreshed successfully.');
        },
        maxRetries: maxRetries,
        retryDelay: retryDelay,
        showErrorSnackbar: showErrorSnackbar,
      );
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _withRetry({
    required Future<void> Function() operation,
    required int maxRetries,
    required Duration retryDelay,
    required bool showErrorSnackbar,
  }) async {
    var attempt = 0;

    while (attempt < maxRetries) {
      try {
        await operation();
        return;
      } catch (error, stackTrace) {
        attempt++;

        log('Refresh attempt $attempt failed: $error', stackTrace: stackTrace);

        if (attempt >= maxRetries) {
          log('All refresh attempts failed.');

          if (showErrorSnackbar) {
            snackbarService.showErrorPopup(
              message: 'Something went wrong. Tap to retry.',
            );
          }

          return;
        }

        await Future.delayed(retryDelay * attempt);
      }
    }
  }

  void resetRefreshFlag() {
    _hasSuccessfullyRefreshed = false;
  }
}

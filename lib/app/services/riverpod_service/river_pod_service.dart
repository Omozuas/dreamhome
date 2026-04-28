import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/misc.dart';

class RiverPodService {
  WidgetRef? _ref;

  bool get isInitialized => _ref != null;

  void init(WidgetRef ref) {
    _ref = ref;
  }

  WidgetRef get ref {
    final r = _ref;
    if (r == null) {
      throw StateError(
        'RiverPodService is not initialized. Call init(ref) first.',
      );
    }
    return r;
  }

  // ---------------- READ ----------------
  T read<T>(ProviderBase<T> provider) {
    return ref.read(provider);
  }

  // ---------------- REFRESH ----------------
  T refresh<T>(ProviderBase<T> provider) {
    return ref.refresh(provider);
  }

  // ---------------- INVALIDATE ----------------
  void invalidate(ProviderBase provider) {
    ref.invalidate(provider);
  }

  // ---------------- STATE (StateProvider ONLY) ----------------
  T getState<T>(StateProvider<T> provider) {
    return ref.read(provider);
  }

  void setState<T>(StateProvider<T> provider, T value) {
    ref.read(provider.notifier).state = value;
  }

  // ---------------- DISPOSE ----------------
  void dispose() {
    _ref = null;
  }
}

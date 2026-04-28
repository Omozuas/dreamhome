import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheService {
  final CacheManager _cacheManager = CacheManager(
    Config(
      'globalImageCache',
      stalePeriod: const Duration(days: 3),
      maxNrOfCacheObjects: 500,
      // fileService: 50 * 1024 * 1024, // 50MB
    ),
  );

  CacheManager get manager => _cacheManager;

  Future<void> cleanOldFiles() async {
    _cacheManager.store.emptyMemoryCache();
  }
}

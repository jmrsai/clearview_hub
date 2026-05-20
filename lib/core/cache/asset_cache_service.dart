import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AssetCacheService {
  static final AssetCacheService _instance = AssetCacheService._internal();
  factory AssetCacheService() => _instance;
  AssetCacheService._internal();

  /// Dedicated cache manager for health assets
  static final DefaultCacheManager _cacheManager = DefaultCacheManager();

  /// Pre-caches a network asset (Lottie, Image, or Sound) for offline use
  Future<void> cacheAsset(String url) async {
    try {
      await _cacheManager.downloadFile(url);
    } catch (e) {
      // Log or handle error silently to not break flow
    }
  }

  /// Gets a cached file if it exists
  Future<FileInfo?> getCachedAsset(String url) async {
    return await _cacheManager.getFileFromCache(url);
  }

  /// Clears the asset cache
  Future<void> clearCache() async {
    await _cacheManager.emptyCache();
  }
}

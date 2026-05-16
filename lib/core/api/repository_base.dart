import 'dart:async';

import 'fetch_policy.dart';
import 'resource.dart';
import '../cache/hive_cache_service.dart';
import '../error/failuors.dart';

/// A reusable repository helper implementing common fetch strategies.
/// Subclasses can call [fetchWithCache] to get consistent stale-while-revalidate
/// behavior across features.
mixin RepositoryBase {
  HiveCacheService get cacheService;

  Future<Resource<T>> fetchWithCache<T>({
    required String cacheKey,
    required Future<T> Function() fetchRemote,
    required T Function(dynamic json) fromJson,
    FetchPolicy policy = FetchPolicy.staleWhileRevalidate,
    Duration? ttl,
  }) async {
    // 1. Try cache when policy allows
    if (policy == FetchPolicy.cacheOnly ||
        policy == FetchPolicy.cacheFirst ||
        policy == FetchPolicy.staleWhileRevalidate) {
      final cached = await cacheService.getJson(cacheKey, allowStale: true);
      if (cached != null) {
        final model = fromJson(cached);
        // If staleWhileRevalidate, kick background fetch
        if (policy == FetchPolicy.staleWhileRevalidate ||
            policy == FetchPolicy.cacheFirst) {
          // fire-and-forget
          fetchRemote()
              .then((remote) async {
                try {
                  if (ttl != null) {
                    await cacheService.putJson(
                      cacheKey,
                      (remote as dynamic).toJson(),
                      ttl: ttl,
                    );
                  } else {
                    await cacheService.putJson(
                      cacheKey,
                      (remote as dynamic).toJson(),
                    );
                  }
                } catch (_) {}
              })
              .catchError((_) {});
        }
        return Resource.success(model, fromCache: true);
      }
      if (policy == FetchPolicy.cacheOnly) {
        return Resource.error(mapExceptionToFailure(Exception('Cache miss')));
      }
    }

    // 2. Fetch remote (networkFirst or networkOnly or cache miss)
    try {
      final remote = await fetchRemote();
      // persist
      try {
        if (ttl != null) {
          await cacheService.putJson(
            cacheKey,
            (remote as dynamic).toJson(),
            ttl: ttl,
          );
        } else {
          await cacheService.putJson(cacheKey, (remote as dynamic).toJson());
        }
      } catch (_) {}
      return Resource.success(remote, fromCache: false);
    } catch (e) {
      // on error, try stale cache if allowed
      if (policy == FetchPolicy.networkFirst ||
          policy == FetchPolicy.networkOnly) {
        final fallback = await cacheService.getJson(cacheKey, allowStale: true);
        if (fallback != null) {
          final model = fromJson(fallback);
          return Resource.success(model, fromCache: true);
        }
      }
      return Resource.error(mapExceptionToFailure(e));
    }
  }
}

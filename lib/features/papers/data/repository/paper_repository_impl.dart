import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/network/network_manager.dart';
import 'package:mirath/features/papers/data/data_sources/paper_remote_data_source.dart';
import 'package:mirath/features/papers/domain/entites/full_paper_entity.dart';
import 'package:mirath/features/papers/domain/repository/paper_repository.dart';
import 'package:mirath/core/cache/hive_cache_service.dart';
import 'package:mirath/core/api/repository_base.dart';
import 'package:mirath/core/api/fetch_policy.dart';
import 'package:mirath/core/api/resource.dart';
import 'package:mirath/core/cache/cache_keys.dart';
import '../models/full_paper_model.dart';

class PaperRepositoryImpl extends PaperRepository with RepositoryBase {
  final PaperRemoteDataSource remoteDataSource;
  final NetworkManager networkManager;
  final HiveCacheService cacheService;

  PaperRepositoryImpl({
    required this.remoteDataSource,
    required this.networkManager,
    required this.cacheService,
  });

  @override
  Future<Either<Failure, FullPaperEntity>> getPaperById(String id) async {
    final cacheKey = CacheKeys.paperById(id);
    final res = await fetchWithCache<FullPaperEntity>(
      cacheKey: cacheKey,
      fetchRemote: () async => (await remoteDataSource.getPaperById(id)),
      fromJson: (json) => FullPaperModel.fromJson(json).toEntity(),
      policy: FetchPolicy.staleWhileRevalidate,
    );

    if (res.status == ResourceStatus.success && res.data != null) {
      return Right(res.data!);
    }

    if (res.failure != null) {
      return Left(res.failure!);
    }

    return Left(ServerFailure());
  }
}

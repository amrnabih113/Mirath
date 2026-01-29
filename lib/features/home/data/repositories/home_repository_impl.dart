import 'package:mirath/core/network/network_manager.dart';
import 'package:mirath/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:mirath/features/home/data/models/home_recent_paper_model.dart';
import 'package:dartz/dartz.dart';
import 'package:mirath/features/home/data/models/home_recommendation_paper_model.dart';
import 'package:mirath/features/home/domain/entities/paper_entity.dart';
import 'package:mirath/features/home/domain/repositories/home_repository.dart';

import '../../../../core/error/failuors.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final NetworkManager networkManager;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkManager,
  });

  @override
  Future<Either<Failure, List<PaperEntity>>> getRecentPapers({
    String? category,
    int page = 1,
    int limit = 10,
  }) async {
    if (!await networkManager.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.getRecentPapers(
        category: category,
        page: page,
        limit: limit,
      );

      final papers = response.data
          .map((model) => model.toPaperEntity())
          .toList();

      return Right(papers);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<PaperEntity>>> getRecommendations({
    int page = 1,
    int limit = 5,
  }) async {
    if (!await networkManager.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.getRecommendations(
        page: page,
        limit: limit,
      );

      final papers = response.data
          .map((model) => model.toPaperEntity())
          .toList();

      return Right(papers);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}

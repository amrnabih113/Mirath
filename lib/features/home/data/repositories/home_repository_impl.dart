import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/network/network_manager.dart';
import '../../domain/entities/paper_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../data_sources/home_remote_data_source.dart';
import '../models/home_recent_paper_model.dart';
import '../models/home_recommendation_paper_model.dart';

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

  @override
  Future<Either<Failure, void>> savePaper(String paperId) async {
    if (!await networkManager.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      await remoteDataSource.savePaper(paperId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> unsavePaper(String paperId) async {
    if (!await networkManager.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      await remoteDataSource.unsavePaper(paperId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}

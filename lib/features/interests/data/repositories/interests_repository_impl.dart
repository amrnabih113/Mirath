import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failuors.dart';
import '../../../../core/network/network_manager.dart';
import '../../domain/entities/interest.dart';
import '../../domain/repositories/interests_repository.dart';
import '../data_sources/interests_remote_data_source.dart';

class InterestsRepositoryImpl implements InterestsRepository {
  final InterestsRemoteDataSource _remoteDataSource;
  final NetworkManager _networkManager;

  InterestsRepositoryImpl({
    required InterestsRemoteDataSource remoteDataSource,
    required NetworkManager networkManager,
  }) : _remoteDataSource = remoteDataSource,
       _networkManager = networkManager;

  @override
  Future<Either<Failure, List<Interest>>> getAllInterests() async {
    try {
      // Check network connectivity
      if (!await _networkManager.isConnected) {
        return const Left(NetworkFailure('No internet connection'));
      }

      final interests = await _remoteDataSource.getAllInterests();
      return Right(interests.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error occurred'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message ?? 'Network error occurred'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Interest>> getInterestById(String id) async {
    try {
      // Check network connectivity
      if (!await _networkManager.isConnected) {
        return const Left(NetworkFailure('No internet connection'));
      }

      final interest = await _remoteDataSource.getInterestById(id);
      return Right(interest.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error occurred'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message ?? 'Network error occurred'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}

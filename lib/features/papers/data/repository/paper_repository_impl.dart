import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/network/network_manager.dart';
import 'package:mirath/features/papers/data/data_sources/paper_remote_data_source.dart';
import 'package:mirath/features/papers/domain/entites/full_paper_entity.dart';
import 'package:mirath/features/papers/domain/repository/paper_repository.dart';

class PaperRepositoryImpl extends PaperRepository {
  final PaperRemoteDataSource remoteDataSource;
  final NetworkManager networkManager;
  PaperRepositoryImpl({
    required this.remoteDataSource,
    required this.networkManager,
  });

  @override
  Future<Either<Failure, FullPaperEntity>> getPaperById(String id) async {
    if (!await networkManager.isConnected) {
      return Left(NetworkFailure());
    }
    try {
      final response = await remoteDataSource.getPaperById(id);
      return Right(response.toEntity());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}

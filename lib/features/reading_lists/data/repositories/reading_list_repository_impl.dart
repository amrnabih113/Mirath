import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/add_paper_to_list_params.dart';
import '../../domain/entities/create_reading_list_params.dart';
import '../../domain/entities/reading_list.dart';
import '../../domain/entities/reading_list_query_params.dart';
import '../../domain/entities/update_reading_list_params.dart';
import '../../domain/repositories/reading_list_repository.dart';
import '../data_sources/reading_list_remote_data_source.dart';

class ReadingListRepositoryImpl implements ReadingListRepository {
  final ReadingListRemoteDataSource remoteDataSource;

  const ReadingListRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ReadingList>>> getReadingLists(
    ReadingListQueryParams params,
  ) async {
    try {
      final response = await remoteDataSource.getReadingLists(params);
      return Right(response.data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch reading lists'));
    }
  }

  @override
  Future<Either<Failure, ReadingList>> createReadingList(
    CreateReadingListParams params,
  ) async {
    try {
      final response = await remoteDataSource.createReadingList(params);
      return Right(response.data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to create reading list'));
    }
  }

  @override
  Future<Either<Failure, ReadingList>> getReadingListById(String id) async {
    try {
      final response = await remoteDataSource.getReadingListById(id);
      return Right(response.data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch reading list'));
    }
  }

  @override
  Future<Either<Failure, ReadingList>> updateReadingList(
    UpdateReadingListParams params,
  ) async {
    try {
      final response = await remoteDataSource.updateReadingList(params);
      return Right(response.data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to update reading list'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReadingList(String id) async {
    try {
      await remoteDataSource.deleteReadingList(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to delete reading list'));
    }
  }

  @override
  Future<Either<Failure, void>> addPaperToList(
    AddPaperToListParams params,
  ) async {
    try {
      await remoteDataSource.addPaperToList(params);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to add paper to list'));
    }
  }

  @override
  Future<Either<Failure, void>> removePaperFromList({
    required String readingListId,
    required String paperId,
  }) async {
    try {
      await remoteDataSource.removePaperFromList(
        readingListId: readingListId,
        paperId: paperId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to remove paper from list'));
    }
  }

  @override
  Future<Either<Failure, void>> saveReadingList(String id) async {
    try {
      await remoteDataSource.saveReadingList(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to save reading list'));
    }
  }

  @override
  Future<Either<Failure, void>> unsaveReadingList(String id) async {
    try {
      await remoteDataSource.unsaveReadingList(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to unsave reading list'));
    }
  }
}

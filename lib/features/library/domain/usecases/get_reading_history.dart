import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/features/library/domain/entities/reading_history.dart';
import 'package:mirath/features/library/domain/repositories/library_repository.dart';

class GetReadingHistory {
  final LibraryRepository libraryRepository;

  GetReadingHistory({required this.libraryRepository});

  Future<Either<Failure, List<ReadingHistoryPaper>>> call({
    int page = 1,
    int limit = 20,
  }) async {
    return await libraryRepository.getReadingHistory(page: page, limit: limit);
  }
}

import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/features/library/domain/repositories/library_repository.dart';

class ClearAllReadingHistory {
  final LibraryRepository libraryRepository;

  ClearAllReadingHistory({required this.libraryRepository});

  Future<Either<Failure, void>> call() async {
    return await libraryRepository.clearAllReadingHistory();
  }
}

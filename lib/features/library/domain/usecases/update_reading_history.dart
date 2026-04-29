import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/features/library/domain/repositories/library_repository.dart';

class UpdateReadingHistory {
  final LibraryRepository libraryRepository;

  UpdateReadingHistory({required this.libraryRepository});

  Future<Either<Failure, void>> call(String paperId) async {
    return await libraryRepository.updateReadingHistory(paperId);
  }
}

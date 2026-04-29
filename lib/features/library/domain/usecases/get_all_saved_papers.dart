import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/features/library/domain/entities/saved_papers.dart';
import 'package:mirath/features/library/domain/repositories/library_repository.dart';

class GetAllSavedPapers {
  final LibraryRepository libraryRepository;

  GetAllSavedPapers({required this.libraryRepository});

  Future<Either<Failure, SavedPapers>> call() async {
    return await libraryRepository.getAllSavedPapers();
  }
}

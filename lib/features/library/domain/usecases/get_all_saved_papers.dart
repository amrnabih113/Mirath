import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../entities/saved_papers.dart';
import '../repositories/library_repository.dart';

class GetAllSavedPapers {
  final LibraryRepository libraryRepository;

  GetAllSavedPapers({required this.libraryRepository});

  Future<Either<Failure, List<SavedPaper>>> call() async {
    return await libraryRepository.getAllSavedPapers();
  }
}

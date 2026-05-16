import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../repositories/library_repository.dart';

class RemovePaperFromReadingHistory {
  final LibraryRepository libraryRepository;

  RemovePaperFromReadingHistory({required this.libraryRepository});

  Future<Either<Failure, void>> call(String paperId) async {
    return await libraryRepository.removePaperFromReadingHistory(paperId);
  }
}

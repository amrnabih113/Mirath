import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../repositories/library_repository.dart';

class ClearAllReadingHistory {
  final LibraryRepository libraryRepository;

  ClearAllReadingHistory({required this.libraryRepository});

  Future<Either<Failure, void>> call() async {
    return await libraryRepository.clearAllReadingHistory();
  }
}

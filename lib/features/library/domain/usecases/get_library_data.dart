import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../entities/library_data.dart';
import '../repositories/library_repository.dart';

class GetLibraryData {
  final LibraryRepository libraryRepository;

  GetLibraryData({required this.libraryRepository});

  Future<Either<Failure, LibraryData>> call() async {
    return await libraryRepository.getLibraryData();
  }
}

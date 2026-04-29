import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/features/library/domain/entities/library_data.dart';
import 'package:mirath/features/library/domain/repositories/library_repository.dart';

class GetLibraryData {
  final LibraryRepository libraryRepository;

  GetLibraryData({required this.libraryRepository});

  Future<Either<Failure, LibraryData>> call() async {
    return await libraryRepository.getLibraryData();
  }
}

import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/home_repository.dart';

class UnsavePaperUseCase implements UseCase<void, String> {
  final HomeRepository repository;

  UnsavePaperUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(String paperId) async {
    return await repository.unsavePaper(paperId);
  }
}

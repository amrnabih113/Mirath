import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/home_repository.dart';

class DeleteSearchHistoryUseCase implements UseCase<void, String> {
  final HomeRepository repository;

  DeleteSearchHistoryUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteSearchHistoryById(id);
  }
}

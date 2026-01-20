import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/interest.dart';
import '../repositories/interests_repository.dart';

class GetInterestByIdUsecase extends UseCase<Interest, String> {
  final InterestsRepository _repository;

  GetInterestByIdUsecase(this._repository);

  @override
  Future<Either<Failure, Interest>> call(String id) async {
    return await _repository.getInterestById(id);
  }
}

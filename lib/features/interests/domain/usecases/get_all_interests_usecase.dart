import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/interest.dart';
import '../repositories/interests_repository.dart';

class GetAllInterestsUsecase extends UseCase<List<Interest>, NoParams> {
  final InterestsRepository _repository;

  GetAllInterestsUsecase(this._repository);

  @override
  Future<Either<Failure, List<Interest>>> call(NoParams params) async {
    return await _repository.getAllInterests();
  }
}

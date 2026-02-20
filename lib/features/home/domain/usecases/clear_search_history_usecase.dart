import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/home_repository.dart';

class ClearSearchHistoryUseCase implements UseCase<void, NoParams> {
  final HomeRepository repository;

  ClearSearchHistoryUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.clearSearchHistory();
  }
}

import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/reading_list.dart';
import '../entities/update_reading_list_params.dart';
import '../repositories/reading_list_repository.dart';

class UpdateReadingListUseCase
    implements UseCase<ReadingList, UpdateReadingListParams> {
  final ReadingListRepository repository;

  UpdateReadingListUseCase(this.repository);

  @override
  Future<Either<Failure, ReadingList>> call(
    UpdateReadingListParams params,
  ) async {
    return await repository.updateReadingList(params);
  }
}

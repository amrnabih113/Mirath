import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/create_reading_list_params.dart';
import '../entities/reading_list.dart';
import '../repositories/reading_list_repository.dart';

class CreateReadingListUseCase
    implements UseCase<ReadingList, CreateReadingListParams> {
  final ReadingListRepository repository;

  CreateReadingListUseCase(this.repository);

  @override
  Future<Either<Failure, ReadingList>> call(
    CreateReadingListParams params,
  ) async {
    return await repository.createReadingList(params);
  }
}

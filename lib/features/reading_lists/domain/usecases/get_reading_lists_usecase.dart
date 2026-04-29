import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/reading_list_query_params.dart';
import '../entities/reading_list.dart';
import '../repositories/reading_list_repository.dart';

class GetReadingListsUseCase
    implements UseCase<List<ReadingList>, ReadingListQueryParams?> {
  final ReadingListRepository repository;

  GetReadingListsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ReadingList>>> call(
    ReadingListQueryParams? params,
  ) async {
    return await repository.getReadingLists(
      params ?? const ReadingListQueryParams(),
    );
  }
}

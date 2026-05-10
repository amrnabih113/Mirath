import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../reading_lists/domain/entities/reading_list.dart';
import '../repositories/home_repository.dart';
import 'search_query_params.dart';

class SearchReadingListsUseCase
    implements UseCase<List<ReadingList>, SearchQueryParams> {
  final HomeRepository repository;

  SearchReadingListsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ReadingList>>> call(
    SearchQueryParams params,
  ) async {
    return repository.searchReadingLists(
      params.query,
      page: params.page,
      limit: params.limit,
    );
  }
}

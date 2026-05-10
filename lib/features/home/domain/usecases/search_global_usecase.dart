import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/global_search_results.dart';
import '../repositories/home_repository.dart';
import 'search_query_params.dart';

class SearchGlobalUseCase
    implements UseCase<GlobalSearchResults, SearchQueryParams> {
  final HomeRepository repository;

  SearchGlobalUseCase({required this.repository});

  @override
  Future<Either<Failure, GlobalSearchResults>> call(
    SearchQueryParams params,
  ) async {
    return repository.searchGlobal(
      params.query,
      page: params.page,
      limit: params.limit,
    );
  }
}

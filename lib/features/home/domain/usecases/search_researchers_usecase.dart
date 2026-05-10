import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../users/domain/entities/user.dart';
import '../repositories/home_repository.dart';
import 'search_query_params.dart';

class SearchResearchersUseCase
    implements UseCase<List<User>, SearchQueryParams> {
  final HomeRepository repository;

  SearchResearchersUseCase({required this.repository});

  @override
  Future<Either<Failure, List<User>>> call(SearchQueryParams params) async {
    return repository.searchResearchers(
      params.query,
      page: params.page,
      limit: params.limit,
    );
  }
}

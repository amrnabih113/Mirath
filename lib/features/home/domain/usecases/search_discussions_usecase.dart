import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../discussions/domain/entities/discussion.dart';
import '../repositories/home_repository.dart';
import 'search_query_params.dart';

class SearchDiscussionsUseCase
    implements UseCase<List<Discussion>, SearchQueryParams> {
  final HomeRepository repository;

  SearchDiscussionsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<Discussion>>> call(
    SearchQueryParams params,
  ) async {
    return repository.searchDiscussions(
      params.query,
      page: params.page,
      limit: params.limit,
    );
  }
}

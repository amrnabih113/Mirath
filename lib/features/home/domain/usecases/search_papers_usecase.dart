import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/paper_entity.dart';
import '../repositories/home_repository.dart';

class SearchPapersUseCase
    implements UseCase<List<PaperEntity>, SearchPapersParams> {
  final HomeRepository repository;

  SearchPapersUseCase({required this.repository});

  @override
  Future<Either<Failure, List<PaperEntity>>> call(
    SearchPapersParams params,
  ) async {
    return await repository.searchPapers(
      params.query,
      page: params.page,
      limit: params.limit,
    );
  }
}

class SearchPapersParams {
  final String query;
  final int page;
  final int limit;

  SearchPapersParams({required this.query, this.page = 1, this.limit = 10});
}

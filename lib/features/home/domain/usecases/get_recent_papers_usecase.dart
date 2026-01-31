import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/paper_entity.dart';
import '../repositories/home_repository.dart';

class GetRecentPapersUseCase
    implements UseCase<List<PaperEntity>, GetRecentPapersParams> {
  final HomeRepository repository;

  GetRecentPapersUseCase({required this.repository});

  @override
  Future<Either<Failure, List<PaperEntity>>> call(
    GetRecentPapersParams params,
  ) async {
    return await repository.getRecentPapers(
      category: params.category,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetRecentPapersParams {
  final String? category;
  final int page;
  final int limit;

  GetRecentPapersParams({this.category, this.page = 1, this.limit = 10});
}

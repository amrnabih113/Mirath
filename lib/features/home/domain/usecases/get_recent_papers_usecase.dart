import 'package:dartz/dartz.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/home/domain/entities/paper_entity.dart';
import 'package:mirath/features/home/domain/repositories/home_repository.dart';

import '../../../../core/error/failuors.dart';

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

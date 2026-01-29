import 'package:dartz/dartz.dart';
import 'package:mirath/core/error/failuors.dart';
import 'package:mirath/core/usecases/usecase.dart';
import 'package:mirath/features/home/domain/entities/paper_entity.dart';
import 'package:mirath/features/home/domain/repositories/home_repository.dart';

class GetRecommendationsUseCase
    implements UseCase<List<PaperEntity>, GetRecommendationsParams> {
  final HomeRepository repository;

  GetRecommendationsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<PaperEntity>>> call(
    GetRecommendationsParams params,
  ) async {
    return await repository.getRecommendations(
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetRecommendationsParams {
  final int page;
  final int limit;

  GetRecommendationsParams({this.page = 1, this.limit = 5});
}

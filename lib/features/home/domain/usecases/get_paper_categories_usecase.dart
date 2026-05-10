import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/home_repository.dart';

class GetPaperCategoriesUseCase
    implements UseCase<List<String>, GetPaperCategoriesParams> {
  final HomeRepository repository;

  GetPaperCategoriesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<String>>> call(
    GetPaperCategoriesParams params,
  ) async {
    return await repository.getPaperCategories(
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetPaperCategoriesParams {
  final int page;
  final int limit;

  GetPaperCategoriesParams({this.page = 1, this.limit = 20});
}

import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/search_history_item.dart';
import '../repositories/home_repository.dart';

class GetSearchHistoryUseCase
    implements UseCase<List<SearchHistoryItem>, GetSearchHistoryParams> {
  final HomeRepository repository;

  GetSearchHistoryUseCase({required this.repository});

  @override
  Future<Either<Failure, List<SearchHistoryItem>>> call(
    GetSearchHistoryParams params,
  ) async {
    return await repository.getSearchHistory(limit: params.limit);
  }
}

class GetSearchHistoryParams {
  final int limit;

  GetSearchHistoryParams({this.limit = 10});
}

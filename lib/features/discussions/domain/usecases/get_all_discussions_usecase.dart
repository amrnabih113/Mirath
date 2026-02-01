import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/discussion.dart';
import '../entities/get_discussions_params.dart';
import '../repositories/community_repository.dart';

class GetAllDiscussionsUseCase
    implements UseCase<List<Discussion>, GetDiscussionsParams> {
  final CommunityRepository repository;

  GetAllDiscussionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Discussion>>> call(
    GetDiscussionsParams params,
  ) async {
    return await repository.getAllDiscussions(params);
  }
}

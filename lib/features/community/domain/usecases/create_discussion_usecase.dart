import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/create_discussion_params.dart';
import '../entities/discussion.dart';
import '../repositories/community_repository.dart';

class CreateDiscussionUseCase
    implements UseCase<Discussion, CreateDiscussionParams> {
  final CommunityRepository repository;

  CreateDiscussionUseCase(this.repository);

  @override
  Future<Either<Failure, Discussion>> call(
    CreateDiscussionParams params,
  ) async {
    return await repository.createDiscussion(params);
  }
}

import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/comment.dart';
import '../repositories/community_repository.dart';

class GetDiscussionCommentsUseCase implements UseCase<List<Comment>, String> {
  final CommunityRepository repository;

  GetDiscussionCommentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Comment>>> call(String params) async {
    return await repository.getDiscussionComments(params);
  }
}

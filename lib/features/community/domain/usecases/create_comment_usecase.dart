import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/comment.dart';
import '../entities/create_comment_params.dart';
import '../repositories/community_repository.dart';

class CreateCommentUseCase implements UseCase<Comment, CreateCommentParams> {
  final CommunityRepository repository;

  CreateCommentUseCase(this.repository);

  @override
  Future<Either<Failure, Comment>> call(CreateCommentParams params) async {
    return await repository.createComment(params);
  }
}

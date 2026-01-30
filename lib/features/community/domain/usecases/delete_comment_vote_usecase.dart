import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/community_repository.dart';

class DeleteCommentVoteUseCase implements UseCase<void, String> {
  final CommunityRepository repository;

  DeleteCommentVoteUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.deleteCommentVote(params);
  }
}

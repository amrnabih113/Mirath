import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/vote_params.dart';
import '../repositories/community_repository.dart';

class VoteOnDiscussionUseCase implements UseCase<void, VoteParams> {
  final CommunityRepository repository;

  VoteOnDiscussionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(VoteParams params) async {
    return await repository.voteOnDiscussion(params);
  }
}

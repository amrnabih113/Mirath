import '../entities/discussion.dart';
import '../entities/get_discussions_params.dart';
import '../repositories/community_repository.dart';

class CommunityCacheUseCases {
  final CommunityRepository repository;

  CommunityCacheUseCases({required this.repository});

  Future<List<Discussion>> getCachedDiscussions(GetDiscussionsParams params) {
    return repository.getCachedDiscussions(params);
  }

  Future<void> cacheDiscussions(
    List<Discussion> discussions,
    GetDiscussionsParams params,
  ) {
    return repository.cacheDiscussions(discussions, params);
  }

  Future<void> updateDiscussionVoteInCache({
    required String discussionId,
    required String voteType,
    required bool isRemovingVote,
  }) {
    return repository.updateDiscussionVoteInCache(
      discussionId: discussionId,
      voteType: voteType,
      isRemovingVote: isRemovingVote,
    );
  }

  Future<void> updateDiscussionFollowState({
    required String userId,
    required bool isFollowing,
  }) {
    return repository.updateDiscussionFollowState(
      userId: userId,
      isFollowing: isFollowing,
    );
  }
}

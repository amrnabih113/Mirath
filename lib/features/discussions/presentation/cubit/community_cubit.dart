import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/discussion.dart';
import '../../../../core/network/network_manager.dart';
import '../../../../injection/injection_container.dart';
import '../../../../core/sync/retry_service.dart';
import '../../domain/entities/get_discussions_params.dart';
import '../../domain/entities/vote_params.dart';
import '../../domain/usecases/community_cache_usecases.dart';
import '../../domain/usecases/delete_discussion_vote_usecase.dart';
import '../../domain/usecases/get_all_discussions_usecase.dart';
import '../../domain/usecases/vote_on_discussion_usecase.dart';
import '../../../users/domain/usecases/follow_user_usecase.dart';
import '../../../users/domain/usecases/unfollow_user_usecase.dart';
import '../../../../core/utils/my_logger.dart';
import 'community_state.dart';

class CommunityCubit extends Cubit<CommunityState> {
  final CommunityCacheUseCases communityCacheUseCases;
  final GetAllDiscussionsUseCase getAllDiscussionsUseCase;
  final VoteOnDiscussionUseCase voteOnDiscussionUseCase;
  final DeleteDiscussionVoteUseCase deleteDiscussionVoteUseCase;
  final FollowUserUsecase followUserUsecase;
  final UnfollowUserUsecase unfollowUserUsecase;

  CommunityCubit({
    required this.communityCacheUseCases,
    required this.getAllDiscussionsUseCase,
    required this.voteOnDiscussionUseCase,
    required this.deleteDiscussionVoteUseCase,
    required this.followUserUsecase,
    required this.unfollowUserUsecase,
  }) : super(const CommunityInitial());

  // Track current page for pagination
  int _currentPage = 1;
  String _currentSort = 'new';
  String? _currentTopicId;
  String? _currentAuthorId;

  Future<void> getDiscussions({
    String sort = 'new',
    String? topicId,
    String? authorId,
    int limit = 10,
    bool forceRefresh = false,
  }) async {
    if (forceRefresh && !await NetworkManager.instance.isConnected) {
      return;
    }

    final cachedDiscussions = await communityCacheUseCases.getCachedDiscussions(
      GetDiscussionsParams(
        page: 1,
        limit: limit,
        sort: sort,
        topicId: topicId,
        authorId: authorId,
      ),
    );

    if (cachedDiscussions.isNotEmpty) {
      emit(
        CommunityDiscussionsLoaded(
          discussions: cachedDiscussions,
          hasReachedMax: cachedDiscussions.length < limit,
          currentSort: sort,
          currentTopicId: topicId,
        ),
      );
    } else {
      emit(const CommunityLoading());
    }

    // Reset pagination for new filter/sort
    _currentPage = 1;
    _currentSort = sort;
    _currentTopicId = topicId;
    _currentAuthorId = authorId;

    if (cachedDiscussions.isNotEmpty && !forceRefresh) {
      return;
    }

    final result = await getAllDiscussionsUseCase(
      GetDiscussionsParams(
        page: _currentPage,
        limit: limit,
        sort: sort,
        topicId: topicId,
        authorId: authorId,
      ),
    );

    result.fold(
      (failure) {
        if (cachedDiscussions.isEmpty) {
          emit(const CommunityError(message: 'Failed to fetch discussions'));
        }
      },
      (discussions) {
        communityCacheUseCases.cacheDiscussions(
          discussions,
          GetDiscussionsParams(
            page: 1,
            limit: limit,
            sort: sort,
            topicId: topicId,
            authorId: authorId,
          ),
        );
        emit(
          CommunityDiscussionsLoaded(
            discussions: discussions,
            hasReachedMax: discussions.length < limit,
            currentSort: sort,
            currentTopicId: topicId,
          ),
        );
      },
    );
  }

  Future<void> loadMoreDiscussions({int limit = 10}) async {
    final currentState = state;
    if (currentState is! CommunityDiscussionsLoaded) return;
    if (currentState.hasReachedMax) return;
    if (currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    _currentPage++;

    final result = await getAllDiscussionsUseCase(
      GetDiscussionsParams(
        page: _currentPage,
        limit: limit,
        sort: _currentSort,
        topicId: _currentTopicId,
        authorId: _currentAuthorId,
      ),
    );

    result.fold(
      (failure) {
        emit(currentState.copyWith(isLoadingMore: false));
      },
      (newDiscussions) {
        final allDiscussions = List.of(currentState.discussions)
          ..addAll(newDiscussions);

        communityCacheUseCases.cacheDiscussions(
          allDiscussions,
          GetDiscussionsParams(
            page: 1,
            limit: limit,
            sort: _currentSort,
            topicId: _currentTopicId,
            authorId: _currentAuthorId,
          ),
        );

        emit(
          currentState.copyWith(
            discussions: allDiscussions,
            isLoadingMore: false,
            hasReachedMax: newDiscussions.length < limit,
          ),
        );
      },
    );
  }

  Future<void> refreshDiscussions({int limit = 10}) async {
    await getDiscussions(
      sort: _currentSort,
      topicId: _currentTopicId,
      authorId: _currentAuthorId,
      limit: limit,
      forceRefresh: true,
    );
  }

  void changeSortOrder(String sort) {
    getDiscussions(sort: sort, topicId: _currentTopicId);
  }

  void filterByTopic(String? topicId) {
    getDiscussions(sort: _currentSort, topicId: topicId);
  }

  Future<void> voteOnDiscussion({
    required String discussionId,
    required String voteType,
  }) async {
    final currentState = state;
    if (currentState is! CommunityDiscussionsLoaded) return;

    // Find the discussion to update
    final discussionIndex = currentState.discussions.indexWhere(
      (d) => d.id == discussionId,
    );
    if (discussionIndex == -1) return;

    final discussion = currentState.discussions[discussionIndex];

    // Calculate optimistic update
    int newUpvoteCount = discussion.upvoteCount;
    int newDownvoteCount = discussion.downvoteCount;
    bool newHasVoted = discussion.hasVoted;
    String? newUserVoteType = discussion.userVoteType;

    // User is removing their vote (clicking the same vote type they already voted)
    final isRemovingVote =
        discussion.hasVoted && discussion.userVoteType == voteType;
    if (isRemovingVote) {
      if (voteType == 'UP') {
        newUpvoteCount = discussion.upvoteCount - 1;
      } else if (voteType == 'DOWN') {
        newDownvoteCount = discussion.downvoteCount - 1;
      }
      newHasVoted = false;
      newUserVoteType = null;
    }
    // User is changing their vote (from UP to DOWN or vice versa)
    else if (discussion.hasVoted && discussion.userVoteType != voteType) {
      if (discussion.userVoteType == 'UP') {
        newUpvoteCount = discussion.upvoteCount - 1;
      } else if (discussion.userVoteType == 'DOWN') {
        newDownvoteCount = discussion.downvoteCount - 1;
      }
      if (voteType == 'UP') {
        newUpvoteCount = newUpvoteCount + 1;
      } else if (voteType == 'DOWN') {
        newDownvoteCount = newDownvoteCount + 1;
      }
      newUserVoteType = voteType;
    }
    // User is voting for the first time
    else {
      if (voteType == 'UP') {
        newUpvoteCount = discussion.upvoteCount + 1;
      } else if (voteType == 'DOWN') {
        newDownvoteCount = discussion.downvoteCount + 1;
      }
      newHasVoted = true;
      newUserVoteType = voteType;
    }

    // Create updated discussion
    final updatedDiscussion = discussion.copyWith(
      upvoteCount: newUpvoteCount,
      downvoteCount: newDownvoteCount,
      hasVoted: newHasVoted,
      userVoteType: newUserVoteType,
    );

    // Update UI optimistically
    final updatedDiscussions = List<Discussion>.of(currentState.discussions);
    updatedDiscussions[discussionIndex] = updatedDiscussion;

    emit(currentState.copyWith(discussions: updatedDiscussions));

    // Try immediate sync if online; otherwise enqueue
    final connected = NetworkManager.instance.currentConnectionStatus;
    if (!connected) {
      await sl<RetryService>().enqueue('vote_discussion', {
        'discussionId': discussionId,
        'upvote': voteType == 'UP',
      });
      return;
    }

    final result = isRemovingVote
        ? await deleteDiscussionVoteUseCase(discussionId)
        : await voteOnDiscussionUseCase(
            VoteParams(id: discussionId, type: voteType),
          );

    result.fold(
      (failure) async {
        await sl<RetryService>().enqueue('vote_discussion', {
          'discussionId': discussionId,
          'upvote': voteType == 'UP',
        });
        // On failure, revert to previous state by reloading
        getDiscussions(sort: _currentSort, topicId: _currentTopicId);
      },
      (_) {
        // Success - keep the optimistic update (no need to reload)
        communityCacheUseCases.updateDiscussionVoteInCache(
          discussionId: discussionId,
          voteType: voteType,
          isRemovingVote: isRemovingVote,
        );
      },
    );
  }

  void updateScrollPosition(double scrollPosition) {
    final currentState = state;
    if (currentState is CommunityDiscussionsLoaded) {
      emit(currentState.copyWith(scrollPosition: scrollPosition));
    }
  }

  Future<void> followUser(String userId) async {
    final currentState = state;
    if (currentState is! CommunityDiscussionsLoaded) return;

    final result = await followUserUsecase(userId);

    result.fold(
      (failure) {
        MyLogger.error('Failed to follow user: $failure');
      },
      (success) {
        MyLogger.debug('Successfully followed user: $userId');
        communityCacheUseCases.updateDiscussionFollowState(
          userId: userId,
          isFollowing: true,
        );

        // Update all discussions from this author with isFollowing = true
        final updatedDiscussions = currentState.discussions.map((discussion) {
          if (discussion.author.id == userId) {
            return discussion.copyWith(
              author: discussion.author.copyWith(isFollowing: true),
            );
          }
          return discussion;
        }).toList();

        emit(currentState.copyWith(discussions: updatedDiscussions));
      },
    );
  }

  Future<void> unfollowUser(String userId) async {
    final currentState = state;
    if (currentState is! CommunityDiscussionsLoaded) return;

    final result = await unfollowUserUsecase(userId);

    result.fold(
      (failure) {
        MyLogger.error('Failed to unfollow user: $failure');
      },
      (success) {
        MyLogger.debug('Successfully unfollowed user: $userId');
        communityCacheUseCases.updateDiscussionFollowState(
          userId: userId,
          isFollowing: false,
        );

        // Update all discussions from this author with isFollowing = false
        final updatedDiscussions = currentState.discussions.map((discussion) {
          if (discussion.author.id == userId) {
            return discussion.copyWith(
              author: discussion.author.copyWith(isFollowing: false),
            );
          }
          return discussion;
        }).toList();

        emit(currentState.copyWith(discussions: updatedDiscussions));
      },
    );
  }
}

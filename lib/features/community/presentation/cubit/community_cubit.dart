import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/discussion.dart';
import 'package:mirath/features/community/domain/entities/get_discussions_params.dart';
import 'package:mirath/features/community/domain/entities/vote_params.dart';
import 'package:mirath/features/community/domain/usecases/get_all_discussions_usecase.dart';
import 'package:mirath/features/community/domain/usecases/vote_on_discussion_usecase.dart';
import 'package:mirath/features/community/presentation/cubit/community_state.dart';

class CommunityCubit extends Cubit<CommunityState> {
  final GetAllDiscussionsUseCase getAllDiscussionsUseCase;
  final VoteOnDiscussionUseCase voteOnDiscussionUseCase;

  CommunityCubit({
    required this.getAllDiscussionsUseCase,
    required this.voteOnDiscussionUseCase,
  }) : super(const CommunityInitial());

  // Track current page for pagination
  int _currentPage = 1;
  String _currentSort = 'new';
  String? _currentTopicId;

  Future<void> getDiscussions({
    String sort = 'new',
    String? topicId,
    int limit = 10,
  }) async {
    emit(const CommunityLoading());

    // Reset pagination for new filter/sort
    _currentPage = 1;
    _currentSort = sort;
    _currentTopicId = topicId;

    final result = await getAllDiscussionsUseCase(
      GetDiscussionsParams(
        page: _currentPage,
        limit: limit,
        sort: sort,
        topicId: topicId,
      ),
    );

    result.fold(
      (failure) {
        emit(const CommunityError(message: 'Failed to fetch discussions'));
      },
      (discussions) {
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
      ),
    );

    result.fold(
      (failure) {
        emit(currentState.copyWith(isLoadingMore: false));
      },
      (newDiscussions) {
        final allDiscussions = List.of(currentState.discussions)
          ..addAll(newDiscussions);

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
      limit: limit,
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
    int newVoteScore = discussion.voteScore;
    bool newHasVoted = discussion.hasVoted;
    String? newUserVoteType = discussion.userVoteType;

    // Determine the score change based on vote type
    if (discussion.hasVoted && discussion.userVoteType == voteType) {
      // User is removing their vote
      if (voteType == 'UP') {
        newVoteScore = discussion.voteScore - 1;
      } else if (voteType == 'DOWN') {
        newVoteScore = discussion.voteScore + 1;
      }
      newHasVoted = false;
      newUserVoteType = null;
    } else if (discussion.hasVoted && discussion.userVoteType != voteType) {
      // User is changing their vote
      if (discussion.userVoteType == 'UP') {
        newVoteScore = discussion.voteScore - 1; // Remove UP
      } else if (discussion.userVoteType == 'DOWN') {
        newVoteScore = discussion.voteScore + 1; // Remove DOWN
      }

      if (voteType == 'UP') {
        newVoteScore = newVoteScore + 1; // Add UP
      } else if (voteType == 'DOWN') {
        newVoteScore = newVoteScore - 1; // Add DOWN
      }
      newUserVoteType = voteType;
    } else {
      // User is voting for the first time
      if (voteType == 'UP') {
        newVoteScore = discussion.voteScore + 1;
      } else if (voteType == 'DOWN') {
        newVoteScore = discussion.voteScore - 1;
      }
      newHasVoted = true;
      newUserVoteType = voteType;
    }

    // Create updated discussion
    final updatedDiscussion = discussion.copyWith(
      voteScore: newVoteScore,
      hasVoted: newHasVoted,
      userVoteType: newUserVoteType,
    );

    // Update UI optimistically
    final updatedDiscussions = List<Discussion>.of(currentState.discussions);
    updatedDiscussions[discussionIndex] = updatedDiscussion;

    emit(currentState.copyWith(discussions: updatedDiscussions));

    // Make API call in the background
    final params = VoteParams(id: discussionId, type: voteType);
    final result = await voteOnDiscussionUseCase(params);

    result.fold(
      (failure) {
        // On failure, revert to previous state by reloading
        getDiscussions(sort: _currentSort, topicId: _currentTopicId);
      },
      (_) {
        // Success - keep the optimistic update (no need to reload)
      },
    );
  }

  void updateScrollPosition(double scrollPosition) {
    final currentState = state;
    if (currentState is CommunityDiscussionsLoaded) {
      emit(currentState.copyWith(scrollPosition: scrollPosition));
    }
  }
}

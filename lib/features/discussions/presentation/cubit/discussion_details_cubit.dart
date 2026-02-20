import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirath/core/utils/my_logger.dart';
import '../../../../core/error/failuors.dart';
import '../../../../core/services/user_cache_service.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/create_comment_params.dart';
import '../../domain/entities/discussion_author.dart';
import '../../domain/entities/vote_params.dart';
import '../../domain/usecases/create_comment_usecase.dart';
import '../../domain/usecases/delete_comment_vote_usecase.dart';
import '../../domain/usecases/delete_discussion_vote_usecase.dart';
import '../../domain/usecases/get_discussion_by_id_usecase.dart';
import '../../domain/usecases/get_discussion_comments_usecase.dart';
import '../../domain/usecases/vote_on_comment_usecase.dart';
import '../../domain/usecases/vote_on_discussion_usecase.dart';
import 'discussion_details_state.dart';

class DiscussionDetailsCubit extends Cubit<DiscussionDetailsState> {
  final GetDiscussionByIdUseCase getDiscussionByIdUseCase;
  final GetDiscussionCommentsUseCase getDiscussionCommentsUseCase;
  final CreateCommentUseCase createCommentUseCase;
  final VoteOnCommentUseCase voteOnCommentUseCase;
  final VoteOnDiscussionUseCase voteOnDiscussionUseCase;
  final DeleteCommentVoteUseCase deleteCommentVoteUseCase;
  final DeleteDiscussionVoteUseCase deleteDiscussionVoteUseCase;
  final UserCacheService userCacheService;

  DiscussionDetailsCubit({
    required this.getDiscussionByIdUseCase,
    required this.getDiscussionCommentsUseCase,
    required this.createCommentUseCase,
    required this.voteOnCommentUseCase,
    required this.voteOnDiscussionUseCase,
    required this.deleteCommentVoteUseCase,
    required this.deleteDiscussionVoteUseCase,
    required this.userCacheService,
  }) : super(const DiscussionDetailsInitial());

  Future<void> loadDiscussionDetails(String discussionId) async {
    emit(const DiscussionDetailsLoading());

    final discussionResult = await getDiscussionByIdUseCase(discussionId);

    await discussionResult.fold(
      (failure) async {
        emit(
          const DiscussionDetailsError(message: 'Failed to load discussion'),
        );
      },
      (discussion) async {
        final commentsResult = await getDiscussionCommentsUseCase(discussionId);

        commentsResult.fold(
          (failure) {
            emit(DiscussionDetailsLoaded(discussion: discussion, comments: []));
          },
          (comments) {
            // Sort comments from newest to oldest
            final sortedComments = List<Comment>.from(comments)
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
            emit(
              DiscussionDetailsLoaded(
                discussion: discussion,
                comments: sortedComments,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> refreshComments(String discussionId) async {
    final currentState = state;
    if (currentState is! DiscussionDetailsLoaded) return;

    emit(currentState.copyWith(isLoadingComments: true));

    final commentsResult = await getDiscussionCommentsUseCase(discussionId);

    commentsResult.fold(
      (failure) {
        emit(currentState.copyWith(isLoadingComments: false));
      },
      (comments) {
        // Sort comments from newest to oldest
        final sortedComments = List<Comment>.from(comments)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        emit(
          currentState.copyWith(
            comments: sortedComments,
            isLoadingComments: false,
          ),
        );
      },
    );
  }

  Future<void> addComment({
    required String discussionId,
    required String content,
    String? parentId,
  }) async {
    MyLogger.debug(
      '[CUBIT] 🔵 addComment called with: discussionId=$discussionId, content=$content, parentId=$parentId',
    );

    final currentState = state;
    MyLogger.debug(
      '[CUBIT] 📋 Current state type: ${currentState.runtimeType}',
    );
    if (currentState is! DiscussionDetailsLoaded) {
      MyLogger.debug(
        '[CUBIT] ❌ State is not DiscussionDetailsLoaded, returning',
      );
      return;
    }
    MyLogger.debug(
      '[CUBIT] ✓ State is DiscussionDetailsLoaded with ${currentState.comments.length} comments',
    );

    // Create a temporary comment with a temporary ID for optimistic update
    final tempId = 'local_${DateTime.now().millisecondsSinceEpoch}';
    MyLogger.debug('[CUBIT] 🔄 Creating temp comment with ID: $tempId');

    // Get cached user for author info
    final cachedUser = userCacheService.getCachedUser();
    final tempAuthor = DiscussionAuthor(
      id: cachedUser?.id ?? currentState.discussion.authorId,
      username: cachedUser?.username ?? 'Unknown',
      fullName: cachedUser?.fullName ?? cachedUser?.username ?? 'Unknown User',
      photoUrl: cachedUser?.photoURL,
      bio: null,
      role: 'user',
      isPremium: false,
    );
    MyLogger.debug(
      '[CUBIT] 👤 Using cached user: ${cachedUser?.fullName} (${cachedUser?.photoURL})',
    );

    final tempComment = Comment(
      id: tempId,
      content: content,
      upvoteCount: 0,
      downvoteCount: 0,
      authorId: cachedUser?.id ?? currentState.discussion.authorId,
      discussionId: discussionId,
      parentId: parentId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      hasVoted: false,
      author: tempAuthor,
      isPending: true,
    );
    MyLogger.debug(
      '[CUBIT] ✓ Temp comment created: id=$tempId, isPending=${tempComment.isPending}',
    );

    // Add comment optimistically (newest first)
    final updatedComments = [tempComment, ...currentState.comments];
    MyLogger.debug(
      '[CUBIT] 📤 Emitting state with ${updatedComments.length} comments (added temp comment)',
    );
    emit(
      currentState.copyWith(
        comments: updatedComments,
        commentSubmissionError: null,
      ),
    );
    MyLogger.debug('[CUBIT] ✓ State emitted successfully');

    // Make API call in background
    final params = CreateCommentParams(
      discussionId: discussionId,
      content: content,
      parentId: parentId,
    );
    MyLogger.debug('[CUBIT] 🌐 Calling createCommentUseCase...');

    final result = await createCommentUseCase(params);
    MyLogger.debug('[CUBIT] 📨 UseCase returned result');

    result.fold(
      (failure) {
        MyLogger.debug('[CUBIT] ❌ API call failed: ${failure.message}');
        final errorMessage = _getErrorMessage(failure);

        // Remove the pending comment on failure
        final failedComments = updatedComments
            .where((c) => c.id != tempId)
            .toList();
        MyLogger.debug(
          '[CUBIT] 🗑️ Removing temp comment, ${failedComments.length} comments remain',
        );

        final state = this.state;
        if (state is DiscussionDetailsLoaded) {
          MyLogger.debug('[CUBIT] 📤 Emitting error state');
          emit(
            state.copyWith(
              comments: failedComments,
              commentSubmissionError: errorMessage,
            ),
          );
        }
      },
      (newComment) {
        MyLogger.debug(
          '[CUBIT] ✅ API call successful: new comment id=${newComment.id}',
        );
        final shouldUseCachedAuthor =
            cachedUser?.id != null && newComment.authorId == cachedUser!.id;
        final resolvedComment = shouldUseCachedAuthor
            ? newComment.copyWith(
                author: tempAuthor,
                authorId: cachedUser.id,
                isPending: false,
              )
            : newComment.copyWith(isPending: false);
        // Replace the temporary comment with the real one
        final finalComments = updatedComments
            .map((c) => c.id == tempId ? resolvedComment : c)
            .toList();
        MyLogger.debug(
          '[CUBIT] 🔄 Replaced temp comment with real comment, ${finalComments.length} comments total',
        );

        final state = this.state;
        if (state is DiscussionDetailsLoaded) {
          MyLogger.debug('[CUBIT] 📤 Emitting final state with real comment');
          emit(
            state.copyWith(
              comments: finalComments,
              commentSubmissionError: null,
            ),
          );
          MyLogger.debug('[CUBIT] ✓ Final state emitted');
        }
      },
    );
  }

  String _getErrorMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'Network error. Please check your connection.';
    } else if (failure is UnauthorizedFailure) {
      return 'Authentication failed. Please log in again.';
    } else if (failure is ValidationFailure) {
      return 'Invalid input. Please check your comment.';
    } else if (failure is TimeoutFailure) {
      return 'Request timeout. Please try again.';
    } else if (failure is ServerFailure) {
      return 'Server error. Please try again later.';
    }
    return failure.message.isNotEmpty
        ? failure.message
        : 'Failed to post comment. Please try again.';
  }

  Future<void> voteOnComment({
    required String commentId,
    required String voteType,
  }) async {
    final currentState = state;
    if (currentState is! DiscussionDetailsLoaded) return;

    final commentIndex = currentState.comments.indexWhere(
      (c) => c.id == commentId,
    );
    if (commentIndex == -1) return;

    final comment = currentState.comments[commentIndex];

    int newUpvoteCount = comment.upvoteCount;
    int newDownvoteCount = comment.downvoteCount;
    bool newHasVoted = comment.hasVoted;
    String? newUserVoteType = comment.userVoteType;

    // User is removing their vote (clicking the same vote type they already voted)
    final isRemovingVote = comment.hasVoted && comment.userVoteType == voteType;
    if (isRemovingVote) {
      if (voteType == 'UP') {
        newUpvoteCount = comment.upvoteCount - 1;
      } else if (voteType == 'DOWN') {
        newDownvoteCount = comment.downvoteCount - 1;
      }
      newHasVoted = false;
      newUserVoteType = null;
    }
    // User is changing their vote (from UP to DOWN or vice versa)
    else if (comment.hasVoted && comment.userVoteType != voteType) {
      if (comment.userVoteType == 'UP') {
        newUpvoteCount = comment.upvoteCount - 1;
      } else if (comment.userVoteType == 'DOWN') {
        newDownvoteCount = comment.downvoteCount - 1;
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
        newUpvoteCount = comment.upvoteCount + 1;
      } else if (voteType == 'DOWN') {
        newDownvoteCount = comment.downvoteCount + 1;
      }
      newHasVoted = true;
      newUserVoteType = voteType;
    }

    final updatedComment = comment.copyWith(
      upvoteCount: newUpvoteCount,
      downvoteCount: newDownvoteCount,
      hasVoted: newHasVoted,
      userVoteType: newUserVoteType,
    );

    final updatedComments = List.of(currentState.comments);
    updatedComments[commentIndex] = updatedComment;

    emit(currentState.copyWith(comments: updatedComments));

    final result = isRemovingVote
        ? await deleteCommentVoteUseCase(commentId)
        : await voteOnCommentUseCase(VoteParams(id: commentId, type: voteType));

    result.fold(
      (failure) {
        refreshComments(currentState.discussion.id);
      },
      (_) {
        // Success - keep optimistic update
      },
    );
  }

  Future<void> voteOnDiscussion({
    required String discussionId,
    required String voteType,
  }) async {
    final currentState = state;
    if (currentState is! DiscussionDetailsLoaded) return;

    final discussion = currentState.discussion;

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

    final updatedDiscussion = discussion.copyWith(
      upvoteCount: newUpvoteCount,
      downvoteCount: newDownvoteCount,
      hasVoted: newHasVoted,
      userVoteType: newUserVoteType,
    );

    emit(currentState.copyWith(discussion: updatedDiscussion));

    final result = isRemovingVote
        ? await deleteDiscussionVoteUseCase(discussionId)
        : await voteOnDiscussionUseCase(
            VoteParams(id: discussionId, type: voteType),
          );

    result.fold(
      (failure) {
        // Revert on failure by reloading
        loadDiscussionDetails(discussionId);
      },
      (_) {
        // Success - keep optimistic update
      },
    );
  }
}

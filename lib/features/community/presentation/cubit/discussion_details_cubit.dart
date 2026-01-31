import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirath/core/utils/my_logger.dart';
import '../../../../core/error/failuors.dart';
import '../../../../core/services/user_cache_service.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/create_comment_params.dart';
import '../../domain/entities/discussion_author.dart';
import '../../domain/entities/vote_params.dart';
import '../../domain/usecases/create_comment_usecase.dart';
import '../../domain/usecases/get_discussion_by_id_usecase.dart';
import '../../domain/usecases/get_discussion_comments_usecase.dart';
import '../../domain/usecases/vote_on_comment_usecase.dart';
import 'discussion_details_state.dart';

class DiscussionDetailsCubit extends Cubit<DiscussionDetailsState> {
  final GetDiscussionByIdUseCase getDiscussionByIdUseCase;
  final GetDiscussionCommentsUseCase getDiscussionCommentsUseCase;
  final CreateCommentUseCase createCommentUseCase;
  final VoteOnCommentUseCase voteOnCommentUseCase;
  final UserCacheService userCacheService;

  DiscussionDetailsCubit({
    required this.getDiscussionByIdUseCase,
    required this.getDiscussionCommentsUseCase,
    required this.createCommentUseCase,
    required this.voteOnCommentUseCase,
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
            emit(
              DiscussionDetailsLoaded(
                discussion: discussion,
                comments: comments,
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
        emit(
          currentState.copyWith(comments: comments, isLoadingComments: false),
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
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    MyLogger.debug('[CUBIT] 🔄 Creating temp comment with ID: $tempId');

    // Get cached user for author info
    final cachedUser = userCacheService.getCachedUser();
    final tempAuthor = DiscussionAuthor(
      id: cachedUser?.id ?? currentState.discussion.authorId,
      username: cachedUser?.username ?? 'Unknown',
      fullName: cachedUser?.username ?? 'Unknown User',
      photoUrl: cachedUser?.photoURL,
      bio: null,
      role: 'user',
      isPremium: false,
    );
    MyLogger.debug(
      '[CUBIT] 👤 Using cached user: ${cachedUser?.username} (${cachedUser?.photoURL})',
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

    // Add comment optimistically
    final updatedComments = [...currentState.comments, tempComment];
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
        // Replace the temporary comment with the real one
        final finalComments = updatedComments
            .map((c) => c.id == tempId ? newComment : c)
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
    if (comment.hasVoted && comment.userVoteType == voteType) {
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

    final params = VoteParams(id: commentId, type: voteType);
    final result = await voteOnCommentUseCase(params);

    result.fold(
      (failure) {
        refreshComments(currentState.discussion.id);
      },
      (_) {
        // Success - keep optimistic update
      },
    );
  }
}

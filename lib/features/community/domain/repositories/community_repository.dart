import 'package:dartz/dartz.dart';

import '../../../../core/error/failuors.dart';
import '../entities/comment.dart';
import '../entities/create_comment_params.dart';
import '../entities/create_discussion_params.dart';
import '../entities/discussion.dart';
import '../entities/get_discussions_params.dart';
import '../entities/vote_params.dart';

abstract class CommunityRepository {
  /// Create a new discussion
  Future<Either<Failure, Discussion>> createDiscussion(
    CreateDiscussionParams params,
  );

  /// Get all discussions with pagination and filters
  Future<Either<Failure, List<Discussion>>> getAllDiscussions(
    GetDiscussionsParams params,
  );

  /// Get a specific discussion by ID
  Future<Either<Failure, Discussion>> getDiscussionById(String id);

  /// Delete a discussion
  Future<Either<Failure, void>> deleteDiscussion(String id);

  /// Vote on a discussion
  Future<Either<Failure, void>> voteOnDiscussion(VoteParams params);

  /// Delete vote from a discussion
  Future<Either<Failure, void>> deleteDiscussionVote(String id);

  /// Create a comment on a discussion
  Future<Either<Failure, Comment>> createComment(CreateCommentParams params);

  /// Get all comments for a discussion
  Future<Either<Failure, List<Comment>>> getDiscussionComments(
    String discussionId,
  );

  /// Vote on a comment
  Future<Either<Failure, void>> voteOnComment(VoteParams params);

  /// Delete vote from a comment
  Future<Either<Failure, void>> deleteCommentVote(String id);
}

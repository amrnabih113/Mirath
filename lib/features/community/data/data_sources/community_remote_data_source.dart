import '../models/comment_response.dart';
import '../models/comments_list_response.dart';
import '../models/discussion_response.dart';
import '../models/discussions_list_response.dart';

abstract class CommunityRemoteDataSource {
  /// Create a new discussion
  Future<DiscussionResponse> createDiscussion({
    required String title,
    required String content,
    required List<String> topicIds,
    List<String>? paperIds,
  });

  /// Get all discussions with pagination and filters
  Future<DiscussionsListResponse> getAllDiscussions({
    int page = 1,
    int limit = 10,
    String sort = 'new',
    String? topicId,
  });

  /// Get a specific discussion by ID
  Future<DiscussionResponse> getDiscussionById(String id);

  /// Delete a discussion
  Future<void> deleteDiscussion(String id);

  /// Vote on a discussion
  Future<void> voteOnDiscussion({
    required String id,
    required String type,
  });

  /// Delete vote from a discussion
  Future<void> deleteDiscussionVote(String id);

  /// Create a comment on a discussion
  Future<CommentResponse> createComment({
    required String discussionId,
    required String content,
    String? parentId,
  });

  /// Get all comments for a discussion
  Future<CommentsListResponse> getDiscussionComments(String discussionId);

  /// Vote on a comment
  Future<void> voteOnComment({
    required String id,
    required String type,
  });

  /// Delete vote from a comment
  Future<void> deleteCommentVote(String id);
}

import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/my_constants.dart';
import '../models/comment_response.dart';
import '../models/comments_list_response.dart';
import '../models/discussion_response.dart';
import '../models/discussions_list_response.dart';
import 'community_remote_data_source.dart';

class CommunityRemoteDataSourceImpl implements CommunityRemoteDataSource {
  final DioClient _dioClient;

  CommunityRemoteDataSourceImpl({required DioClient dioClient})
    : _dioClient = dioClient;

  @override
  Future<DiscussionResponse> createDiscussion({
    required String title,
    required String content,
    required List<String> topicIds,
    List<String>? paperIds,
  }) async {
    final response = await _dioClient.post(
      MyConstants.createDiscussion,
      data: {
        'title': title,
        'content': content,
        'topicIds': topicIds,
        if (paperIds != null && paperIds.isNotEmpty) 'paperIds': paperIds,
      },
    );
    return DiscussionResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<DiscussionsListResponse> getAllDiscussions({
    int page = 1,
    int limit = 10,
    String sort = 'new',
    String? topicId,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      'sort': sort,
      if (topicId != null) 'topicId': topicId,
    };

    final response = await _dioClient.get(
      MyConstants.getAllDiscussions,
      queryParameters: queryParams,
    );
    return DiscussionsListResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<DiscussionResponse> getDiscussionById(String id) async {
    final endpoint = MyConstants.getDiscussionById.replaceAll('{id}', id);
    final response = await _dioClient.get(endpoint);
    return DiscussionResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteDiscussion(String id) async {
    final endpoint = MyConstants.deleteDiscussion.replaceAll('{id}', id);
    await _dioClient.delete(endpoint);
  }

  @override
  Future<void> voteOnDiscussion({
    required String id,
    required String type,
  }) async {
    final endpoint = MyConstants.voteOnDiscussion.replaceAll('{id}', id);
    await _dioClient.post(endpoint, data: {'type': type});
  }

  @override
  Future<void> deleteDiscussionVote(String id) async {
    final endpoint = MyConstants.deleteDiscussionVote.replaceAll('{id}', id);
    await _dioClient.delete(endpoint);
  }

  @override
  Future<CommentResponse> createComment({
    required String discussionId,
    required String content,
    String? parentId,
  }) async {
    final endpoint = MyConstants.createComment.replaceAll('{id}', discussionId);
    final response = await _dioClient.post(
      endpoint,
      data: {'content': content, if (parentId != null) 'parentId': parentId},
    );
    return CommentResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<CommentsListResponse> getDiscussionComments(
    String discussionId,
  ) async {
    final endpoint = MyConstants.getDiscussionComments.replaceAll(
      '{id}',
      discussionId,
    );
    final response = await _dioClient.get(endpoint);
    return CommentsListResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> voteOnComment({required String id, required String type}) async {
    final endpoint = MyConstants.voteOnComment.replaceAll('{id}', id);
    await _dioClient.post(endpoint, data: {'type': type});
  }

  @override
  Future<void> deleteCommentVote(String id) async {
    final endpoint = MyConstants.deleteCommentVote.replaceAll('{id}', id);
    await _dioClient.delete(endpoint);
  }
}

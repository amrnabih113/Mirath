import 'package:dartz/dartz.dart';

import '../../../../core/api/fetch_policy.dart';
import '../../../../core/api/repository_base.dart';
import '../../../../core/api/resource.dart';
import '../../../../core/cache/cache_keys.dart';
import '../../../../core/cache/hive_cache_service.dart';
import '../../../../core/error/failuors.dart';
import '../../../../core/utils/my_logger.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/create_comment_params.dart';
import '../../domain/entities/create_discussion_params.dart';
import '../../domain/entities/discussion.dart';
import '../../domain/entities/get_discussions_params.dart';
import '../../domain/entities/vote_params.dart';
import '../../domain/repositories/community_repository.dart';
import '../data_sources/community_remote_data_source.dart';
import '../models/discussion_model.dart';

class CommunityRepositoryImpl
    with RepositoryBase
    implements CommunityRepository {
  final CommunityRemoteDataSource _remoteDataSource;
  final HiveCacheService _cacheService;

  CommunityRepositoryImpl({
    required CommunityRemoteDataSource remoteDataSource,
    required HiveCacheService cacheService,
  }) : _remoteDataSource = remoteDataSource,
       _cacheService = cacheService;

  @override
  HiveCacheService get cacheService => _cacheService;

  @override
  Future<Either<Failure, Discussion>> createDiscussion(
    CreateDiscussionParams params,
  ) async {
    try {
      final response = await _remoteDataSource.createDiscussion(
        title: params.title,
        content: params.content,
        topicIds: params.topicIds,
        paperIds: params.paperIds,
      );
      await upsertCachedDiscussion(response.data);
      return Right(response.data);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Discussion>>> getAllDiscussions(
    GetDiscussionsParams params,
  ) async {
    try {
      final response = await _remoteDataSource.getAllDiscussions(
        page: params.page,
        limit: params.limit,
        sort: params.sort,
        topicId: params.topicId,
        authorId: params.authorId,
      );
      await cacheDiscussions(response.data, params);
      return Right(response.data);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Discussion>> getDiscussionById(String id) async {
    final cacheKey = CacheKeys.discussionById(id);
    final res = await fetchWithCache<Discussion>(
      cacheKey: cacheKey,
      fetchRemote: () async =>
          (await _remoteDataSource.getDiscussionById(id)).data,
      fromJson: (json) => DiscussionModel.fromJson(json),
      policy: FetchPolicy.staleWhileRevalidate,
    );

    if (res.status == ResourceStatus.success && res.data != null) {
      return Right(res.data!);
    }
    if (res.failure != null) return Left(res.failure!);
    return Left(mapExceptionToFailure(Exception('Failed to fetch discussion')));
  }

  @override
  Future<Either<Failure, void>> deleteDiscussion(String id) async {
    try {
      await _remoteDataSource.deleteDiscussion(id);
      await removeCachedDiscussion(id);
      return const Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> voteOnDiscussion(VoteParams params) async {
    try {
      await _remoteDataSource.voteOnDiscussion(
        id: params.id,
        type: params.type,
      );
      await updateDiscussionVoteInCache(
        discussionId: params.id,
        voteType: params.type,
        isRemovingVote: false,
      );
      return const Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDiscussionVote(String id) async {
    try {
      await _remoteDataSource.deleteDiscussionVote(id);
      await updateDiscussionVoteInCache(
        discussionId: id,
        voteType: 'UP',
        isRemovingVote: true,
      );
      return const Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Comment>> createComment(
    CreateCommentParams params,
  ) async {
    try {
      MyLogger.debug(
        '[REPO] Creating comment: discussionId=${params.discussionId}, content=${params.content}, parentId=${params.parentId}',
      );
      final response = await _remoteDataSource.createComment(
        discussionId: params.discussionId,
        content: params.content,
        parentId: params.parentId,
      );
      MyLogger.debug(
        '[REPO] Comment created successfully: ${response.data.id}',
      );
      return Right(response.data);
    } catch (e) {
      MyLogger.debug('[REPO] Error creating comment: $e');
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> getDiscussionComments(
    String discussionId,
  ) async {
    try {
      final response = await _remoteDataSource.getDiscussionComments(
        discussionId,
      );
      return Right(response.data);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> voteOnComment(VoteParams params) async {
    try {
      await _remoteDataSource.voteOnComment(id: params.id, type: params.type);
      await updateCommentVoteInCache(
        commentId: params.id,
        voteType: params.type,
        isRemovingVote: false,
      );
      return const Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCommentVote(String id) async {
    try {
      await _remoteDataSource.deleteCommentVote(id);
      await updateCommentVoteInCache(
        commentId: id,
        voteType: 'UP',
        isRemovingVote: true,
      );
      return const Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<void> updateCommentVoteInCache({
    required String commentId,
    required String voteType,
    required bool isRemovingVote,
  }) async {
    Map<String, dynamic> transform(Map<String, dynamic> current) {
      final upvoteCount = (current['upvoteCount'] as int?) ?? 0;
      final downvoteCount = (current['downvoteCount'] as int?) ?? 0;
      final hasVoted = current['hasVoted'] as bool? ?? false;
      final currentVote = current['userVoteType'] as String?;

      var nextUpvotes = upvoteCount;
      var nextDownvotes = downvoteCount;
      var nextHasVoted = hasVoted;
      String? nextVote = currentVote;

      if (isRemovingVote) {
        if (voteType == 'UP') {
          nextUpvotes = nextUpvotes - 1;
        } else if (voteType == 'DOWN') {
          nextDownvotes = nextDownvotes - 1;
        }
        nextHasVoted = false;
        nextVote = null;
      } else if (hasVoted && currentVote != voteType) {
        if (currentVote == 'UP') {
          nextUpvotes = nextUpvotes - 1;
        } else if (currentVote == 'DOWN') {
          nextDownvotes = nextDownvotes - 1;
        }
        if (voteType == 'UP') {
          nextUpvotes = nextUpvotes + 1;
        } else if (voteType == 'DOWN') {
          nextDownvotes = nextDownvotes + 1;
        }
        nextVote = voteType;
      } else {
        if (voteType == 'UP') {
          nextUpvotes = nextUpvotes + 1;
        } else if (voteType == 'DOWN') {
          nextDownvotes = nextDownvotes + 1;
        }
        nextHasVoted = true;
        nextVote = voteType;
      }

      current['upvoteCount'] = nextUpvotes;
      current['downvoteCount'] = nextDownvotes;
      current['hasVoted'] = nextHasVoted;
      current['userVoteType'] = nextVote;
      return current;
    }

    await _cacheService.updateJsonListItem(
      key: CacheKeys.commentById(commentId),
      itemId: commentId,
      idField: 'id',
      updater: transform,
    );
    await _cacheService.updateJsonListItemsByPrefix(
      prefix: CacheKeys.commentsPrefix,
      itemId: commentId,
      idField: 'id',
      updater: transform,
    );
  }

  @override
  Future<List<Discussion>> getCachedDiscussions(
    GetDiscussionsParams params,
  ) async {
    final cached = await _cacheService.getJsonList(
      CacheKeys.discussions(
        sort: params.sort,
        topicId: params.topicId,
        authorId: params.authorId,
        page: params.page,
        limit: params.limit,
      ),
      allowStale: true,
    );

    if (cached == null) {
      return [];
    }

    return cached.map((json) => DiscussionModel.fromJson(json)).toList();
  }

  @override
  Future<void> cacheDiscussions(
    List<Discussion> discussions,
    GetDiscussionsParams params,
  ) async {
    await _cacheService.putJsonList(
      CacheKeys.discussions(
        sort: params.sort,
        topicId: params.topicId,
        authorId: params.authorId,
        page: params.page,
        limit: params.limit,
      ),
      discussions.map(_discussionToJson).toList(),
    );
  }

  @override
  Future<Discussion?> getCachedDiscussionById(String id) async {
    final cached = await _cacheService.getJson(
      CacheKeys.discussionById(id),
      allowStale: true,
    );
    if (cached == null) {
      return null;
    }

    return DiscussionModel.fromJson(cached);
  }

  @override
  Future<void> upsertCachedDiscussion(Discussion discussion) async {
    final payload = _discussionToJson(discussion);
    await _cacheService.putJson(
      CacheKeys.discussionById(discussion.id),
      payload,
    );
    await _cacheService.upsertInJsonList(
      key: CacheKeys.discussionsPrefix,
      item: payload,
      idField: 'id',
    );
    await _cacheService.updateJsonListItemsByPrefix(
      prefix: CacheKeys.discussionsPrefix,
      itemId: discussion.id,
      idField: 'id',
      updater: (_) => payload,
    );
  }

  @override
  Future<void> removeCachedDiscussion(String id) async {
    await _cacheService.remove(CacheKeys.discussionById(id));
    await _cacheService.removeJsonListItemsByPrefix(
      prefix: CacheKeys.discussionsPrefix,
      itemId: id,
      idField: 'id',
    );
  }

  @override
  Future<void> updateDiscussionVoteInCache({
    required String discussionId,
    required String voteType,
    required bool isRemovingVote,
  }) async {
    Map<String, dynamic> transform(Map<String, dynamic> current) {
      final upvoteCount = (current['upvoteCount'] as int?) ?? 0;
      final downvoteCount = (current['downvoteCount'] as int?) ?? 0;
      final hasVoted = current['hasVoted'] as bool? ?? false;
      final currentVote = current['userVoteType'] as String?;

      var nextUpvotes = upvoteCount;
      var nextDownvotes = downvoteCount;
      var nextHasVoted = hasVoted;
      String? nextVote = currentVote;

      if (isRemovingVote) {
        if (voteType == 'UP') {
          nextUpvotes = nextUpvotes - 1;
        } else if (voteType == 'DOWN') {
          nextDownvotes = nextDownvotes - 1;
        }
        nextHasVoted = false;
        nextVote = null;
      } else if (hasVoted && currentVote != voteType) {
        if (currentVote == 'UP') {
          nextUpvotes = nextUpvotes - 1;
        } else if (currentVote == 'DOWN') {
          nextDownvotes = nextDownvotes - 1;
        }
        if (voteType == 'UP') {
          nextUpvotes = nextUpvotes + 1;
        } else if (voteType == 'DOWN') {
          nextDownvotes = nextDownvotes + 1;
        }
        nextVote = voteType;
      } else {
        if (voteType == 'UP') {
          nextUpvotes = nextUpvotes + 1;
        } else if (voteType == 'DOWN') {
          nextDownvotes = nextDownvotes + 1;
        }
        nextHasVoted = true;
        nextVote = voteType;
      }

      current['upvoteCount'] = nextUpvotes;
      current['downvoteCount'] = nextDownvotes;
      current['hasVoted'] = nextHasVoted;
      current['userVoteType'] = nextVote;
      return current;
    }

    await _cacheService.updateJsonListItem(
      key: CacheKeys.discussionById(discussionId),
      itemId: discussionId,
      idField: 'id',
      updater: transform,
    );
    await _cacheService.updateJsonListItemsByPrefix(
      prefix: CacheKeys.discussionsPrefix,
      itemId: discussionId,
      idField: 'id',
      updater: transform,
    );
  }

  @override
  Future<void> updateDiscussionFollowState({
    required String userId,
    required bool isFollowing,
  }) async {
    Map<String, dynamic> transform(Map<String, dynamic> current) {
      final author = current['author'];
      if (author is Map && author['id']?.toString() == userId) {
        current['author'] = {
          ...Map<String, dynamic>.from(author),
          'isFollowing': isFollowing,
        };
      }
      return current;
    }

    await _cacheService.updateJsonListItemsByPrefix(
      prefix: CacheKeys.discussionsPrefix,
      itemId: userId,
      idField: 'authorId',
      updater: transform,
    );
  }

  Map<String, dynamic> _discussionToJson(Discussion discussion) {
    return {
      'id': discussion.id,
      'title': discussion.title,
      'content': discussion.content,
      'upvoteCount': discussion.upvoteCount,
      'downvoteCount': discussion.downvoteCount,
      'commentCount': discussion.commentCount,
      'authorId': discussion.authorId,
      'paperIds': discussion.paperIds,
      'papers': discussion.papers
          .map(
            (paper) => {
              'id': paper.id,
              'authors': paper.authors,
              'title': paper.title,
              'abstract': paper.abstract,
            },
          )
          .toList(),
      'createdAt': discussion.createdAt.toIso8601String(),
      'updatedAt': discussion.updatedAt.toIso8601String(),
      'hasVoted': discussion.hasVoted,
      'userVoteType': discussion.userVoteType,
      'topics': discussion.topics
          .map(
            (topic) => {
              'id': topic.id,
              'name': topic.name,
              'custom': topic.custom,
            },
          )
          .toList(),
      'author': {
        'id': discussion.author.id,
        'username': discussion.author.username,
        'fullName': discussion.author.fullName,
        'photoUrl': discussion.author.photoUrl,
        'bio': discussion.author.bio,
        'role': discussion.author.role,
        'isPremium': discussion.author.isPremium,
        'isFollowing': discussion.author.isFollowing,
        'isMe': discussion.author.isMe,
      },
    };
  }
}

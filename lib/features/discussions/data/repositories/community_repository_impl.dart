import 'package:dartz/dartz.dart';
import 'package:mirath/core/utils/my_logger.dart';

import '../../../../core/error/failuors.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/create_comment_params.dart';
import '../../domain/entities/create_discussion_params.dart';
import '../../domain/entities/discussion.dart';
import '../../domain/entities/get_discussions_params.dart';
import '../../domain/entities/vote_params.dart';
import '../../domain/repositories/community_repository.dart';
import '../data_sources/community_remote_data_source.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityRemoteDataSource _remoteDataSource;

  CommunityRepositoryImpl({required CommunityRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

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
      return Right(response.data);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Discussion>> getDiscussionById(String id) async {
    try {
      final response = await _remoteDataSource.getDiscussionById(id);
      return Right(response.data);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDiscussion(String id) async {
    try {
      await _remoteDataSource.deleteDiscussion(id);
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
      return const Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDiscussionVote(String id) async {
    try {
      await _remoteDataSource.deleteDiscussionVote(id);
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
      return const Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCommentVote(String id) async {
    try {
      await _remoteDataSource.deleteCommentVote(id);
      return const Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}

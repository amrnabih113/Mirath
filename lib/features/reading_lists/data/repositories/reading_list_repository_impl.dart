import 'package:dartz/dartz.dart';
import '../../../../core/cache/cache_keys.dart';
import '../../../../core/cache/hive_cache_service.dart';
import '../../../../core/error/failuors.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/add_paper_to_list_params.dart';
import '../../domain/entities/create_reading_list_params.dart';
import '../../domain/entities/reading_list.dart';
import '../../domain/entities/reading_list_query_params.dart';
import '../../domain/entities/update_reading_list_params.dart';
import '../../domain/repositories/reading_list_repository.dart';
import '../data_sources/reading_list_remote_data_source.dart';
import '../models/reading_list_model.dart';
import '../../../../core/api/repository_base.dart';
import '../../../../core/api/fetch_policy.dart';
import '../../../../core/api/resource.dart';

class ReadingListRepositoryImpl
    with RepositoryBase
    implements ReadingListRepository {
  final ReadingListRemoteDataSource remoteDataSource;
  final HiveCacheService cacheService;

  const ReadingListRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheService,
  });

  @override
  Future<Either<Failure, List<ReadingList>>> getReadingLists(
    ReadingListQueryParams params,
  ) async {
    try {
      final response = await remoteDataSource.getReadingLists(params);
      await cacheReadingLists(response.data, params);
      return Right(response.data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch reading lists'));
    }
  }

  @override
  Future<List<ReadingList>> getCachedReadingLists(
    ReadingListQueryParams params,
  ) async {
    final cached = await cacheService.getJsonList(
      CacheKeys.readingLists(
        ownerId: params.ownerId,
        saved: params.saved,
        all: params.all,
        page: params.page,
        limit: params.limit,
      ),
      allowStale: true,
    );

    if (cached == null) {
      return [];
    }

    return cached.map((json) => ReadingListModel.fromJson(json)).toList();
  }

  @override
  Future<void> cacheReadingLists(
    List<ReadingList> readingLists,
    ReadingListQueryParams params,
  ) async {
    await cacheService.putJsonList(
      CacheKeys.readingLists(
        ownerId: params.ownerId,
        saved: params.saved,
        all: params.all,
        page: params.page,
        limit: params.limit,
      ),
      readingLists.map(_readingListToJson).toList(),
    );
  }

  @override
  Future<Either<Failure, ReadingList>> createReadingList(
    CreateReadingListParams params,
  ) async {
    try {
      final response = await remoteDataSource.createReadingList(params);
      await upsertCachedReadingList(response.data);
      return Right(response.data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to create reading list'));
    }
  }

  @override
  Future<ReadingList?> getCachedReadingListById(String id) async {
    final cached = await cacheService.getJson(
      CacheKeys.readingListById(id),
      allowStale: true,
    );

    if (cached == null) {
      return null;
    }

    return ReadingListModel.fromJson(cached);
  }

  @override
  Future<Either<Failure, ReadingList>> getReadingListById(String id) async {
    final cacheKey = CacheKeys.readingListById(id);
    final res = await fetchWithCache<ReadingList>(
      cacheKey: cacheKey,
      fetchRemote: () async =>
          (await remoteDataSource.getReadingListById(id)).data,
      fromJson: (json) => ReadingListModel.fromJson(json),
      policy: FetchPolicy.staleWhileRevalidate,
    );

    if (res.status == ResourceStatus.success && res.data != null) {
      return Right(res.data!);
    }

    if (res.failure != null) return Left(res.failure!);
    return Left(ServerFailure('Failed to fetch reading list'));
  }

  @override
  Future<Either<Failure, ReadingList>> updateReadingList(
    UpdateReadingListParams params,
  ) async {
    try {
      final response = await remoteDataSource.updateReadingList(params);
      await upsertCachedReadingList(response.data);
      return Right(response.data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to update reading list'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReadingList(String id) async {
    try {
      await remoteDataSource.deleteReadingList(id);
      await removeCachedReadingList(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to delete reading list'));
    }
  }

  @override
  Future<Either<Failure, void>> addPaperToList(
    AddPaperToListParams params,
  ) async {
    try {
      await remoteDataSource.addPaperToList(params);
      await updateReadingListPaperCache(
        readingListId: params.readingListId,
        paperId: params.paperId,
        isAdding: true,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to add paper to list'));
    }
  }

  @override
  Future<Either<Failure, void>> removePaperFromList({
    required String readingListId,
    required String paperId,
  }) async {
    try {
      await remoteDataSource.removePaperFromList(
        readingListId: readingListId,
        paperId: paperId,
      );
      await updateReadingListPaperCache(
        readingListId: readingListId,
        paperId: paperId,
        isAdding: false,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to remove paper from list'));
    }
  }

  @override
  Future<Either<Failure, void>> saveReadingList(String id) async {
    try {
      await remoteDataSource.saveReadingList(id);
      await updateReadingListSavedState(readingListId: id, isSaved: true);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to save reading list'));
    }
  }

  @override
  Future<Either<Failure, void>> unsaveReadingList(String id) async {
    try {
      await remoteDataSource.unsaveReadingList(id);
      await updateReadingListSavedState(readingListId: id, isSaved: false);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message!));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message!));
    } catch (e) {
      return Left(ServerFailure('Failed to unsave reading list'));
    }
  }

  @override
  Future<void> upsertCachedReadingList(ReadingList readingList) async {
    final payload = _readingListToJson(readingList);
    await cacheService.putJson(
      CacheKeys.readingListById(readingList.id),
      payload,
    );
    await cacheService.upsertInJsonList(
      key: CacheKeys.readingListsPrefix,
      item: payload,
      idField: 'id',
    );
    await cacheService.updateJsonListItemsByPrefix(
      prefix: CacheKeys.readingListsPrefix,
      itemId: readingList.id,
      idField: 'id',
      updater: (_) => payload,
    );
  }

  @override
  Future<void> removeCachedReadingList(String id) async {
    await cacheService.remove(CacheKeys.readingListById(id));
    await cacheService.removeJsonListItemsByPrefix(
      prefix: CacheKeys.readingListsPrefix,
      itemId: id,
      idField: 'id',
    );
  }

  @override
  Future<void> updateReadingListSavedState({
    required String readingListId,
    required bool isSaved,
  }) async {
    Map<String, dynamic> transform(Map<String, dynamic> current) {
      current['isSaved'] = isSaved;
      return current;
    }

    await cacheService.updateJsonListItem(
      key: CacheKeys.readingListById(readingListId),
      itemId: readingListId,
      idField: 'id',
      updater: transform,
    );
    await cacheService.updateJsonListItemsByPrefix(
      prefix: CacheKeys.readingListsPrefix,
      itemId: readingListId,
      idField: 'id',
      updater: transform,
    );
  }

  @override
  Future<void> updateReadingListDetailsCache(ReadingList readingList) async {
    await upsertCachedReadingList(readingList);
  }

  @override
  Future<void> updateReadingListPaperCache({
    required String readingListId,
    required String paperId,
    required bool isAdding,
  }) async {
    Map<String, dynamic> transform(Map<String, dynamic> current) {
      final paperCount = (current['paperCount'] as int?) ?? 0;
      current['paperCount'] = isAdding
          ? paperCount + 1
          : (paperCount > 0 ? paperCount - 1 : 0);

      final papers = current['papers'];
      if (papers is List) {
        if (isAdding) {
          final exists = papers.any(
            (paper) => paper is Map && paper['paperId']?.toString() == paperId,
          );
          if (!exists) {
            papers.add({
              'readingListId': readingListId,
              'paperId': paperId,
              'paper': null,
            });
          }
        } else {
          current['papers'] = papers
              .where(
                (paper) =>
                    paper is Map && paper['paperId']?.toString() != paperId,
              )
              .toList();
        }
      }

      return current;
    }

    await cacheService.updateJsonListItem(
      key: CacheKeys.readingListById(readingListId),
      itemId: readingListId,
      idField: 'id',
      updater: transform,
    );
    await cacheService.updateJsonListItemsByPrefix(
      prefix: CacheKeys.readingListsPrefix,
      itemId: readingListId,
      idField: 'id',
      updater: transform,
    );
  }

  Map<String, dynamic> _readingListToJson(ReadingList readingList) {
    return {
      'id': readingList.id,
      'title': readingList.title,
      'description': readingList.description,
      'isPublic': readingList.isPublic,
      'ownerId': readingList.ownerId,
      'createdAt': readingList.createdAt.toIso8601String(),
      'updatedAt': readingList.updatedAt.toIso8601String(),
      'paperCount': readingList.paperCount,
      'isSaved': readingList.isSaved,
      'previewTags': readingList.previewTags,
      if (readingList.papers != null)
        'papers': readingList.papers!
            .map(
              (paper) => {
                'readingListId': paper.readingListId,
                'paperId': paper.paperId,
                'paper': paper.paper == null
                    ? null
                    : {
                        'id': paper.paper!.id,
                        'title': paper.paper!.title,
                        'preprint': paper.paper!.preprint,
                        'abstract': paper.paper!.abstract,
                        'publishedAt': paper.paper!.publishedAt
                            .toIso8601String(),
                        'authors': paper.paper!.authors,
                        'categories': paper.paper!.categories,
                        'isSaved': paper.paper!.isSaved,
                        'citation': paper.paper!.citation,
                      },
              },
            )
            .toList(),
      if (readingList.owner != null)
        'owner': {
          'id': readingList.owner!.id,
          'username': readingList.owner!.username,
          'fullName': readingList.owner!.fullName,
          'photoUrl': readingList.owner!.photoUrl,
        },
    };
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failuors.dart';
import '../../../../core/cache/cache_keys.dart';
import '../../../../core/cache/hive_cache_service.dart';
import '../../../../core/network/network_manager.dart';
import '../../../discussions/domain/entities/discussion.dart';
import '../../../reading_lists/domain/entities/reading_list.dart';
import '../../../users/domain/entities/user.dart';
import '../../domain/entities/global_search_results.dart';
import '../../domain/entities/paper_entity.dart';
import '../../domain/entities/search_history_item.dart';
import '../../domain/repositories/home_repository.dart';
import '../data_sources/home_remote_data_source.dart';
import '../models/home_recent_paper_model.dart';
import '../models/home_recommendation_paper_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final NetworkManager networkManager;
  final HiveCacheService cacheService;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkManager,
    required this.cacheService,
  });

  @override
  Future<Either<Failure, List<PaperEntity>>> getRecentPapers({
    String? category,
    int page = 1,
    int limit = 10,
  }) async {
    if (!await networkManager.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.getRecentPapers(
        category: category,
        page: page,
        limit: limit,
      );

      final papers = response.data
          .map((model) => model.toPaperEntity())
          .toList();
      await cacheRecentPapers(
        papers,
        category: category,
        page: page,
        limit: limit,
      );

      return Right(papers);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<List<PaperEntity>> getCachedRecentPapers({
    String? category,
    int page = 1,
    int limit = 10,
  }) async {
    final cached = await cacheService.getJsonList(
      CacheKeys.homeRecent(category: category, page: page, limit: limit),
      allowStale: true,
    );

    if (cached == null) {
      return [];
    }

    return cached
        .map((json) => HomeRecentPaperModel.fromJson(json).toPaperEntity())
        .toList();
  }

  @override
  Future<void> cacheRecentPapers(
    List<PaperEntity> papers, {
    String? category,
    int page = 1,
    int limit = 10,
  }) async {
    final payload = papers
        .map(
          (paper) => {
            'id': paper.id,
            'title': paper.title,
            'preprint': paper.preprint,
            'abstract': paper.abstract,
            'publishedAt': paper.publishedAt.toIso8601String(),
            'authors': paper.authors,
            'categories': paper.categories,
            'isSaved': paper.isSaved,
            'citation': paper.citation,
          },
        )
        .toList();
    await cacheService.putJsonList(
      CacheKeys.homeRecent(category: category, page: page, limit: limit),
      payload,
    );
  }

  @override
  Future<Either<Failure, List<PaperEntity>>> getRecommendations({
    int page = 1,
    int limit = 5,
  }) async {
    if (!await networkManager.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.getRecommendations(
        page: page,
        limit: limit,
      );

      final papers = response.data
          .map((model) => model.toPaperEntity())
          .toList();
      await cacheRecommendations(papers, page: page, limit: limit);

      return Right(papers);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<List<PaperEntity>> getCachedRecommendations({
    int page = 1,
    int limit = 5,
  }) async {
    final cached = await cacheService.getJsonList(
      CacheKeys.homeRecommendations(page: page, limit: limit),
      allowStale: true,
    );

    if (cached == null) {
      return [];
    }

    return cached
        .map(
          (json) => HomeRecommendationPaperModel.fromJson(json).toPaperEntity(),
        )
        .toList();
  }

  @override
  Future<void> cacheRecommendations(
    List<PaperEntity> papers, {
    int page = 1,
    int limit = 5,
  }) async {
    final payload = papers
        .map(
          (paper) => {
            'id': paper.id,
            'title': paper.title,
            'preprint': paper.preprint,
            'abstract': paper.abstract,
            'publishedAt': paper.publishedAt.toIso8601String(),
            'authors': paper.authors,
            'categories': paper.categories,
            'isSaved': paper.isSaved,
            'citation': paper.citation,
          },
        )
        .toList();
    await cacheService.putJsonList(
      CacheKeys.homeRecommendations(page: page, limit: limit),
      payload,
    );
  }

  @override
  Future<Either<Failure, List<String>>> getPaperCategories({
    int page = 1,
    int limit = 20,
  }) async {
    if (!await networkManager.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final categories = await remoteDataSource.getPaperCategories(
        page: page,
        limit: limit,
      );

      await cachePaperCategories(categories, page: page, limit: limit);

      return Right(categories);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<List<String>> getCachedPaperCategories({
    int page = 1,
    int limit = 20,
  }) async {
    final cached = await cacheService.getJsonList(
      CacheKeys.homeCategories(page: page, limit: limit),
      allowStale: true,
    );

    if (cached == null) {
      return [];
    }

    return cached
        .map((item) => item['value']?.toString() ?? '')
        .where((value) => value.isNotEmpty)
        .toList();
  }

  @override
  Future<void> cachePaperCategories(
    List<String> categories, {
    int page = 1,
    int limit = 20,
  }) async {
    await cacheService.putJsonList(
      CacheKeys.homeCategories(page: page, limit: limit),
      categories.map((category) => {'value': category}).toList(),
    );
  }

  @override
  Future<Either<Failure, void>> savePaper(String paperId) async {
    if (!await networkManager.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      await remoteDataSource.savePaper(paperId);
      await updatePaperSavedInCache(paperId, true);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> unsavePaper(String paperId) async {
    if (!await networkManager.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      await remoteDataSource.unsavePaper(paperId);
      await updatePaperSavedInCache(paperId, false);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<void> updatePaperSavedInCache(String paperId, bool isSaved) async {
    final updater = (Map<String, dynamic> current) {
      current['isSaved'] = isSaved;
      return current;
    };

    await cacheService.updateJsonListItemsByPrefix(
      prefix: CacheKeys.homeRecentPrefix,
      itemId: paperId,
      idField: 'id',
      updater: updater,
    );
    await cacheService.updateJsonListItemsByPrefix(
      prefix: CacheKeys.homeRecommendationsPrefix,
      itemId: paperId,
      idField: 'id',
      updater: updater,
    );
  }

  @override
  Future<Either<Failure, List<PaperEntity>>> searchPapers(
    String query, {
    int page = 1,
    int limit = 10,
  }) async {
    if (!await networkManager.isConnected) {
      return Left(NetworkFailure());
    }
    try {
      final response = await remoteDataSource.searchPapers(
        query,
        page: page,
        limit: limit,
      );
      return Right(response.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Future.value(Left(ServerFailure()));
    }
  }

  @override
  Future<Either<Failure, GlobalSearchResults>> searchGlobal(
    String query, {
    int page = 1,
    int limit = 10,
  }) async {
    if (!await networkManager.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.searchGlobal(
        query,
        page: page,
        limit: limit,
      );

      return Right(
        GlobalSearchResults(
          discussions: List<Discussion>.from(response.discussions),
          readingLists: List<ReadingList>.from(response.readingLists),
          researchers: List<User>.from(response.researchers),
        ),
      );
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Discussion>>> searchDiscussions(
    String query, {
    int page = 1,
    int limit = 10,
  }) async {
    if (!await networkManager.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.searchDiscussions(
        query,
        page: page,
        limit: limit,
      );
      return Right(List<Discussion>.from(response));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ReadingList>>> searchReadingLists(
    String query, {
    int page = 1,
    int limit = 10,
  }) async {
    if (!await networkManager.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.searchReadingLists(
        query,
        page: page,
        limit: limit,
      );
      return Right(List<ReadingList>.from(response));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<User>>> searchResearchers(
    String query, {
    int page = 1,
    int limit = 10,
  }) async {
    if (!await networkManager.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.searchResearchers(
        query,
        page: page,
        limit: limit,
      );
      return Right(List<User>.from(response));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<SearchHistoryItem>>> getSearchHistory({
    int limit = 10,
  }) async {
    if (!await networkManager.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.getSearchHistory(limit: limit);
      return Right(response.data);
    } catch (e) {
      print('Error loading search history: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteSearchHistoryById(String id) async {
    if (!await networkManager.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      await remoteDataSource.deleteSearchHistoryById(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearSearchHistory() async {
    if (!await networkManager.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      await remoteDataSource.clearSearchHistory();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}

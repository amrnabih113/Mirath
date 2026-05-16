import '../entities/paper_entity.dart';
import '../repositories/home_repository.dart';

class HomeCacheUseCases {
  final HomeRepository repository;

  HomeCacheUseCases({required this.repository});

  Future<List<PaperEntity>> getCachedRecentPapers({
    String? category,
    int page = 1,
    int limit = 10,
  }) {
    return repository.getCachedRecentPapers(
      category: category,
      page: page,
      limit: limit,
    );
  }

  Future<void> cacheRecentPapers(
    List<PaperEntity> papers, {
    String? category,
    int page = 1,
    int limit = 10,
  }) {
    return repository.cacheRecentPapers(
      papers,
      category: category,
      page: page,
      limit: limit,
    );
  }

  Future<List<PaperEntity>> getCachedRecommendations({
    int page = 1,
    int limit = 5,
  }) {
    return repository.getCachedRecommendations(page: page, limit: limit);
  }

  Future<void> cacheRecommendations(
    List<PaperEntity> papers, {
    int page = 1,
    int limit = 5,
  }) {
    return repository.cacheRecommendations(papers, page: page, limit: limit);
  }

  Future<List<String>> getCachedPaperCategories({
    int page = 1,
    int limit = 20,
  }) {
    return repository.getCachedPaperCategories(page: page, limit: limit);
  }

  Future<void> cachePaperCategories(
    List<String> categories, {
    int page = 1,
    int limit = 20,
  }) {
    return repository.cachePaperCategories(
      categories,
      page: page,
      limit: limit,
    );
  }

  Future<void> updatePaperSavedInCache(String paperId, bool isSaved) {
    return repository.updatePaperSavedInCache(paperId, isSaved);
  }
}

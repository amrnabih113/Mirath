import '../models/home_recent_response_model.dart';
import '../models/home_recommendations_response_model.dart';
import '../models/save_paper_response_model.dart';
import '../models/search_history_response_model.dart';
import '../models/search_paper_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeRecentResponseModel> getRecentPapers({
    String? category,
    int page = 1,
    int limit = 10,
  });

  Future<HomeRecommendationsResponseModel> getRecommendations({
    int page = 1,
    int limit = 5,
  });

  Future<List<String>> getPaperCategories({int page = 1, int limit = 20});

  Future<SavePaperResponseModel> savePaper(String paperId);

  Future<void> unsavePaper(String paperId);

  Future<List<SearchPaperModel>> searchPapers(
    String query, {
    int page = 1,
    int limit = 10,
  });

  Future<SearchHistoryResponseModel> getSearchHistory({int limit = 10});

  Future<void> deleteSearchHistoryById(String id);

  Future<void> clearSearchHistory();
}

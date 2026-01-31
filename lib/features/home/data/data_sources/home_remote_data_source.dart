import '../models/home_recent_response_model.dart';
import '../models/home_recommendations_response_model.dart';

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
}

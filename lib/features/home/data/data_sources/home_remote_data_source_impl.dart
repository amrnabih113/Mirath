import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/my_constants.dart';
import '../models/home_recent_response_model.dart';
import '../models/home_recommendations_response_model.dart';
import '../models/save_paper_response_model.dart';
import 'home_remote_data_source.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient dioClient;

  HomeRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<HomeRecentResponseModel> getRecentPapers({
    String? category,
    int page = 1,
    int limit = 10,
  }) async {
    final params = {
      'page': page,
      'limit': limit,
      if (category != null) 'category': category,
    };

    final response = await dioClient.get(
      MyConstants.getRecent,
      queryParameters: params,
    );

    return HomeRecentResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<HomeRecommendationsResponseModel> getRecommendations({
    int page = 1,
    int limit = 5,
  }) async {
    final params = {'page': page, 'limit': limit};

    final response = await dioClient.get(
      MyConstants.getRecommended,
      queryParameters: params,
    );

    return HomeRecommendationsResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<SavePaperResponseModel> savePaper(String paperId) async {
    final endpoint = MyConstants.savePaper.replaceAll('{id}', paperId);
    final response = await dioClient.post(endpoint);
    return SavePaperResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<void> unsavePaper(String paperId) async {
    final endpoint = MyConstants.unsavePaper.replaceAll('{id}', paperId);
    await dioClient.delete(endpoint);
  }
}

import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/my_constants.dart';
import '../../../discussions/data/models/discussion_model.dart';
import '../../../reading_lists/data/models/reading_list_model.dart';
import '../../../users/data/models/user_model.dart';
import '../models/home_recent_response_model.dart';
import '../models/home_recommendations_response_model.dart';
import '../models/global_search_response_model.dart';
import '../models/save_paper_response_model.dart';
import '../models/search_history_response_model.dart';
import '../models/search_paper_model.dart';
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
  Future<List<String>> getPaperCategories({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await dioClient.get(
      MyConstants.getPaperCategories,
      queryParameters: {'page': page, 'limit': limit},
    );

    final data = response.data as Map<String, dynamic>;
    final categoriesJson = data['data'] as List<dynamic>? ?? [];

    return categoriesJson
        .map((categoryJson) {
          final category = categoryJson as Map<String, dynamic>;
          return category['name']?.toString() ?? '';
        })
        .where((name) => name.isNotEmpty)
        .toList();
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

  @override
  Future<List<SearchPaperModel>> searchPapers(
    String query, {
    int page = 1,
    int limit = 10,
  }) {
    final params = {'q': query, 'page': page, 'limit': limit};

    return dioClient
        .get(MyConstants.searchPapers, queryParameters: params)
        .then((response) {
          final data = response.data as Map<String, dynamic>;
          final papersJson = data['data'] as List<dynamic>;
          return papersJson
              .map(
                (paperJson) => SearchPaperModel.fromJson(
                  paperJson as Map<String, dynamic>,
                ),
              )
              .toList();
        });
  }

  @override
  Future<GlobalSearchResponseModel> searchGlobal(
    String query, {
    int page = 1,
    int limit = 10,
  }) async {
    final response = await dioClient.get(
      MyConstants.searchGlobal,
      queryParameters: {'query': query, 'page': page, 'limit': limit},
    );

    return GlobalSearchResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<List<DiscussionModel>> searchDiscussions(
    String query, {
    int page = 1,
    int limit = 10,
  }) async {
    final response = await dioClient.get(
      MyConstants.searchDiscussions,
      queryParameters: {'query': query, 'page': page, 'limit': limit},
    );
    final data = response.data as Map<String, dynamic>;
    final items = _extractList(data, ['data', 'discussions', 'items']);
    return items
        .whereType<Map<String, dynamic>>()
        .map(DiscussionModel.fromJson)
        .toList();
  }

  @override
  Future<List<ReadingListModel>> searchReadingLists(
    String query, {
    int page = 1,
    int limit = 10,
  }) async {
    final response = await dioClient.get(
      MyConstants.searchReadingLists,
      queryParameters: {'query': query, 'page': page, 'limit': limit},
    );
    final data = response.data as Map<String, dynamic>;
    final items = _extractList(data, [
      'data',
      'readingLists',
      'lists',
      'items',
    ]);
    return items
        .whereType<Map<String, dynamic>>()
        .map(ReadingListModel.fromJson)
        .toList();
  }

  @override
  Future<List<UserModel>> searchResearchers(
    String query, {
    int page = 1,
    int limit = 10,
  }) async {
    final response = await dioClient.get(
      MyConstants.searchResearchers,
      queryParameters: {'query': query, 'page': page, 'limit': limit},
    );
    final data = response.data as Map<String, dynamic>;
    final items = _extractList(data, ['data', 'researchers', 'users', 'items']);
    return items
        .whereType<Map<String, dynamic>>()
        .map(UserModel.fromJson)
        .toList();
  }

  List<dynamic> _extractList(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is List<dynamic>) {
        return value;
      }
    }
    return const [];
  }

  @override
  Future<SearchHistoryResponseModel> getSearchHistory({int limit = 10}) async {
    try {
      final response = await dioClient.get(
        MyConstants.searchHistory,
        queryParameters: {'limit': limit},
      );

      print('Search history response: ${response.data}');
      return SearchHistoryResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      print('Error in getSearchHistory data source: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteSearchHistoryById(String id) async {
    final endpoint = MyConstants.deleteSearchHistoryById.replaceAll('{id}', id);
    await dioClient.delete(endpoint);
  }

  @override
  Future<void> clearSearchHistory() async {
    await dioClient.delete(MyConstants.searchHistory);
  }
}

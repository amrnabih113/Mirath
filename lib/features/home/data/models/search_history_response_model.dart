import 'search_history_item_model.dart';

class SearchHistoryResponseModel {
  final int size;
  final List<SearchHistoryItemModel> data;

  const SearchHistoryResponseModel({required this.size, required this.data});

  factory SearchHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchHistoryResponseModel(
      size: json['size'] ?? 0,
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => SearchHistoryItemModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }
}

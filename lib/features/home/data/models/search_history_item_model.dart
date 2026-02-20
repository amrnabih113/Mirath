import '../../domain/entities/search_history_item.dart';

class SearchHistoryItemModel extends SearchHistoryItem {
  const SearchHistoryItemModel({
    required super.id,
    required super.query,
    required super.userId,
    required super.createdAt,
  });

  factory SearchHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return SearchHistoryItemModel(
      id: json['id'] ?? '',
      query: json['query'] ?? '',
      userId: json['userId'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}

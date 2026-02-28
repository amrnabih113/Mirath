import 'package:equatable/equatable.dart';

class SearchHistoryItem extends Equatable {
  final String id;
  final String query;
  final String userId;
  final DateTime createdAt;

  const SearchHistoryItem({
    required this.id,
    required this.query,
    required this.userId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, query, userId, createdAt];
}

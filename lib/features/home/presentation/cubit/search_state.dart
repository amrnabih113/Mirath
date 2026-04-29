import 'package:equatable/equatable.dart';

import '../../domain/entities/paper_entity.dart';
import '../../domain/entities/search_history_item.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchHistoryLoading extends SearchState {
  const SearchHistoryLoading();
}

class SearchHistoryLoaded extends SearchState {
  final List<SearchHistoryItem> history;

  const SearchHistoryLoaded({required this.history});

  @override
  List<Object?> get props => [history];
}

class SearchResultsLoading extends SearchState {
  const SearchResultsLoading();
}

class SearchResultsLoaded extends SearchState {
  final String query;
  final List<PaperEntity> results;
  final int currentPage;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const SearchResultsLoaded({
    required this.query,
    required this.results,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  SearchResultsLoaded copyWith({
    String? query,
    List<PaperEntity>? results,
    int? currentPage,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return SearchResultsLoaded(
      query: query ?? this.query,
      results: results ?? this.results,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    query,
    results,
    currentPage,
    hasReachedMax,
    isLoadingMore,
  ];
}

class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});

  @override
  List<Object?> get props => [message];
}

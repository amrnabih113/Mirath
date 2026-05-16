import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/no_params.dart';
import '../../domain/entities/search_history_item.dart';
import '../../domain/usecases/clear_search_history_usecase.dart';
import '../../domain/usecases/delete_search_history_usecase.dart';
import '../../domain/usecases/get_search_history_usecase.dart';
import '../../domain/usecases/search_papers_usecase.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final GetSearchHistoryUseCase getSearchHistoryUseCase;
  final DeleteSearchHistoryUseCase deleteSearchHistoryUseCase;
  final ClearSearchHistoryUseCase clearSearchHistoryUseCase;
  final SearchPapersUseCase searchPapersUseCase;

  // Track current page for pagination
  int _currentPage = 1;
  String _currentQuery = '';

  SearchCubit({
    required this.getSearchHistoryUseCase,
    required this.deleteSearchHistoryUseCase,
    required this.clearSearchHistoryUseCase,
    required this.searchPapersUseCase,
  }) : super(const SearchInitial());

  Future<void> loadSearchHistory({int limit = 10}) async {
    emit(const SearchHistoryLoading());

    final result = await getSearchHistoryUseCase(
      GetSearchHistoryParams(limit: limit),
    );

    result.fold(
      (failure) {
        emit(const SearchHistoryLoaded(history: []));
        emit(const SearchError(message: 'Failed to load search history'));
      },
      (history) {
        // Remove duplicates by keeping only the most recent item for each unique query
        final uniqueHistory = <String, SearchHistoryItem>{};
        for (final item in history) {
          final existingItem = uniqueHistory[item.query];
          if (existingItem == null ||
              item.createdAt.isAfter(existingItem.createdAt)) {
            uniqueHistory[item.query] = item;
          }
        }

        // Convert back to list and sort by createdAt (most recent first)
        final filteredHistory = uniqueHistory.values.toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        emit(SearchHistoryLoaded(history: filteredHistory));
      },
    );
  }

  Future<void> deleteSearchHistoryItem(String id) async {
    final currentState = state;
    if (currentState is! SearchHistoryLoaded) return;

    final result = await deleteSearchHistoryUseCase(id);

    result.fold(
      (failure) => emit(const SearchError(message: 'Failed to delete item')),
      (_) {
        final updated = currentState.history
            .where((item) => item.id != id)
            .toList();
        emit(SearchHistoryLoaded(history: updated));
      },
    );
  }

  Future<void> clearSearchHistory() async {
    final result = await clearSearchHistoryUseCase(const NoParams());

    result.fold(
      (failure) => emit(const SearchError(message: 'Failed to clear history')),
      (_) => emit(const SearchHistoryLoaded(history: [])),
    );
  }

  Future<void> searchPapers(
    String query, {
    int page = 1,
    int limit = 10,
  }) async {
    if (query.trim().isEmpty) return;

    emit(const SearchResultsLoading());

    // Reset pagination for new search
    _currentPage = 1;
    _currentQuery = query;

    final result = await searchPapersUseCase(
      SearchPapersParams(query: query, page: page, limit: limit),
    );

    result.fold(
      (failure) => emit(const SearchError(message: 'No results found')),
      (results) {
        emit(
          SearchResultsLoaded(
            query: query,
            results: results,
            currentPage: page,
            hasReachedMax: results.length < limit,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  Future<void> loadMorePapers({int limit = 10}) async {
    final currentState = state;
    if (currentState is! SearchResultsLoaded) return;
    if (currentState.hasReachedMax) return;
    if (currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    _currentPage++;

    final result = await searchPapersUseCase(
      SearchPapersParams(
        query: _currentQuery,
        page: _currentPage,
        limit: limit,
      ),
    );

    result.fold(
      (failure) {
        emit(currentState.copyWith(isLoadingMore: false));
      },
      (newResults) {
        final allResults = List.of(currentState.results)..addAll(newResults);

        emit(
          currentState.copyWith(
            results: allResults,
            currentPage: _currentPage,
            isLoadingMore: false,
            hasReachedMax: newResults.length < limit,
          ),
        );
      },
    );
  }
}

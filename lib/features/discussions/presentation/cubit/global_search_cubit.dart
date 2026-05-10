import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failuors.dart';
import '../../../discussions/domain/entities/discussion.dart';
import '../../../home/domain/entities/global_search_results.dart';
import '../../../home/domain/usecases/search_discussions_usecase.dart';
import '../../../home/domain/usecases/search_global_usecase.dart';
import '../../../home/domain/usecases/search_query_params.dart';
import '../../../home/domain/usecases/search_reading_lists_usecase.dart';
import '../../../home/domain/usecases/search_researchers_usecase.dart';
import '../../../reading_lists/domain/entities/reading_list.dart';
import '../../../users/domain/entities/user.dart';
import 'global_search_state.dart';

class GlobalSearchCubit extends Cubit<GlobalSearchState> {
  final SearchGlobalUseCase searchGlobalUseCase;
  final SearchDiscussionsUseCase searchDiscussionsUseCase;
  final SearchReadingListsUseCase searchReadingListsUseCase;
  final SearchResearchersUseCase searchResearchersUseCase;

  GlobalSearchCubit({
    required this.searchGlobalUseCase,
    required this.searchDiscussionsUseCase,
    required this.searchReadingListsUseCase,
    required this.searchResearchersUseCase,
  }) : super(const GlobalSearchState());

  void reset() {
    emit(const GlobalSearchState());
  }

  Future<void> searchTop(String query) async {
    await _search(
      query: query,
      scope: GlobalSearchScope.top,
      action: () => searchGlobalUseCase(SearchQueryParams(query: query.trim())),
    );
  }

  Future<void> searchDiscussions(String query) async {
    await _search(
      query: query,
      scope: GlobalSearchScope.discussions,
      action: () =>
          searchDiscussionsUseCase(SearchQueryParams(query: query.trim())),
    );
  }

  Future<void> searchReadingLists(String query) async {
    await _search(
      query: query,
      scope: GlobalSearchScope.readingLists,
      action: () =>
          searchReadingListsUseCase(SearchQueryParams(query: query.trim())),
    );
  }

  Future<void> searchResearchers(String query) async {
    await _search(
      query: query,
      scope: GlobalSearchScope.researchers,
      action: () =>
          searchResearchersUseCase(SearchQueryParams(query: query.trim())),
    );
  }

  Future<void> _search({
    required String query,
    required GlobalSearchScope scope,
    required Future<Either<Failure, dynamic>> Function() action,
  }) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      emit(GlobalSearchState(scope: scope));
      return;
    }

    emit(
      state.copyWith(
        status: GlobalSearchStatus.loading,
        scope: scope,
        query: normalizedQuery,
        errorMessage: null,
      ),
    );

    final result = await action();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: GlobalSearchStatus.failure,
            scope: scope,
            query: normalizedQuery,
            errorMessage: failure.toString(),
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(
            status: GlobalSearchStatus.loaded,
            scope: scope,
            query: normalizedQuery,
            results: _mapResults(scope, data),
            errorMessage: null,
          ),
        );
      },
    );
  }

  GlobalSearchResults _mapResults(GlobalSearchScope scope, dynamic data) {
    switch (scope) {
      case GlobalSearchScope.top:
        return data as GlobalSearchResults;
      case GlobalSearchScope.discussions:
        return GlobalSearchResults(
          discussions: List<Discussion>.from(data as List),
          readingLists: const [],
          researchers: const [],
        );
      case GlobalSearchScope.readingLists:
        return GlobalSearchResults(
          discussions: const [],
          readingLists: List<ReadingList>.from(data as List),
          researchers: const [],
        );
      case GlobalSearchScope.researchers:
        return GlobalSearchResults(
          discussions: const [],
          readingLists: const [],
          researchers: List<User>.from(data as List),
        );
    }
  }
}

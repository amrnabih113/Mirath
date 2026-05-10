import 'package:equatable/equatable.dart';

import '../../../home/domain/entities/global_search_results.dart';

enum GlobalSearchScope { top, discussions, readingLists, researchers }

enum GlobalSearchStatus { initial, loading, loaded, failure }

class GlobalSearchState extends Equatable {
  final GlobalSearchStatus status;
  final GlobalSearchScope scope;
  final String query;
  final GlobalSearchResults results;
  final String? errorMessage;

  const GlobalSearchState({
    this.status = GlobalSearchStatus.initial,
    this.scope = GlobalSearchScope.top,
    this.query = '',
    this.results = const GlobalSearchResults.empty(),
    this.errorMessage,
  });

  GlobalSearchState copyWith({
    GlobalSearchStatus? status,
    GlobalSearchScope? scope,
    String? query,
    GlobalSearchResults? results,
    String? errorMessage,
  }) {
    return GlobalSearchState(
      status: status ?? this.status,
      scope: scope ?? this.scope,
      query: query ?? this.query,
      results: results ?? this.results,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, scope, query, results, errorMessage];
}

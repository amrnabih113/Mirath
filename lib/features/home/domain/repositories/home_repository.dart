import 'package:dartz/dartz.dart';
import '../../../../core/error/failuors.dart';
import '../../../discussions/domain/entities/discussion.dart';
import '../../../reading_lists/domain/entities/reading_list.dart';
import '../../../users/domain/entities/user.dart';
import '../entities/global_search_results.dart';
import '../entities/paper_entity.dart';
import '../entities/search_history_item.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<PaperEntity>>> getRecentPapers({
    String? category,
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, List<PaperEntity>>> getRecommendations({
    int page = 1,
    int limit = 5,
  });

  Future<Either<Failure, List<String>>> getPaperCategories({
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, void>> savePaper(String paperId);

  Future<Either<Failure, void>> unsavePaper(String paperId);

  Future<Either<Failure, List<PaperEntity>>> searchPapers(
    String query, {
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, GlobalSearchResults>> searchGlobal(
    String query, {
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, List<Discussion>>> searchDiscussions(
    String query, {
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, List<ReadingList>>> searchReadingLists(
    String query, {
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, List<User>>> searchResearchers(
    String query, {
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, List<SearchHistoryItem>>> getSearchHistory({
    int limit = 10,
  });

  Future<Either<Failure, void>> deleteSearchHistoryById(String id);

  Future<Either<Failure, void>> clearSearchHistory();
}

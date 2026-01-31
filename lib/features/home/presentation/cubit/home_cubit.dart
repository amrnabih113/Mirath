import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirath/features/home/domain/entities/paper_entity.dart';

import '../../../../core/usecases/no_params.dart';
import '../../../users/domain/entities/user.dart';
import '../../../users/domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/get_recent_papers_usecase.dart';
import '../../domain/usecases/get_recommendations_usecase.dart';
import '../../domain/usecases/save_paper_usecase.dart';
import '../../domain/usecases/unsave_paper_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetRecentPapersUseCase getRecentPapersUseCase;
  final GetRecommendationsUseCase getRecommendationsUseCase;
  final GetCurrentUserUsecase getCurrentUserUsecase;
  final SavePaperUseCase savePaperUseCase;
  final UnsavePaperUseCase unsavePaperUseCase;

  HomeCubit({
    required this.getRecentPapersUseCase,
    required this.getRecommendationsUseCase,
    required this.getCurrentUserUsecase,
    required this.savePaperUseCase,
    required this.unsavePaperUseCase,
  }) : super(const HomeInitial());

  // Track current page for pagination
  int _recommendationPage = 1;

  Future<User?> loadCurrentUser() async {
    final result = await getCurrentUserUsecase(NoParams());

    return result.fold((failure) => null, (user) => user);
  }

  Future<void> getRecentPapers({
    String? category,
    int page = 1,
    int limit = 10,
  }) async {
    emit(const HomeLoading());

    final result = await getRecentPapersUseCase(
      GetRecentPapersParams(category: category, page: page, limit: limit),
    );

    result.fold(
      (failure) {
        emit(const HomeError(message: 'Failed to fetch recent papers'));
      },
      (papers) {
        emit(HomeRecentPapersLoaded(recentPapers: papers));
      },
    );
  }

  Future<void> getRecommendations({int page = 1, int limit = 5}) async {
    emit(const HomeLoading());
    final result = await getRecommendationsUseCase(
      GetRecommendationsParams(page: page, limit: limit),
    );

    result.fold(
      (failure) {
        emit(const HomeError(message: 'Failed to fetch recommendations'));
      },
      (papers) {
        emit(HomeRecommendationsLoaded(recommendations: papers));
      },
    );
  }

  Future<void> loadAllPapers({
    String? category,
    int recentLimit = 10,
    int recommendationLimit = 5,
  }) async {
    emit(const HomeLoading());

    // Reset pagination
    _recommendationPage = 1;

    final recentResult = await getRecentPapersUseCase(
      GetRecentPapersParams(category: category, page: 1, limit: recentLimit),
    );

    final recommendationResult = await getRecommendationsUseCase(
      GetRecommendationsParams(
        page: _recommendationPage,
        limit: recommendationLimit,
      ),
    );

    recentResult.fold(
      (failure) {
        emit(const HomeError(message: 'Failed to fetch papers'));
      },
      (recentPapers) {
        recommendationResult.fold(
          (failure) {
            emit(const HomeError(message: 'Failed to fetch recommendations'));
          },
          (recommendations) {
            emit(
              HomePapersLoaded(
                recentPapers: recentPapers,
                recommendations: recommendations,
                hasReachedMaxRecommendations:
                    recommendations.length < recommendationLimit,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> loadMoreRecommendations({int limit = 5}) async {
    final currentState = state;
    if (currentState is! HomePapersLoaded) return;
    if (currentState.hasReachedMaxRecommendations) return;
    if (currentState.isLoadingMoreRecommendations) return;

    emit(currentState.copyWith(isLoadingMoreRecommendations: true));

    _recommendationPage++;

    final result = await getRecommendationsUseCase(
      GetRecommendationsParams(page: _recommendationPage, limit: limit),
    );

    result.fold(
      (failure) {
        emit(currentState.copyWith(isLoadingMoreRecommendations: false));
      },
      (newPapers) {
        final allPapers = List.of(currentState.recommendations)
          ..addAll(newPapers);

        emit(
          currentState.copyWith(
            recommendations: allPapers,
            isLoadingMoreRecommendations: false,
            hasReachedMaxRecommendations: newPapers.length < limit,
          ),
        );
      },
    );
  }

  Future<void> savePaper(String paperId) async {
    final result = await savePaperUseCase(paperId);

    result.fold(
      (failure) {
        // Handle error if needed
      },
      (_) {
        // Update paper isSaved status in state
        _updatePaperSavedStatus(paperId, true);
      },
    );
  }

  Future<void> unsavePaper(String paperId) async {
    final result = await unsavePaperUseCase(paperId);

    result.fold(
      (failure) {
        // Handle error if needed
      },
      (_) {
        // Update paper isSaved status in state
        _updatePaperSavedStatus(paperId, false);
      },
    );
  }

  void _updatePaperSavedStatus(String paperId, bool isSaved) {
    final currentState = state;

    if (currentState is HomePapersLoaded) {
      final updatedRecentPapers = currentState.recentPapers.map((paper) {
        if (paper.id == paperId) {
          return PaperEntity(
            id: paper.id,
            title: paper.title,
            abstract: paper.abstract,
            publishedAt: paper.publishedAt,
            authors: paper.authors,
            categories: paper.categories,
            isSaved: isSaved,
            preprint: paper.preprint,
          );
        }
        return paper;
      }).toList();

      final updatedRecommendations = currentState.recommendations.map((paper) {
        if (paper.id == paperId) {
          return PaperEntity(
            id: paper.id,
            title: paper.title,
            abstract: paper.abstract,
            publishedAt: paper.publishedAt,
            authors: paper.authors,
            categories: paper.categories,
            isSaved: isSaved,
            preprint: paper.preprint,
          );
        }
        return paper;
      }).toList();

      emit(
        currentState.copyWith(
          recentPapers: updatedRecentPapers,
          recommendations: updatedRecommendations,
        ),
      );
    }
  }
}

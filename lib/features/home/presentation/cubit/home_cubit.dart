import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/no_params.dart';
import '../../../users/domain/entities/user.dart';
import '../../../users/domain/usecases/get_current_user_usecase.dart';
import '../../domain/entities/paper_entity.dart';
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
  int _recentPapersPage = 1;

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

    // Reset page number for recent papers
    _recentPapersPage = 1;

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
    _recentPapersPage = 1;

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
    if (currentState is! HomePapersLoaded && currentState is! HomePapersUpdated)
      return;

    late bool hasReachedMax;
    late bool isLoading;
    late HomePapersLoaded baseState;

    if (currentState is HomePapersLoaded) {
      hasReachedMax = currentState.hasReachedMaxRecommendations;
      isLoading = currentState.isLoadingMoreRecommendations;
      baseState = currentState;
    } else if (currentState is HomePapersUpdated) {
      hasReachedMax = currentState.hasReachedMaxRecommendations;
      isLoading = currentState.isLoadingMoreRecommendations;
      baseState = HomePapersLoaded(
        recentPapers: currentState.recentPapers,
        recommendations: currentState.recommendations,
        isLoadingMoreRecent: currentState.isLoadingMoreRecent,
        isLoadingMoreRecommendations: currentState.isLoadingMoreRecommendations,
        hasReachedMaxRecent: currentState.hasReachedMaxRecent,
        hasReachedMaxRecommendations: currentState.hasReachedMaxRecommendations,
      );
    } else {
      return;
    }

    if (hasReachedMax) return;
    if (isLoading) return;

    emit(baseState.copyWith(isLoadingMoreRecommendations: true));

    _recommendationPage++;

    final result = await getRecommendationsUseCase(
      GetRecommendationsParams(page: _recommendationPage, limit: limit),
    );

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(baseState.copyWith(isLoadingMoreRecommendations: false));
      },
      (newPapers) {
        if (isClosed) return;
        final allPapers = List.of(baseState.recommendations)..addAll(newPapers);

        emit(
          baseState.copyWith(
            recommendations: allPapers,
            isLoadingMoreRecommendations: false,
            hasReachedMaxRecommendations: newPapers.length < limit,
          ),
        );
      },
    );
  }

  Future<void> loadMoreRecentPapers({String? category, int limit = 10}) async {
    final currentState = state;

    // Handle multiple state types
    late List<PaperEntity> currentPapers;
    late bool isLoading;
    late bool hasReachedMax;

    if (currentState is HomeRecentPapersLoaded) {
      currentPapers = currentState.recentPapers;
      isLoading = currentState.isLoadingMoreRecent;
      hasReachedMax = currentState.hasReachedMaxRecent;
    } else if (currentState is HomePapersLoaded) {
      currentPapers = currentState.recentPapers;
      isLoading = currentState.isLoadingMoreRecent;
      hasReachedMax = currentState.hasReachedMaxRecent;
    } else if (currentState is HomePapersUpdated) {
      currentPapers = currentState.recentPapers;
      isLoading = currentState.isLoadingMoreRecent;
      hasReachedMax = currentState.hasReachedMaxRecent;
    } else {
      return;
    }

    if (hasReachedMax) return;
    if (isLoading) return;

    // Emit loading state
    if (currentState is HomeRecentPapersLoaded) {
      emit(currentState.copyWith(isLoadingMoreRecent: true));
    } else if (currentState is HomePapersLoaded) {
      emit(currentState.copyWith(isLoadingMoreRecent: true));
    } else if (currentState is HomePapersUpdated) {
      emit(currentState.copyWith(isLoadingMoreRecent: true));
    }

    _recentPapersPage++;

    final result = await getRecentPapersUseCase(
      GetRecentPapersParams(
        category: category,
        page: _recentPapersPage,
        limit: limit,
      ),
    );

    result.fold(
      (failure) {
        if (isClosed) return;
        if (currentState is HomeRecentPapersLoaded) {
          emit(currentState.copyWith(isLoadingMoreRecent: false));
        } else if (currentState is HomePapersLoaded) {
          emit(currentState.copyWith(isLoadingMoreRecent: false));
        } else if (currentState is HomePapersUpdated) {
          emit(currentState.copyWith(isLoadingMoreRecent: false));
        }
      },
      (newPapers) {
        if (isClosed) return;
        final allPapers = List.of(currentPapers)..addAll(newPapers);

        if (currentState is HomeRecentPapersLoaded) {
          emit(
            currentState.copyWith(
              recentPapers: allPapers,
              isLoadingMoreRecent: false,
              hasReachedMaxRecent: newPapers.length < limit,
            ),
          );
        } else if (currentState is HomePapersLoaded) {
          emit(
            currentState.copyWith(
              recentPapers: allPapers,
              isLoadingMoreRecent: false,
              hasReachedMaxRecent: newPapers.length < limit,
            ),
          );
        } else if (currentState is HomePapersUpdated) {
          emit(
            currentState.copyWith(
              recentPapers: allPapers,
              isLoadingMoreRecent: false,
              hasReachedMaxRecent: newPapers.length < limit,
            ),
          );
        }
      },
    );
  }

  Future<void> savePaper(String paperId) async {
    final result = await savePaperUseCase(paperId);

    result.fold((failure) {}, (_) {
      // Update paper isSaved status in state
      _updatePaperSavedStatus(paperId, true);
    });
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

  void updatePaperSavedStatus(String paperId, bool isSaved) {
    _updatePaperSavedStatus(paperId, isSaved);
  }

  void _updatePaperSavedStatus(String paperId, bool isSaved) {
    final currentState = state;

    if (currentState is HomePapersLoaded) {
      final updatedRecentPapers = currentState.recentPapers.map((paper) {
        if (paper.id == paperId) {
          return paper.copyWith(isSaved: isSaved);
        }
        return paper;
      }).toList();

      final updatedRecommendations = currentState.recommendations.map((paper) {
        if (paper.id == paperId) {
          return paper.copyWith(isSaved: isSaved);
        }
        return paper;
      }).toList();

      // Emit HomePapersUpdated state with updated papers
      emit(
        HomePapersUpdated(
          recentPapers: updatedRecentPapers,
          recommendations: updatedRecommendations,
          isLoadingMoreRecent: currentState.isLoadingMoreRecent,
          isLoadingMoreRecommendations:
              currentState.isLoadingMoreRecommendations,
          hasReachedMaxRecent: currentState.hasReachedMaxRecent,
          hasReachedMaxRecommendations:
              currentState.hasReachedMaxRecommendations,
        ),
      );
    } else if (currentState is HomeRecentPapersLoaded) {
      final updatedRecentPapers = currentState.recentPapers.map((paper) {
        if (paper.id == paperId) {
          return paper.copyWith(isSaved: isSaved);
        }
        return paper;
      }).toList();

      emit(currentState.copyWith(recentPapers: updatedRecentPapers));
    } else if (currentState is HomeRecommendationsLoaded) {
      final updatedRecommendations = currentState.recommendations.map((paper) {
        if (paper.id == paperId) {
          return paper.copyWith(isSaved: isSaved);
        }
        return paper;
      }).toList();

      emit(currentState.copyWith(recommendations: updatedRecommendations));
    }
  }
}

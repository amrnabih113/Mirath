import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/network_manager.dart';
import '../../../../core/usecases/no_params.dart';
import '../../../users/domain/entities/user.dart' hide Interest;
import '../../../users/domain/usecases/get_current_user_usecase.dart';
import '../../domain/entities/paper_entity.dart';
import '../../domain/usecases/home_cache_usecases.dart';
import '../../domain/usecases/get_paper_categories_usecase.dart';
import '../../domain/usecases/get_recent_papers_usecase.dart';
import '../../domain/usecases/get_recommendations_usecase.dart';
import '../../domain/usecases/save_paper_usecase.dart';
import '../../domain/usecases/unsave_paper_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeCacheUseCases homeCacheUseCases;
  final GetRecentPapersUseCase getRecentPapersUseCase;
  final GetRecommendationsUseCase getRecommendationsUseCase;
  final GetCurrentUserUsecase getCurrentUserUsecase;
  final GetPaperCategoriesUseCase getPaperCategoriesUseCase;
  final SavePaperUseCase savePaperUseCase;
  final UnsavePaperUseCase unsavePaperUseCase;

  HomeCubit({
    required this.homeCacheUseCases,
    required this.getRecentPapersUseCase,
    required this.getRecommendationsUseCase,
    required this.getCurrentUserUsecase,
    required this.getPaperCategoriesUseCase,
    required this.savePaperUseCase,
    required this.unsavePaperUseCase,
  }) : super(const HomeInitial());

  // Track current page for pagination
  int _recommendationPage = 1;
  int _recentPapersPage = 1;
  String? _selectedCategory;

  Future<User?> loadCurrentUser() async {
    final result = await getCurrentUserUsecase(NoParams());

    return result.fold((failure) => null, (user) => user);
  }

  Future<void> getRecentPapers({
    String? category,
    int page = 1,
    int limit = 10,
    bool forceRefresh = false,
  }) async {
    // Reset page number for recent papers
    _recentPapersPage = 1;
    // Treat empty string as null (for "All" filter)
    final categoryToUse = category?.isEmpty == true ? null : category;
    if (categoryToUse != null) {
      _selectedCategory = categoryToUse;
    } else {
      _selectedCategory = null;
    }

    final cachedPapers = await homeCacheUseCases.getCachedRecentPapers(
      category: categoryToUse,
      page: page,
      limit: limit,
    );

    if (cachedPapers.isNotEmpty) {
      emit(HomeRecentPapersLoaded(recentPapers: cachedPapers));
    } else {
      emit(const HomeLoading());
    }

    if (cachedPapers.isNotEmpty && !forceRefresh) {
      return;
    }

    final result = await getRecentPapersUseCase(
      GetRecentPapersParams(category: categoryToUse, page: page, limit: limit),
    );

    result.fold(
      (failure) {
        if (cachedPapers.isEmpty) {
          emit(HomeError(message: failure.message));
        }
      },
      (papers) {
        homeCacheUseCases.cacheRecentPapers(
          papers,
          category: categoryToUse,
          page: page,
          limit: limit,
        );
        emit(HomeRecentPapersLoaded(recentPapers: papers));
      },
    );
  }

  Future<void> getRecommendations({
    int page = 1,
    int limit = 5,
    bool forceRefresh = false,
  }) async {
    final cachedRecommendations = await homeCacheUseCases
        .getCachedRecommendations(page: page, limit: limit);

    if (cachedRecommendations.isNotEmpty) {
      emit(HomeRecommendationsLoaded(recommendations: cachedRecommendations));
    } else {
      emit(const HomeLoading());
    }

    if (cachedRecommendations.isNotEmpty && !forceRefresh) {
      return;
    }

    final result = await getRecommendationsUseCase(
      GetRecommendationsParams(page: page, limit: limit),
    );

    result.fold(
      (failure) {
        if (cachedRecommendations.isEmpty) {
          emit(HomeError(message: failure.message));
        }
      },
      (papers) {
        homeCacheUseCases.cacheRecommendations(
          papers,
          page: page,
          limit: limit,
        );
        emit(HomeRecommendationsLoaded(recommendations: papers));
      },
    );
  }

  Future<void> loadAllPapers({
    String? category,
    int recentLimit = 10,
    int recommendationLimit = 5,
    bool forceRefresh = false,
  }) async {
    if (forceRefresh && !await NetworkManager.instance.isConnected) {
      return;
    }

    _recommendationPage = 1;
    _recentPapersPage = 1;
    if (category != null) {
      _selectedCategory = category;
    }

    final categoryToUse = category?.isEmpty == true ? null : category;
    final cachedRecentPapers = await homeCacheUseCases.getCachedRecentPapers(
      category: categoryToUse,
      page: 1,
      limit: recentLimit,
    );
    final cachedRecommendations = await homeCacheUseCases
        .getCachedRecommendations(page: 1, limit: recommendationLimit);
    final cachedCategories = await homeCacheUseCases.getCachedPaperCategories(
      page: 1,
      limit: 20,
    );

    if (cachedRecentPapers.isNotEmpty ||
        cachedRecommendations.isNotEmpty ||
        cachedCategories.isNotEmpty) {
      emit(
        HomePapersLoaded(
          recentPapers: cachedRecentPapers,
          recommendations: cachedRecommendations,
          categories: cachedCategories,
          selectedCategory: _selectedCategory,
          hasReachedMaxRecommendations:
              cachedRecommendations.length < recommendationLimit,
        ),
      );
    } else {
      emit(const HomeLoading());
    }

    // Load paper categories
    final categoriesResult = await getPaperCategoriesUseCase(
      GetPaperCategoriesParams(page: 1, limit: 20),
    );

    // Load recent papers
    final recentResult = await getRecentPapersUseCase(
      GetRecentPapersParams(
        category: categoryToUse,
        page: 1,
        limit: recentLimit,
      ),
    );

    if ((cachedRecentPapers.isNotEmpty ||
            cachedRecommendations.isNotEmpty ||
            cachedCategories.isNotEmpty) &&
        !forceRefresh) {
      return;
    }

    // Load recommendations
    final recommendationResult = await getRecommendationsUseCase(
      GetRecommendationsParams(
        page: _recommendationPage,
        limit: recommendationLimit,
      ),
    );

    recentResult.fold(
      (failure) {
        if (cachedRecentPapers.isEmpty && cachedRecommendations.isEmpty) {
          emit(HomeError(message: failure.message));
        }
      },
      (recentPapers) {
        recommendationResult.fold(
          (failure) {
            if (cachedRecentPapers.isEmpty && cachedRecommendations.isEmpty) {
              emit(HomeError(message: failure.message));
            }
          },
          (recommendations) {
            categoriesResult.fold(
              (failure) {
                // Continue without categories if fetch fails
                emit(
                  HomePapersLoaded(
                    recentPapers: recentPapers,
                    recommendations: recommendations,
                    categories: [],
                    selectedCategory: _selectedCategory,
                    hasReachedMaxRecommendations:
                        recommendations.length < recommendationLimit,
                  ),
                );
              },
              (categories) {
                homeCacheUseCases.cacheRecentPapers(
                  recentPapers,
                  category: categoryToUse,
                  page: 1,
                  limit: recentLimit,
                );
                homeCacheUseCases.cacheRecommendations(
                  recommendations,
                  page: 1,
                  limit: recommendationLimit,
                );
                homeCacheUseCases.cachePaperCategories(
                  categories,
                  page: 1,
                  limit: 20,
                );
                emit(
                  HomePapersLoaded(
                    recentPapers: recentPapers,
                    recommendations: recommendations,
                    categories: categories,
                    selectedCategory: _selectedCategory,
                    hasReachedMaxRecommendations:
                        recommendations.length < recommendationLimit,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> filterPapersByInterest(String interestName) async {
    final currentState = state;

    // Get current categories and papers
    late List<String> categories;

    if (currentState is HomePapersLoaded) {
      categories = currentState.categories;
    } else if (currentState is HomePapersUpdated) {
      categories = currentState.categories;
    } else {
      return;
    }

    // Update selected category (empty string for "All" means no filter)
    _selectedCategory = interestName.isEmpty ? null : interestName;
    _recentPapersPage = 1;

    emit(const HomeLoading());

    final result = await getRecentPapersUseCase(
      GetRecentPapersParams(
        category: interestName.isEmpty ? null : interestName,
        page: 1,
        limit: 10,
      ),
    );

    result.fold(
      (failure) {
        emit(
          HomePapersLoaded(
            recentPapers: [],
            recommendations: currentState is HomePapersLoaded
                ? currentState.recommendations
                : (currentState as HomePapersUpdated).recommendations,
            categories: categories,
            selectedCategory: _selectedCategory,
            hasReachedMaxRecent: true,
          ),
        );
      },
      (newPapers) {
        if (isClosed) return;
        emit(
          HomePapersLoaded(
            recentPapers: newPapers,
            recommendations: currentState is HomePapersLoaded
                ? currentState.recommendations
                : (currentState as HomePapersUpdated).recommendations,
            categories: categories,
            selectedCategory: _selectedCategory,
          ),
        );
      },
    );
  }

  Future<void> loadMoreRecommendations({int limit = 5}) async {
    final currentState = state;
    if (currentState is! HomePapersLoaded &&
        currentState is! HomePapersUpdated) {
      return;
    }

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
        categories: currentState.categories,
        selectedCategory: currentState.selectedCategory,
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

    // Treat empty string as null (for "All" filter)
    final categoryToUse = category?.isEmpty == true ? null : category;

    final result = await getRecentPapersUseCase(
      GetRecentPapersParams(
        category: categoryToUse,
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
        homeCacheUseCases.cacheRecentPapers(
          allPapers,
          category: categoryToUse,
          page: 1,
          limit: limit,
        );

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
      homeCacheUseCases.updatePaperSavedInCache(paperId, true);
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
        homeCacheUseCases.updatePaperSavedInCache(paperId, false);
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
          categories: currentState.categories,
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

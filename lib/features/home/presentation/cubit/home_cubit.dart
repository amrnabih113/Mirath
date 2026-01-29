import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirath/features/home/domain/usecases/get_recent_papers_usecase.dart';
import 'package:mirath/features/home/domain/usecases/get_recommendations_usecase.dart';
import 'package:mirath/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetRecentPapersUseCase getRecentPapersUseCase;
  final GetRecommendationsUseCase getRecommendationsUseCase;

  HomeCubit({
    required this.getRecentPapersUseCase,
    required this.getRecommendationsUseCase,
  }) : super(const HomeInitial());
  int _recentPage = 1;
  int _recommendationPage = 1;

  bool _hasReachedMaxRecent = false;
  bool _hasReachedMaxRecommendations = false;

  Future<void> getRecentPapers({
    String? category,
    int page = 1,
    int limit = 10,
  }) async {
    emit(const HomeLoading());
    _recentPage = 1;
    _hasReachedMaxRecent = false;

    final result = await getRecentPapersUseCase(
      GetRecentPapersParams(
        category: category,
        page: _recentPage,
        limit: limit,
      ),
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

    _recommendationPage = 1;
    _hasReachedMaxRecommendations = false;
    final result = await getRecommendationsUseCase(
      GetRecommendationsParams(page: _recommendationPage, limit: limit),
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

    _recentPage = 1;
    _recommendationPage = 1;
    _hasReachedMaxRecent = false;
    _hasReachedMaxRecommendations = false;

    final recentResult = await getRecentPapersUseCase(
      GetRecentPapersParams(
        category: category,
        page: _recentPage,
        limit: recentLimit,
      ),
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
              ),
            );
          },
        );
      },
    );
  }

  Future<void> loadMoreRecentPapers({String? category, int limit = 10}) async {
    if (state is! HomePapersLoaded || _hasReachedMaxRecent) return;

    final currentState = state as HomePapersLoaded;

    emit(currentState.copyWith(isLoadingMoreRecent: true));

    _recentPage++;

    final result = await getRecentPapersUseCase(
      GetRecentPapersParams(
        category: category,
        page: _recentPage,
        limit: limit,
      ),
    );

    result.fold(
      (failure) {
        emit(currentState.copyWith(isLoadingMoreRecent: false));
      },
      (newPapers) {
        final allPapers = List.of(currentState.recentPapers)..addAll(newPapers);

        _hasReachedMaxRecent = newPapers.isEmpty;

        emit(
          currentState.copyWith(
            recentPapers: allPapers,
            isLoadingMoreRecent: false,
            hasReachedMaxRecent: _hasReachedMaxRecent,
          ),
        );
      },
    );
  }

  Future<void> loadMoreRecommendations({int limit = 5}) async {
    if (state is! HomePapersLoaded || _hasReachedMaxRecommendations) return;

    final currentState = state as HomePapersLoaded;

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

        _hasReachedMaxRecommendations = newPapers.isEmpty;

        emit(
          currentState.copyWith(
            recommendations: allPapers,
            isLoadingMoreRecommendations: false,
            hasReachedMaxRecommendations: _hasReachedMaxRecommendations,
          ),
        );
      },
    );
  }
}

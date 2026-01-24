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
    int page = 1,
    int recentLimit = 10,
    int recommendationLimit = 5,
  }) async {
    emit(const HomeLoading());

    final recentResult = await getRecentPapersUseCase(
      GetRecentPapersParams(category: category, page: page, limit: recentLimit),
    );

    final recommendationResult = await getRecommendationsUseCase(
      GetRecommendationsParams(page: page, limit: recommendationLimit),
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
}

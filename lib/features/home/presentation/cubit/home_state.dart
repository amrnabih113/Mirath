import 'package:equatable/equatable.dart';
import 'package:mirath/features/home/domain/entities/paper_entity.dart';
import 'package:mirath/features/users/domain/entities/user.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeRecentPapersLoaded extends HomeState {
  final List<PaperEntity> recentPapers;
  final bool isLoadingMoreRecent;
  final bool hasReachedMaxRecent;

  const HomeRecentPapersLoaded({
    required this.recentPapers,
    this.isLoadingMoreRecent = false,
    this.hasReachedMaxRecent = false,
  });
  HomeRecentPapersLoaded copyWith({
    List<PaperEntity>? recentPapers,
    bool? isLoadingMoreRecent,
    bool? hasReachedMaxRecent,
  }) {
    return HomeRecentPapersLoaded(
      recentPapers: recentPapers ?? this.recentPapers,
      isLoadingMoreRecent: isLoadingMoreRecent ?? this.isLoadingMoreRecent,

      hasReachedMaxRecent: hasReachedMaxRecent ?? this.hasReachedMaxRecent,
    );
  }

  @override
  List<Object?> get props => [
    recentPapers,
    isLoadingMoreRecent,
    hasReachedMaxRecent,
  ];
}

class HomeRecommendationsLoaded extends HomeState {
  final List<PaperEntity> recommendations;
  final bool isLoadingMoreRecommendations;
  final bool hasReachedMaxRecommendations;

  const HomeRecommendationsLoaded({
    required this.recommendations,
    this.isLoadingMoreRecommendations = false,
    this.hasReachedMaxRecommendations = false,
  });
  HomeRecommendationsLoaded copyWith({
    List<PaperEntity>? recommendations,

    bool? isLoadingMoreRecommendations,

    bool? hasReachedMaxRecommendations,
  }) {
    return HomeRecommendationsLoaded(
      recommendations: recommendations ?? this.recommendations,
      isLoadingMoreRecommendations:
          isLoadingMoreRecommendations ?? this.isLoadingMoreRecommendations,
      hasReachedMaxRecommendations:
          hasReachedMaxRecommendations ?? this.hasReachedMaxRecommendations,
    );
  }

  @override
  List<Object?> get props => [
    recommendations,
    isLoadingMoreRecommendations,
    hasReachedMaxRecommendations,
  ];
}

class HomePapersLoaded extends HomeState {
  final List<PaperEntity> recentPapers;
  final List<PaperEntity> recommendations;
  final bool isLoadingMoreRecent;
  final bool isLoadingMoreRecommendations;
  final bool hasReachedMaxRecent;
  final bool hasReachedMaxRecommendations;

  const HomePapersLoaded({
    required this.recentPapers,
    required this.recommendations,
   
    this.isLoadingMoreRecent = false,
    this.isLoadingMoreRecommendations = false,
    this.hasReachedMaxRecent = false,
    this.hasReachedMaxRecommendations = false,
  });

  HomePapersLoaded copyWith({
    List<PaperEntity>? recentPapers,
    List<PaperEntity>? recommendations,
    User? currentUser,
    bool? isLoadingMoreRecent,
    bool? isLoadingMoreRecommendations,
    bool? hasReachedMaxRecent,
    bool? hasReachedMaxRecommendations,
  }) {
    return HomePapersLoaded(
      recentPapers: recentPapers ?? this.recentPapers,
      recommendations: recommendations ?? this.recommendations,
      isLoadingMoreRecent: isLoadingMoreRecent ?? this.isLoadingMoreRecent,
      isLoadingMoreRecommendations:
          isLoadingMoreRecommendations ?? this.isLoadingMoreRecommendations,
      hasReachedMaxRecent: hasReachedMaxRecent ?? this.hasReachedMaxRecent,
      hasReachedMaxRecommendations:
          hasReachedMaxRecommendations ?? this.hasReachedMaxRecommendations,
    );
  }

  @override
  List<Object?> get props => [
    recentPapers,
    recommendations,
    isLoadingMoreRecent,
    isLoadingMoreRecommendations,
    hasReachedMaxRecent,
    hasReachedMaxRecommendations,
  ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';
import 'package:mirath/features/home/domain/entities/paper_entity.dart';

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

  const HomeRecentPapersLoaded({required this.recentPapers});

  @override
  List<Object?> get props => [recentPapers];
}

class HomeRecommendationsLoaded extends HomeState {
  final List<PaperEntity> recommendations;

  const HomeRecommendationsLoaded({required this.recommendations});

  @override
  List<Object?> get props => [recommendations];
}

class HomePapersLoaded extends HomeState {
  final List<PaperEntity> recentPapers;
  final List<PaperEntity> recommendations;

  const HomePapersLoaded({
    required this.recentPapers,
    required this.recommendations,
  });

  @override
  List<Object?> get props => [recentPapers, recommendations];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}

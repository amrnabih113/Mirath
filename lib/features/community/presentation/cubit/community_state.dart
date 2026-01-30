import 'package:equatable/equatable.dart';
import 'package:mirath/features/community/domain/entities/discussion.dart';

abstract class CommunityState extends Equatable {
  const CommunityState();

  @override
  List<Object?> get props => [];
}

class CommunityInitial extends CommunityState {
  const CommunityInitial();
}

class CommunityLoading extends CommunityState {
  const CommunityLoading();
}

class CommunityDiscussionsLoaded extends CommunityState {
  final List<Discussion> discussions;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final String currentSort;
  final String? currentTopicId;
  final double scrollPosition;

  const CommunityDiscussionsLoaded({
    required this.discussions,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.currentSort = 'new',
    this.currentTopicId,
    this.scrollPosition = 0.0,
  });

  CommunityDiscussionsLoaded copyWith({
    List<Discussion>? discussions,
    bool? isLoadingMore,
    bool? hasReachedMax,
    String? currentSort,
    String? currentTopicId,
    double? scrollPosition,
  }) {
    return CommunityDiscussionsLoaded(
      discussions: discussions ?? this.discussions,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentSort: currentSort ?? this.currentSort,
      currentTopicId: currentTopicId ?? this.currentTopicId,
      scrollPosition: scrollPosition ?? this.scrollPosition,
    );
  }

  @override
  List<Object?> get props => [
    discussions,
    isLoadingMore,
    hasReachedMax,
    currentSort,
    currentTopicId,
    scrollPosition,
  ];
}

class CommunityError extends CommunityState {
  final String message;

  const CommunityError({required this.message});

  @override
  List<Object?> get props => [message];
}

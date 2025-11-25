part of 'onboarding_cubit.dart';

sealed class OnboardingState extends Equatable {
  final int currentPage;
  final int totalPages;

  const OnboardingState({required this.currentPage, required this.totalPages});

  bool get isFirstPage => currentPage == 0;
  bool get isLastPage => currentPage == totalPages - 1;

  @override
  List<Object> get props => [currentPage, totalPages];
}

final class OnboardingInitial extends OnboardingState {
  const OnboardingInitial({required super.totalPages}) : super(currentPage: 0);
}

final class OnboardingPageChanged extends OnboardingState {
  const OnboardingPageChanged({
    required super.currentPage,
    required super.totalPages,
  });
}

final class OnboardingCompleted extends OnboardingState {
  const OnboardingCompleted({required super.totalPages})
    : super(currentPage: 0);
}

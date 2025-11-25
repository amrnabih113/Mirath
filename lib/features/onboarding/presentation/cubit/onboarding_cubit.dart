import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({required int totalPages})
    : super(OnboardingInitial(totalPages: totalPages));

  void nextPage() {
    if (state.isLastPage) {
      completeOnboarding();
    } else {
      emit(
        OnboardingPageChanged(
          currentPage: state.currentPage + 1,
          totalPages: state.totalPages,
        ),
      );
    }
  }

  void goToPage(int page) {
    if (page >= 0 && page < state.totalPages) {
      emit(
        OnboardingPageChanged(currentPage: page, totalPages: state.totalPages),
      );
    }
  }

  void skipOnboarding() {
    completeOnboarding();
  }

  void completeOnboarding() {
    emit(OnboardingCompleted(totalPages: state.totalPages));
  }
}

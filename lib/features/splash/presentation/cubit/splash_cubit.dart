import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mirath/core/usecases/no_params.dart';
import '../../../auth/domain/usecases/is_signed_in_usecase.dart';
import '../../../auth/domain/usecases/is_verified_usecase.dart';
import '../../../../core/utils/my_logger.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final IsSignedInUseCase isSignedInUseCase;
  final IsVerifiedUseCase isVerifiedUseCase;

  SplashCubit({
    required this.isSignedInUseCase,
    required this.isVerifiedUseCase,
  }) : super(SplashInitial());

  Future<void> checkAuthStatus() async {
    MyLogger.info('[SplashCubit] Starting auth status check');

   
    await Future.delayed(const Duration(seconds: 2));

    // Check if user is signed in
    MyLogger.info('[SplashCubit] Checking if user is signed in');
    final isSignedInResult = await isSignedInUseCase(NoParams());

    isSignedInResult.fold(
      (failure) {
        // If there's an error, navigate to onboarding
        MyLogger.error(
          '[SplashCubit] Error checking sign in status: ${failure.message}',
        );
        MyLogger.info('[SplashCubit] Navigating to Onboarding due to error');
        emit(SplashNavigateToOnboarding());
      },
      (isSignedIn) async {
        MyLogger.info('[SplashCubit] Is signed in: $isSignedIn');

        if (!isSignedIn) {
          // User is not signed in, navigate to onboarding
          MyLogger.info(
            '[SplashCubit] Navigating to Onboarding - user not signed in',
          );
          emit(SplashNavigateToOnboarding());
          return;
        }

        // User is signed in, check if verified
        MyLogger.info(
          '[SplashCubit] User is signed in, checking verification status',
        );
        final isVerifiedResult = await isVerifiedUseCase(NoParams());

        isVerifiedResult.fold(
          (failure) {
            // If there's an error checking verification, navigate to sign in
            MyLogger.error(
              '[SplashCubit] Error checking verification: ${failure.message}',
            );
            MyLogger.info('[SplashCubit] Navigating to SignIn due to error');
            emit(SplashNavigateToSignIn());
          },
          (isVerified) {
            MyLogger.info('[SplashCubit] Is verified: $isVerified');

            if (!isVerified) {
              // User is signed in but not verified
              MyLogger.info(
                '[SplashCubit] Navigating to VerifyAccount - user not verified',
              );
              emit(SplashNavigateToVerifyAccount());
            } else {
              // User is signed in and verified
              MyLogger.info(
                '[SplashCubit] Navigating to Home - user authenticated',
              );
              emit(SplashNavigateToHome());
            }
          },
        );
      },
    );
  }
}

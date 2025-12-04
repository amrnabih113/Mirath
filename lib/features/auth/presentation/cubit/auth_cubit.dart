import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/no_params.dart';
import '../../../../core/utils/my_logger.dart';
import '../../domain/entities/signin_data.dart';
import '../../domain/entities/signup_data.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/forget_password_usecase.dart';
import '../../domain/usecases/is_signed_in_usecase.dart';
import '../../domain/usecases/is_verified_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/send_verification_otp_usecase.dart';
import '../../domain/usecases/set_up_profile_usecase.dart';
import '../../domain/usecases/signin_usecase.dart';
import '../../domain/usecases/signin_with_apple_usecase.dart';
import '../../domain/usecases/signin_with_google_usecase.dart';
import '../../domain/usecases/signout_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/verify_account_usecase.dart';
import '../../domain/usecases/verify_reset_password_otp_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final IsSignedInUseCase isSignedInUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignInWithAppleUseCase signInWithAppleUseCase;
  final SendVerificationOTPUseCase sendVerificationOTPUseCase;
  final VerifyOTPUseCase verifyOTPUseCase;
  final ForgetPasswordUseCase forgetPasswordUseCase;
  final VerifyResetPasswordOTPUseCase verifyResetPasswordOTPUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final IsVerifiedUseCase isVerifiedUseCase;
  final SetUpProfileUseCase setUpProfileUseCase;

  AuthCubit({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.isSignedInUseCase,
    required this.signInWithGoogleUseCase,
    required this.signInWithAppleUseCase,
    required this.sendVerificationOTPUseCase,
    required this.verifyOTPUseCase,
    required this.forgetPasswordUseCase,
    required this.verifyResetPasswordOTPUseCase,
    required this.resetPasswordUseCase,
    required this.isVerifiedUseCase,
    required this.setUpProfileUseCase,
  }) : super(AuthState.initial());

  // ===================== SIGN IN =====================
  Future<void> signIn(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading, clearMessage: true));

    final result = await signInUseCase(
      SigninData(email: email, password: password),
    );

    await result.fold(
      (failure) async => emit(
        state.copyWith(status: AuthStatus.error, message: failure.message),
      ),
      (_) async {
        // Check if user is verified after sign in
        final verifiedResult = await isVerifiedUseCase(const NoParams());
        verifiedResult.fold(
          (failure) => emit(
            state.copyWith(status: AuthStatus.error, message: failure.message),
          ),
          (isVerified) => emit(
            state.copyWith(
              status: isVerified
                  ? AuthStatus.authenticated
                  : AuthStatus.unverified,
              message: isVerified ? null : "Please verify your account",
            ),
          ),
        );
      },
    );
  }

  // ===================== SIGN UP =====================
  Future<void> signUp(String email, String password, String username) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await signUpUseCase(
      SignupData(email: email, password: password, username: username),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, message: failure.message),
      ),
      (_) => emit(
        state.copyWith(
          status: AuthStatus.unverified,
          message: "Account created. Please verify your email.",
        ),
      ),
    );
  }

  // ====================== SET UP PROFILE =====================
  Future<void> setUpProfile(UserProfile userProfile) async {
    emit(state.copyWith(status: AuthStatus.loading, clearMessage: true));

    final result = await setUpProfileUseCase(userProfile);

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, message: failure.message),
      ),
      (_) => emit(
        state.copyWith(
          status: AuthStatus.success,
          message: "Profile set up successfully",
        ),
      ),
    );
  }

  // ===================== CHECK IF VERIFIED =====================
  Future<void> checkIfVerified() async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await isVerifiedUseCase(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, message: failure.message),
      ),
      (isVerified) {
        if (isVerified) {
          emit(state.copyWith(status: AuthStatus.authenticated));
        } else {
          emit(state.copyWith(status: AuthStatus.unverified));
        }
      },
    );
  }

  // ===================== SIGN OUT =====================
  Future<void> signOut() async {
    emit(state.copyWith(status: AuthStatus.loading, clearMessage: true));
    final result = await signOutUseCase(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, message: failure.message),
      ),
      (_) => emit(
        state.copyWith(status: AuthStatus.unauthenticated, clearMessage: true),
      ),
    );
  }

  // ===================== CHECK AUTH STATUS =====================
  Future<void> checkAuthStatus() async {
    MyLogger.info('[AuthCubit] Starting auth status check...');

    // Small delay to ensure the app is fully initialized
    await Future.delayed(const Duration(milliseconds: 100));

    final result = await isSignedInUseCase(const NoParams());

    await result.fold(
      (_) async {
        MyLogger.info('[AuthCubit] Not signed in → unauthenticated');
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            clearMessage: true,
          ),
        );
      },
      (loggedIn) async {
        if (!loggedIn) {
          MyLogger.info('[AuthCubit] User not logged in → unauthenticated');
          emit(
            state.copyWith(
              status: AuthStatus.unauthenticated,
              clearMessage: true,
            ),
          );
        } else {
          MyLogger.info('[AuthCubit] User logged in, checking verification...');
          // Check verification status
          final verifiedResult = await isVerifiedUseCase(const NoParams());
          verifiedResult.fold(
            (_) {
              MyLogger.info(
                '[AuthCubit] Verification check failed → authenticated',
              );
              emit(state.copyWith(status: AuthStatus.authenticated));
            },
            (isVerified) {
              MyLogger.info(
                '[AuthCubit] Verification status: $isVerified → ${isVerified ? "authenticated" : "unverified"}',
              );
              emit(
                state.copyWith(
                  status: isVerified
                      ? AuthStatus.authenticated
                      : AuthStatus.unverified,
                ),
              );
            },
          );
        }
      },
    );

    MyLogger.info('[AuthCubit] Auth status check completed: ${state.status}');
  }

  // ===================== SIGN IN WITH GOOGLE =====================
  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.loading, clearMessage: true));
    final result = await signInWithGoogleUseCase(const NoParams());

    await result.fold(
      (f) async =>
          emit(state.copyWith(status: AuthStatus.error, message: f.message)),
      (_) async {
        // Check verification status
        final verifiedResult = await isVerifiedUseCase(const NoParams());
        verifiedResult.fold(
          (failure) => emit(
            state.copyWith(status: AuthStatus.error, message: failure.message),
          ),
          (isVerified) => emit(
            state.copyWith(
              status: isVerified
                  ? AuthStatus.authenticated
                  : AuthStatus.unverified,
              message: isVerified ? null : "Please verify your account",
            ),
          ),
        );
      },
    );
  }

  // ===================== SIGN IN WITH APPLE =====================
  Future<void> signInWithApple() async {
    emit(state.copyWith(status: AuthStatus.loading, clearMessage: true));
    final result = await signInWithAppleUseCase(const NoParams());

    await result.fold(
      (f) async =>
          emit(state.copyWith(status: AuthStatus.error, message: f.message)),
      (_) async {
        // Check verification status
        final verifiedResult = await isVerifiedUseCase(const NoParams());
        verifiedResult.fold(
          (failure) => emit(
            state.copyWith(status: AuthStatus.error, message: failure.message),
          ),
          (isVerified) => emit(
            state.copyWith(
              status: isVerified
                  ? AuthStatus.authenticated
                  : AuthStatus.unverified,
              message: isVerified ? null : "Please verify your account",
            ),
          ),
        );
      },
    );
  }

  // ===================== SEND VERIFICATION OTP =====================
  Future<void> sendVerificationOTP() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await sendVerificationOTPUseCase(const NoParams());

    result.fold(
      (f) => emit(state.copyWith(status: AuthStatus.error, message: f.message)),
      (_) => emit(
        state.copyWith(
          status: AuthStatus.otpSent,
          message: "OTP sent to your email",
        ),
      ),
    );
  }

  // ===================== VERIFY ACCOUNT OTP =====================
  Future<void> verifyAccount(String otp) async {
    emit(state.copyWith(status: AuthStatus.loading, clearMessage: true));
    final result = await verifyOTPUseCase(otp);

    result.fold(
      (f) => emit(state.copyWith(status: AuthStatus.error, message: f.message)),
      (_) => emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          message: "Account verified successfully",
        ),
      ),
    );
  }

  // ===================== FORGET PASSWORD =====================
  Future<void> forgetPassword({required String email}) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await forgetPasswordUseCase(email);

    result.fold(
      (f) => emit(state.copyWith(status: AuthStatus.error, message: f.message)),
      (_) => emit(
        state.copyWith(
          status: AuthStatus.resetPasswordRequested,
          message: "Password reset code sent to your email",
        ),
      ),
    );
  }

  // ===================== VERIFY RESET PASSWORD OTP =====================
  Future<void> verifyResetPasswordOTP(String otp) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await verifyResetPasswordOTPUseCase(otp);

    result.fold(
      (f) => emit(state.copyWith(status: AuthStatus.error, message: f.message)),
      (_) => emit(
        state.copyWith(
          status: AuthStatus.resetPasswordVerified,
          message: "OTP verified. You can now reset your password",
        ),
      ),
    );
  }

  // ===================== RESET PASSWORD =====================
  Future<void> resetPassword(String newPassword) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await resetPasswordUseCase(newPassword);

    result.fold(
      (f) => emit(state.copyWith(status: AuthStatus.error, message: f.message)),
      (_) => emit(
        state.copyWith(
          status: AuthStatus.success,
          message: "Password reset successfully",
        ),
      ),
    );
  }
}

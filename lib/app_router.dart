import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/presentation/screens/set_up_profile_screen.dart';
import 'core/services/local_storage_service.dart';
import 'core/utils/my_logger.dart';
import 'core/utils/page_transitions.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/screens/forget_password_screen.dart';
import 'features/auth/presentation/screens/otp_screen.dart';
import 'features/auth/presentation/screens/reset_password_screen.dart';
import 'features/auth/presentation/screens/signin_screen.dart';
import 'features/auth/presentation/screens/signup_screen.dart';
import 'features/auth/presentation/screens/verify_account_screen.dart';
import 'features/onboarding/domain/repository/onboarding_repository.dart';
import 'features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'injection/injection_container.dart';

// Helper class to make AuthCubit work with GoRouter's refreshListenable
class _AuthStateNotifier extends ChangeNotifier {
  final AuthCubit _authCubit;

  _AuthStateNotifier(this._authCubit) {
    _authCubit.stream.listen((_) {
      notifyListeners();
    });
  }
}

final appRouter = GoRouter(
  initialLocation: '/splash',
  refreshListenable: _AuthStateNotifier(sl<AuthCubit>()),

  redirect: (context, state) {
    final authStatus = sl<AuthCubit>().state.status;
    final localStorage = sl<LocalStorageService>();
    final currentLocation = state.matchedLocation;

    MyLogger.info(
      '[Router] Redirect check - Current: $currentLocation, AuthStatus: $authStatus',
    );

    final hasSeenOnboarding = localStorage.hasSeenOnboarding();
    final hasSetupProfile = localStorage.hasSetupProfile();

    const authPaths = [
      '/signin',
      '/signup',
      '/verify-account',
      '/forget-password',
      '/verify-reset-otp',
      '/reset-password',
    ];

    const publicPaths = ['/splash', '/onboarding', ...authPaths];

    // If auth is still initializing, stay on splash or current page
    if (authStatus == AuthStatus.initial) {
      if (currentLocation != '/splash') {
        MyLogger.info('[Router] Auth not ready → redirecting to /splash');
        return '/splash';
      }
      MyLogger.debug('[Router] Auth initializing - staying on splash');
      return null;
    }

    // On splash - auth is ready, redirect based on status
    if (currentLocation == '/splash') {
      if (authStatus == AuthStatus.unauthenticated) {
        if (!hasSeenOnboarding) {
          MyLogger.info('[Router] Splash → /onboarding (first time user)');
          return '/onboarding';
        }
        MyLogger.info('[Router] Splash → /signin (unauthenticated)');
        return '/signin';
      }

      if (authStatus == AuthStatus.unverified) {
        MyLogger.info('[Router] Splash → /verify-account');
        return '/verify-account';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (!hasSetupProfile) {
          MyLogger.info('[Router] Splash → /set-up-profile');
          return '/set-up-profile';
        }
        MyLogger.info('[Router] Splash → /home');
        return '/home';
      }

      MyLogger.debug('[Router] On splash - no redirect needed');
      return null;
    }

    // Unauthenticated flow
    if (authStatus == AuthStatus.unauthenticated) {
      if (!hasSeenOnboarding && currentLocation != '/onboarding') {
        MyLogger.info('[Router] Redirecting to /onboarding');
        return '/onboarding';
      }
      if (!authPaths.contains(currentLocation)) {
        MyLogger.info('[Router] Redirecting to /signin');
        return '/signin';
      }
      return null;
    }

    // Email unverified
    if (authStatus == AuthStatus.unverified &&
        currentLocation != '/verify-account') {
      MyLogger.info('[Router] Redirecting to /verify-account');
      return '/verify-account';
    }

    // // Password reset flow
    // if (authStatus == AuthStatus.resetPasswordRequested &&
    //     currentLocation != '/verify-reset-otp') {
    //   MyLogger.info('[Router] Redirecting to /verify-reset-otp');
    //   return '/verify-reset-otp';
    // }

    // if (authStatus == AuthStatus.resetPasswordVerified &&
    //     currentLocation != '/reset-password') {
    //   MyLogger.info('[Router] Redirecting to /reset-password');
    //   return '/reset-password';
    // }

    // Authenticated user handling
    if (authStatus == AuthStatus.authenticated) {
      if (!hasSetupProfile && currentLocation != '/set-up-profile') {
        MyLogger.info('[Router] Redirecting to /set-up-profile');
        return '/set-up-profile';
      }

      // Block navigation to public/auth pages
      if (publicPaths.contains(currentLocation)) {
        MyLogger.info(
          '[Router] Redirecting to /home (block public page access)',
        );
        return '/home';
      }

      return null;
    }

    return null;
  },

  routes: [
    // ===================== SPLASH SCREEN =====================
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) =>
          PageTransitions.smoothTransition(const SplashScreen()),
    ),

    // ===================== ONBOARDING =====================
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) {
        final pages = OnboardingRepository.getData(context);
        // page transition is an animation for transition between pages
        return PageTransitions.smoothTransition(
          // Providing the OnboardingCubit to the OnboardingScreen using BlocProvider
          BlocProvider(
            create: (context) => OnboardingCubit(totalPages: pages.length),
            child: OnboardingScreen(pages: pages),
          ),
        );
      },
    ),

    // ===================== ROOT & HOME =====================
    GoRoute(path: '/', redirect: (context, state) => '/splash'),

    GoRoute(
      path: '/home',
      pageBuilder: (context, state) =>
          PageTransitions.smoothTransition(const Scaffold()),
    ),

    // ===================== AUTH ROUTES =====================
    GoRoute(
      path: '/signin',
      pageBuilder: (context, state) =>
          PageTransitions.smoothTransition(const SigninScreen()),
    ),

    GoRoute(
      path: '/signup',
      pageBuilder: (context, state) =>
          PageTransitions.smoothTransition(const SignupScreen()),
    ),

    GoRoute(
      path: '/verify-account',
      pageBuilder: (context, state) =>
          PageTransitions.smoothTransition(const VerifyAccountScreen()),
    ),

    GoRoute(
      path: '/forget-password',
      pageBuilder: (context, state) =>
          PageTransitions.smoothTransition(const ForgetPasswordScreen()),
    ),

    GoRoute(
      path: '/verify-reset-otp',
      pageBuilder: (context, state) =>
          PageTransitions.smoothTransition(const OtpScreen()),
    ),

    GoRoute(
      path: '/reset-password',
      pageBuilder: (context, state) =>
          PageTransitions.smoothTransition(const ResetPasswordScreen()),
    ),

    GoRoute(
      path: '/set-up-profile',

      pageBuilder: (context, state) {
        final user = UserEntity(
          username: 'username1',
          email: 'test@example.com',
        );
        return PageTransitions.smoothTransition(
          SetUpProfileScreen(userEntity: user),
        );
      },
    ),
  ],
);

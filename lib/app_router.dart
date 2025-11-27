import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/utils/page_transitions.dart';
import 'package:mirath/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mirath/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:mirath/features/auth/presentation/screens/otp_screen.dart';
import 'package:mirath/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:mirath/features/auth/presentation/screens/signin_screen.dart';
import 'package:mirath/features/auth/presentation/screens/signup_screen.dart';
import 'package:mirath/features/auth/presentation/screens/verify_account_screen.dart';
import 'package:mirath/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:mirath/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:mirath/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:mirath/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:mirath/features/splash/presentation/screens/splash_screen.dart';
import 'package:mirath/injection/injection_container.dart';

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
    final currentLocation = state.matchedLocation;

    // Auth flow paths
    const authPaths = [
      '/signin',
      '/signup',
      '/verify-account',
      '/forget-password',
      '/verify-reset-otp',
      '/reset-password',
    ];

    // Public paths that don't require authentication
    const publicPaths = ['/splash', '/onboarding', ...authPaths];

    // Don't interfere with splash screen - it handles its own navigation
    if (currentLocation == '/splash') {
      return null;
    }

    // Initial state - only redirect to splash if not on a public path
    if (authStatus == AuthStatus.initial) {
      // Allow onboarding and other public paths
      if (publicPaths.contains(currentLocation)) return null;
      return '/splash';
    }

    // Unauthenticated - allow access to auth screens
    if (authStatus == AuthStatus.unauthenticated) {
      // If already on an auth screen or onboarding, stay there
      if (authPaths.contains(currentLocation) ||
          currentLocation == '/onboarding')
        return null;
      // Otherwise redirect to signin
      return '/signin';
    }

    // Unverified - redirect to verification screen
    if (authStatus == AuthStatus.unverified) {
      if (currentLocation == '/verify-account') return null;
      return '/verify-account';
    }

    // OTP sent for password reset - redirect to OTP screen
    if (authStatus == AuthStatus.resetPasswordRequested) {
      if (currentLocation == '/verify-reset-otp') return null;
      return '/verify-reset-otp';
    }

    // OTP verified for password reset - redirect to reset password screen
    if (authStatus == AuthStatus.resetPasswordVerified) {
      if (currentLocation == '/reset-password') return null;
      return '/reset-password';
    }

    // Authenticated - redirect away from auth screens to home
    if (authStatus == AuthStatus.authenticated) {
      if (publicPaths.contains(currentLocation)) return '/home';
      return null;
    }

    return null;
  },
  routes: [
    // ===================== SPLASH SCREEN =====================
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => PageTransitions.smoothTransition(
        BlocProvider(
          create: (context) => sl<SplashCubit>(),
          child: const SplashScreen(),
        ),
      ),
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
      pageBuilder: (context, state) => PageTransitions.smoothTransition(
        // TODO: Replace with actual home screen
        const Scaffold(body: Center(child: Text('Home Screen - TODO'))),
      ),
    ),

    // ===================== AUTH ROUTES =====================
    GoRoute(
      path: '/signin',
      pageBuilder: (context, state) => PageTransitions.smoothTransition(
        BlocProvider(
          create: (context) => sl<AuthCubit>(),
          child: const SigninScreen(),
        ),
      ),
    ),

    GoRoute(
      path: '/signup',
      pageBuilder: (context, state) => PageTransitions.smoothTransition(
        BlocProvider(
          create: (context) => sl<AuthCubit>(),
          child: const SignupScreen(),
        ),
      ),
    ),

    GoRoute(
      path: '/verify-account',
      pageBuilder: (context, state) => PageTransitions.smoothTransition(
        BlocProvider(
          create: (context) => sl<AuthCubit>(),
          child: const VerifyAccountScreen(),
        ),
      ),
    ),

    GoRoute(
      path: '/forget-password',
      pageBuilder: (context, state) => PageTransitions.smoothTransition(
        BlocProvider(
          create: (context) => sl<AuthCubit>(),
          child: const ForgetPasswordScreen(),
        ),
      ),
    ),

    GoRoute(
      path: '/verify-reset-otp',
      pageBuilder: (context, state) => PageTransitions.smoothTransition(
        BlocProvider(
          create: (context) => sl<AuthCubit>(),
          child: const OtpScreen(),
        ),
      ),
    ),

    GoRoute(
      path: '/reset-password',
      pageBuilder: (context, state) => PageTransitions.smoothTransition(
        BlocProvider(
          create: (context) => sl<AuthCubit>(),
          child: const ResetPasswordScreen(),
        ),
      ),
    ),
  ],
);

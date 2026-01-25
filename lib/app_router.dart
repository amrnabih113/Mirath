import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/features/community/presentation/screens/community_search_result.dart';
import 'package:mirath/features/home/presentation/cubit/home_cubit.dart';

import 'core/services/local_storage_service.dart';
import 'core/services/user_cache_service.dart';
import 'core/utils/my_logger.dart';
import 'core/utils/page_transitions.dart';
import 'features/Layout/presentation/cubit/layout_cubit.dart';
import 'features/Layout/presentation/screens/main_layout.dart';
import 'features/auth/data/models/auth_user_data.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/screens/forget_password_screen.dart';
import 'features/auth/presentation/screens/otp_screen.dart';
import 'features/auth/presentation/screens/reset_password_screen.dart';
import 'features/auth/presentation/screens/signin_screen.dart';
import 'features/auth/presentation/screens/signup_screen.dart';
import 'features/auth/presentation/screens/verify_account_screen.dart';
import 'features/community/presentation/screens/community_screen.dart';
import 'features/community/presentation/screens/disscussion_details_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/home/presentation/screens/recentely_published_screen.dart';
import 'features/home/presentation/screens/search_result_screen.dart';
import 'features/home/presentation/screens/search_screen.dart';
import 'features/interests/presentation/cubit/interests_cubit.dart';
import 'features/interests/presentation/screens/interests_screen.dart';
import 'features/onboarding/domain/repository/onboarding_repository.dart';
import 'features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/users/domain/entities/profile_setup_data.dart';
import 'features/users/presentation/screens/set_up_profile_screen.dart';
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
    final authCubit = sl<AuthCubit>();
    final authState = authCubit.state;
    final currentLocation = state.matchedLocation;
    final hasSeenOnboarding = sl<LocalStorageService>().hasSeenOnboarding();

    MyLogger.info(
      '[Router] Redirect check - Current: $currentLocation, Status: ${authState.status}',
    );

    // Define route groups
    const splashRoute = '/splash';
    const onboardingRoute = '/onboarding';
    const authPaths = {
      '/signin',
      '/signup',
      '/verify-account',
      '/forget-password',
      '/verify-reset-otp',
      '/reset-password',
    };

    // ===== INITIAL STATE =====
    // App just started, still checking auth
    if (authState.status == AuthStatus.initial) {
      if (currentLocation != splashRoute) {
        MyLogger.info('[Router] Initial → /splash (checking auth)');
        return splashRoute;
      }
      return null; // Stay on splash
    }

    // ===== UNAUTHENTICATED =====
    // User not logged in
    if (authState.status == AuthStatus.unauthenticated) {
      // First-time user: show onboarding
      if (!hasSeenOnboarding && currentLocation != onboardingRoute) {
        MyLogger.info('[Router] Unauthenticated → /onboarding (first time)');
        return onboardingRoute;
      }

      // Onboarded but not authenticated: must go to signin
      if (!authPaths.contains(currentLocation) &&
          currentLocation != onboardingRoute &&
          currentLocation != splashRoute) {
        MyLogger.info('[Router] Unauthenticated → /signin (must login)');
        return '/signin';
      }

      return null; // Allow auth routes and onboarding
    }

    // ===== EMAIL UNVERIFIED =====
    // User logged in but email not verified
    if (authState.status == AuthStatus.unverified) {
      if (currentLocation != '/verify-account' &&
          currentLocation != splashRoute) {
        MyLogger.info('[Router] Unverified → /verify-account (verify email)');
        return '/verify-account';
      }
      return null;
    }

    // ===== AUTHENTICATED =====
    // User fully authenticated
    if (authState.status == AuthStatus.authenticated) {
      // Block access to auth pages if fully authenticated
      if (authPaths.contains(currentLocation) ||
          (currentLocation == onboardingRoute && hasSeenOnboarding)) {
        MyLogger.info('[Router] Authenticated → /home (blocking auth routes)');
        return '/home';
      }

      return null; // Fully authenticated, allow route
    }

    // ===== ERROR STATE =====
    // Authentication failed
    if (authState.status == AuthStatus.error) {
      if (!authPaths.contains(currentLocation) &&
          currentLocation != onboardingRoute &&
          currentLocation != splashRoute) {
        MyLogger.info('[Router] Error state → /signin');
        return '/signin';
      }
      return null;
    }

    return null; // Default: no redirect
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

    // ===================== LAYOUT SHELL For NavBar =====================
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(
          create: (_) => LayoutCubit(),
          child: Builder(
            builder: (context) {
              context.read<LayoutCubit>().syncWithLocation(
                state.matchedLocation,
              );
              return MainLayout(child: child);
            },
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => NoTransitionPage(
            child: BlocProvider.value(
              value: sl<HomeCubit>(),
              child: HomeScreen(),
            ),
          ),
        ),
        GoRoute(
          path: '/community',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: CommunityScreen()),
        ),
        GoRoute(
          path: '/library',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: Scaffold(body: Center(child: Text('Library Screen'))),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => NoTransitionPage(
            child: Scaffold(body: Center(child: Text('Profile Screen'))),
          ),
        ),
      ],
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
          PageTransitions.smoothTransition(VerifyAccountScreen()),
    ),

    GoRoute(
      path: '/forget-password',
      pageBuilder: (context, state) =>
          PageTransitions.smoothTransition(const ForgetPasswordScreen()),
    ),

    GoRoute(
      path: '/verify-reset-otp',
      pageBuilder: (context, state) =>
          PageTransitions.smoothTransition(OtpScreen()),
    ),

    GoRoute(
      path: '/reset-password',
      pageBuilder: (context, state) =>
          PageTransitions.smoothTransition(const ResetPasswordScreen()),
    ),

    GoRoute(
      path: '/set-up-profile',
      pageBuilder: (context, state) {
        final userCacheService = sl<UserCacheService>();
        final user = userCacheService.getCachedUser();
        return PageTransitions.smoothTransition(
          SetUpProfileScreen(user: user ?? AuthUserData.empty()),
        );
      },
    ),
    GoRoute(
      path: '/interests',
      pageBuilder: (context, state) {
        final userProfile = state.extra as ProfileSetupData?;
        if (userProfile == null) {
          // If no user profile data is provided, redirect to setup profile
          return PageTransitions.smoothTransition(
            const Scaffold(
              body: Center(
                child: Text('Invalid navigation - missing profile data'),
              ),
            ),
          );
        }
        return PageTransitions.smoothTransition(
          BlocProvider.value(
            value: sl<InterestsCubit>(),
            child: InterestsScreen(userProfile: userProfile),
          ),
        );
      },
    ),
    GoRoute(
      path: '/search',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return MaterialPage(
          child: SearchScreen(
            items: extra?['items'] ?? [],
            hintText: extra?['hintText'] ?? 'Search',
            headingText: extra?['headingText'],
            onSearchChanged: extra?['onSearchChanged'],
            onItemTap: extra?['onItemTap'],
            showHeading: extra?['showHeading'] ?? true,
            onRemoveTap: extra?['onRemoveTap'],
          ),
        );
      },
    ),
    GoRoute(
      path: '/home-search-results',
      pageBuilder: (context, state) =>
          PageTransitions.smoothTransition(const HomeSearchResultScreen()),
    ),
    GoRoute(
      path: '/recentely-published',
      pageBuilder: (context, state) =>
          PageTransitions.smoothTransition(const RecentelyPublishedScreen()),
    ),
    GoRoute(
      path: '/community-search-results',
      pageBuilder: (context, state) =>
          PageTransitions.smoothTransition(const CommunitySearchResult()),
    ),
    GoRoute(
      path: '/disscussion-details',
      pageBuilder: (context, state) =>
          PageTransitions.smoothTransition(const DisscussionDetailsScreen()),
    ),
  ],
);

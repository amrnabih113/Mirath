import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/features/community/presentation/screens/community_search_result.dart';
import 'package:mirath/features/community/presentation/screens/reading_list_details_screen.dart';
import 'package:mirath/features/home/presentation/cubit/home_cubit.dart';

import 'core/services/local_storage_service.dart';
import 'core/utils/my_logger.dart';
import 'core/utils/page_transitions.dart';
import 'features/Layout/presentation/cubit/layout_cubit.dart';
import 'features/Layout/presentation/screens/main_layout.dart';
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

  redirect: (context, state) async {
    final authStatus = sl<AuthCubit>().state.status;
    final authCubit = sl<AuthCubit>();
    final localStorage = sl<LocalStorageService>();
    final currentLocation = state.matchedLocation;

    MyLogger.info(
      '[Router] Redirect check - Current: $currentLocation, AuthStatus: $authStatus',
    );

    final hasSeenOnboarding = localStorage.hasSeenOnboarding();

    // Check profile setup status from server for authenticated users
    bool hasSetupProfile = false;
    if (authStatus == AuthStatus.authenticated) {
      hasSetupProfile = await authCubit.checkSetup();
    }

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

    // Authenticated user handling
    if (authStatus == AuthStatus.authenticated) {
      if (!hasSetupProfile &&
          (currentLocation != '/set-up-profile' &&
              currentLocation != '/interests')) {
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

    // Handle authentication errors - allow staying on current auth pages
    if (authStatus == AuthStatus.error) {
      if (authPaths.contains(currentLocation) ||
          currentLocation == '/set-up-profile' ||
          currentLocation == '/interests') {
        return null; // Stay on current page
      }
      // For other pages, redirect to signin
      MyLogger.info('[Router] Auth error - redirecting to /signin');
      return '/signin';
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

    // ===================== LAYOUT SHELL For NavBar =====================
    ShellRoute(
      builder: (context, state, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => LayoutCubit()),
            BlocProvider(create: (_) => sl<HomeCubit>()),
          ],
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
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HomeScreen()),
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
            child: Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    sl<AuthCubit>().signOut();
                  },
                  child: Text('Sign Out'),
                ),
              ),
            ),
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
        return PageTransitions.smoothTransition(SetUpProfileScreen());
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
      pageBuilder: (context, state) => NoTransitionPage(
        child: BlocProvider.value(
          value: sl<HomeCubit>()..getRecentPapers(),
          child: const RecentelyPublishedScreen(),
        ),
      ),
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
    GoRoute(
      path: '/reading-list-details',
      pageBuilder: (context, state) =>
          PageTransitions.smoothTransition(const ReadingListDetailsScreen()),
    ),
  ],
);

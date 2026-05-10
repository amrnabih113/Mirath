import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/features/chatbot/presentation/cubit/chatbot_cubit.dart';
import 'package:mirath/features/chatbot/presentation/screens/chatbot_screen.dart';
import 'package:mirath/features/discussions/presentation/screens/add_discussion_screen.dart';
import 'package:mirath/features/home/domain/entities/paper_entity.dart';
import 'package:mirath/features/home/presentation/cubit/search_cubit.dart';
import 'package:mirath/features/library/presentation/cubit/library_cubit.dart';
import 'package:mirath/features/library/presentation/screens/library_screen.dart';
import 'package:mirath/features/library/presentation/screens/other_user_reading_list.dart';
import 'package:mirath/features/library/presentation/screens/projects_screen.dart';
import 'package:mirath/features/library/presentation/screens/reading_history_screen.dart';
import 'package:mirath/features/library/presentation/screens/reading_later_screen.dart';
import 'package:mirath/features/library/presentation/screens/reading_list_screen.dart';
import 'package:mirath/features/paper_annotations/presentation/cubit/paper_reading_cubit.dart';
import 'package:mirath/features/papers/presentation/screens/paper_discussions_screen.dart';
import 'package:mirath/features/papers/presentation/screens/paper_reading_screen.dart';
import 'package:mirath/features/papers/presentation/screens/paper_screen.dart';
import 'package:mirath/features/profile/presentation/screens/edit_intersts_screen.dart';
import 'package:mirath/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:mirath/features/profile/presentation/screens/follower_following_screen.dart';
import 'package:mirath/features/profile/presentation/screens/other_users_profile.dart';
import 'package:mirath/features/profile/presentation/screens/profile_screen.dart';
import 'package:mirath/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mirath/features/profile/presentation/screens/setting_screen.dart';
import 'package:mirath/features/reading_lists/presentation/cubit/reading_list_cubit.dart';
import 'package:mirath/features/users/presentation/cubit/profile_header_cubit.dart';
import 'package:mirath/generated/l10n.dart';
import 'core/constants/route_names.dart';
import 'features/discussions/presentation/cubit/community_cubit.dart';
import 'features/discussions/presentation/cubit/discussion_details_cubit.dart';
import 'features/discussions/presentation/cubit/global_search_cubit.dart';
import 'features/discussions/presentation/screens/community_search_result.dart';
import 'features/discussions/presentation/cubit/global_search_state.dart';
import 'features/reading_lists/presentation/screens/reading_list_details_screen.dart';
import 'features/home/presentation/cubit/home_cubit.dart';
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
import 'features/discussions/presentation/screens/community_screen.dart';
import 'features/discussions/presentation/screens/disscussion_details_screen.dart';
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
  initialLocation: RouteNames.splash,
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
    if (authStatus == AuthStatus.authenticated ||
        authStatus == AuthStatus.loading) {
      hasSetupProfile = await authCubit.checkSetup();
    }

    const authPaths = [
      RouteNames.signin,
      RouteNames.signup,
      RouteNames.verifyAccount,
      RouteNames.forgetPassword,
      RouteNames.verifyResetOtp,
      RouteNames.resetPassword,
    ];

    const publicPaths = [
      RouteNames.splash,
      RouteNames.onboarding,
      ...authPaths,
    ];

    // Email unverified
    if (authStatus == AuthStatus.unverified &&
        currentLocation != RouteNames.verifyAccount) {
      MyLogger.info('[Router] Redirecting to verify-account');
      return RouteNames.verifyAccount;
    }

    // Authenticated user handling
    if (authStatus == AuthStatus.authenticated) {
      if (!hasSetupProfile &&
          (currentLocation != RouteNames.setupProfile &&
              currentLocation != RouteNames.interests)) {
        MyLogger.info('[Router] Redirecting to setup-profile');
        return RouteNames.setupProfile;
      }

      // Block navigation to public/auth pages
      if (publicPaths.contains(currentLocation)) {
        MyLogger.info(
          '[Router] Redirecting to home (block public page access)',
        );
        return RouteNames.home;
      }

      return null;
    }

    // Successfully authenticated user (after setup completion)
    if (authStatus == AuthStatus.success) {
      // Block navigation to public/auth pages
      if (publicPaths.contains(currentLocation)) {
        MyLogger.info(
          '[Router] Redirecting to home (block public page access)',
        );
        return RouteNames.home;
      }

      // For any other page during success, allow it temporarily
      // The success listener in the UI will handle navigation to /home
      return null;
    }

    // Handle authentication errors - allow staying on current auth pages
    if (authStatus == AuthStatus.error) {
      if (authPaths.contains(currentLocation) ||
          currentLocation == RouteNames.setupProfile ||
          currentLocation == RouteNames.interests) {
        return null; // Stay on current page
      }
      // For other pages, redirect to signin
      MyLogger.info('[Router] Auth error - redirecting to signin');
      return RouteNames.signin;
    }

    // Unauthenticated users
    if (authStatus == AuthStatus.unauthenticated) {
      // If user hasn't seen onboarding, send there first
      if (!hasSeenOnboarding && currentLocation != RouteNames.onboarding) {
        MyLogger.info('[Router] Unauthenticated - redirecting to onboarding');
        return RouteNames.onboarding;
      }

      // Allow staying on auth pages; otherwise go to signin
      if (authPaths.contains(currentLocation) ||
          currentLocation == RouteNames.onboarding) {
        return null;
      }

      MyLogger.info('[Router] Unauthenticated - redirecting to signin');
      return RouteNames.signin;
    }

    return null;
  },

  routes: [
    // ===================== SPLASH SCREEN =====================
    GoRoute(
      path: RouteNames.splash,
      pageBuilder: (context, state) =>
          PageTransitions.smoothTransition(const SplashScreen()),
    ),

    // ===================== ONBOARDING =====================
    GoRoute(
      path: RouteNames.onboarding,
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
    GoRoute(path: '/', redirect: (context, state) => RouteNames.splash),

    // ===================== LAYOUT SHELL For NavBar =====================
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider.value(
          value: sl<LayoutCubit>(),
          child: Builder(
            builder: (context) {
              sl<LayoutCubit>().syncWithLocation(state.matchedLocation);
              return MainLayout(child: child);
            },
          ),
        );
      },
      routes: [
        GoRoute(
          path: RouteNames.home,
          pageBuilder: (context, state) => NoTransitionPage(
            child: BlocProvider.value(
              value: sl<HomeCubit>(),
              child: const HomeScreen(),
            ),
          ),
        ),
        GoRoute(
          path: RouteNames.community,
          pageBuilder: (context, state) => NoTransitionPage(
            child: BlocProvider(
              create: (_) => sl<CommunityCubit>()..getDiscussions(),
              child: const CommunityScreen(),
            ),
          ),
        ),
        GoRoute(
          path: RouteNames.library,
          pageBuilder: (context, state) => NoTransitionPage(
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => sl<LibraryCubit>()..getLibraryData(),
                ),
                BlocProvider(create: (_) => sl<ReadingListCubit>()),
              ],
              child: const LibraryScreen(),
            ),
          ),
        ),
        GoRoute(
          path: RouteNames.profile,
          pageBuilder: (context, state) => NoTransitionPage(
            child: BlocProvider.value(
              value: sl<ProfileCubit>()..loadCurrentUser(),
              child: const ProfileScreen(),
            ),
          ),
        ),
      ],
    ),

    // ===================== AUTH ROUTES =====================
    GoRoute(
      path: RouteNames.signin,
      pageBuilder: (context, state) => PageTransitions.smoothTransition(
        SigninScreen(postSignInTarget: state.extra as String?),
      ),
    ),

    GoRoute(
      path: RouteNames.signup,
      pageBuilder: (context, state) =>
          PageTransitions.smoothTransition(const SignupScreen()),
    ),

    GoRoute(
      path: RouteNames.verifyAccount,
      pageBuilder: (context, state) =>
          PageTransitions.smoothTransition(VerifyAccountScreen()),
    ),

    GoRoute(
      path: RouteNames.forgetPassword,
      pageBuilder: (context, state) =>
          PageTransitions.smoothTransition(const ForgetPasswordScreen()),
    ),

    GoRoute(
      path: RouteNames.verifyResetOtp,
      pageBuilder: (context, state) =>
          PageTransitions.smoothTransition(OtpScreen()),
    ),

    GoRoute(
      path: RouteNames.resetPassword,
      pageBuilder: (context, state) =>
          PageTransitions.smoothTransition(const ResetPasswordScreen()),
    ),

    GoRoute(
      path: RouteNames.setupProfile,
      pageBuilder: (context, state) {
        return PageTransitions.smoothTransition(SetUpProfileScreen());
      },
    ),
    GoRoute(
      path: RouteNames.interests,
      pageBuilder: (context, state) {
        final userProfile = state.extra as ProfileSetupData?;
        return PageTransitions.smoothTransition(
          BlocProvider(
            create: (_) => sl<InterestsCubit>(),
            child: InterestsScreen(
              userProfile: userProfile ?? ProfileSetupData.empty(),
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: RouteNames.search,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PageTransitions.smoothTransition(
          BlocProvider(
            create: (_) => sl<SearchCubit>(),
            child: SearchScreen(
              hintText: extra?['hintText'] as String? ?? 'Search',
              showHeading: extra?['showHeading'] as bool? ?? true,
              resultRoute:
                  extra?['resultRoute'] as String? ??
                  RouteNames.homeSearchResults,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: RouteNames.homeSearchResults,
      pageBuilder: (context, state) => PageTransitions.smoothTransition(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<SearchCubit>()),
            BlocProvider.value(value: sl<HomeCubit>()),
          ],
          child: const HomeSearchResultScreen(),
        ),
      ),
    ),
    GoRoute(
      path: RouteNames.recentlyPublished,
      pageBuilder: (context, state) => NoTransitionPage(
        child: BlocProvider.value(
          value: sl<HomeCubit>(),
          child: RecentelyPublishedScreen(
            selectedCategory: state.extra as String?,
          ),
        ),
      ),
    ),
    GoRoute(
      path: RouteNames.communitySearchResults,
      pageBuilder: (context, state) {
        final initialQuery = state.extra is String
            ? state.extra as String
            : null;
        final scopeParam = state.uri.queryParameters['scope'];
        GlobalSearchScope? initialScope;
        switch (scopeParam) {
          case 'discussions':
            initialScope = GlobalSearchScope.discussions;
            break;
          case 'readingLists':
            initialScope = GlobalSearchScope.readingLists;
            break;
          case 'researchers':
            initialScope = GlobalSearchScope.researchers;
            break;
          case 'top':
          default:
            initialScope = GlobalSearchScope.top;
        }

        return PageTransitions.smoothTransition(
          BlocProvider(
            create: (_) => sl<GlobalSearchCubit>(),
            child: CommunitySearchResult(
              initialQuery: initialQuery,
              initialScope: initialScope,
            ),
          ),
        );
      },
    ),

    /// Paper Details - requires paperId in path
    GoRoute(
      path: RouteNames.paperDetails,
      pageBuilder: (context, state) {
        final paperId = state.pathParameters['paperId'] ?? '';
        if (paperId.isEmpty) {
          return PageTransitions.smoothTransition(
            Scaffold(
              appBar: AppBar(title: Text(S.of(context).error_label)),
              body: const Center(child: Text('Error: No paper data provided')),
            ),
          );
        }
        // Router only passes ids/extra; screens handle fetching.
        final extraPaper = state.extra as PaperEntity?;
        return PageTransitions.smoothTransition(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: sl<HomeCubit>()),
              BlocProvider(create: (_) => sl<LibraryCubit>()),
            ],
            child: PaperScreen(
              paper: extraPaper,
              paperId: extraPaper == null ? paperId : null,
            ),
          ),
        );
      },
    ),

    /// Paper Reading - requires paperId in path
    GoRoute(
      path: RouteNames.paperReading,
      pageBuilder: (context, state) {
        final paperId = state.pathParameters['paperId'] ?? '';
        if (paperId.isEmpty) {
          return PageTransitions.smoothTransition(const SizedBox.shrink());
        }

        final paper = state.extra as PaperEntity?;
        return PageTransitions.smoothTransition(
          BlocProvider(
            create: (_) => sl<PaperReadingCubit>(),
            child: PaperReadingScreen(
              paper: paper,
              paperId: paper == null ? paperId : null,
            ),
          ),
        );
      },
    ),

    /// Paper Discussions - requires paperId in path
    GoRoute(
      path: RouteNames.paperDiscussions,
      pageBuilder: (context, state) {
        final paperId = state.pathParameters['paperId'] ?? '';
        if (paperId.isEmpty)
          return PageTransitions.smoothTransition(const SizedBox.shrink());

        final extraPaper = state.extra as PaperEntity?;

        // Router only passes ids/extra; screen will fetch paper/discussions if needed.
        return PageTransitions.smoothTransition(
          BlocProvider(
            create: (_) => sl<CommunityCubit>(),
            child: PaperDiscussionsScreen(
              paper: extraPaper,
              paperId: extraPaper == null ? paperId : null,
            ),
          ),
        );
      },
    ),

    // ===================== DISCUSSION ROUTES =====================
    /// Discussion Details - requires discussionId in path
    GoRoute(
      path: RouteNames.discussionDetails,
      pageBuilder: (context, state) {
        final discussionId = state.pathParameters['discussionId'] ?? '';
        if (discussionId.isEmpty) {
          return PageTransitions.smoothTransition(
            Scaffold(
              appBar: AppBar(title: Text(S.of(context).error_label)),
              body: const Center(
                child: Text('Error: No discussion ID provided'),
              ),
            ),
          );
        }
        // Router only passes ids; screen/cubit will perform loading.
        return PageTransitions.smoothTransition(
          key: state.pageKey,
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<DiscussionDetailsCubit>()),
              BlocProvider(create: (_) => sl<CommunityCubit>()),
            ],
            child: DisscussionDetailsScreen(discussionId: discussionId),
          ),
        );
      },
    ),

    GoRoute(
      path: RouteNames.addDiscussion,
      pageBuilder: (context, state) {
        return PageTransitions.smoothTransition(const AddDiscussionScreen());
      },
    ),

    // ===================== READING LIST ROUTES =====================
    GoRoute(
      path: RouteNames.readingLists,
      pageBuilder: (context, state) {
        return PageTransitions.smoothTransition(
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => sl<ReadingListCubit>()
                  ..getUserReadingLists()
                  ..getSavedReadingLists(),
              ),
              BlocProvider(
                create: (context) => sl<LibraryCubit>()..getAllSavedPapers(),
              ),
            ],
            child: const ReadingListScreen(),
          ),
        );
      },
    ),

    /// Reading List Details - requires readingListId in path
    GoRoute(
      path: RouteNames.readingListDetails,
      pageBuilder: (context, state) {
        final readingListId = state.pathParameters['readingListId'] ?? '';
        if (readingListId.isEmpty) {
          return PageTransitions.smoothTransition(
            Scaffold(
              appBar: AppBar(title: Text(S.of(context).error_label)),
              body: const Center(
                child: Text('Error: No reading list ID provided'),
              ),
            ),
          );
        }
        // Router passes the id; screen/cubit will fetch the reading list by id.
        return PageTransitions.smoothTransition(
          BlocProvider(
            create: (_) => sl<ReadingListCubit>(),
            child: ReadingListDetailsScreen(readingListId: readingListId),
          ),
        );
      },
    ),

    GoRoute(
      path: RouteNames.readingHistory,
      pageBuilder: (context, state) {
        return PageTransitions.smoothTransition(
          BlocProvider(
            create: (_) => sl<LibraryCubit>()..getReadingHistory(),
            child: const ReadingHistoryScreen(),
          ),
        );
      },
    ),

    GoRoute(
      path: RouteNames.readLater,
      pageBuilder: (context, state) {
        return PageTransitions.smoothTransition(
          BlocProvider(
            create: (context) => sl<LibraryCubit>()..getAllSavedPapers(),
            child: const ReadingLaterScreen(),
          ),
        );
      },
    ),

    // ===================== USER PROFILE ROUTES =====================
    /// User Profile - requires userId in path
    GoRoute(
      path: RouteNames.userProfile,
      pageBuilder: (context, state) {
        final userId = state.pathParameters['userId'] ?? '';
        if (userId.isEmpty) {
          return PageTransitions.smoothTransition(const SizedBox.shrink());
        }
        return PageTransitions.smoothTransition(
          key: state.pageKey,
          BlocProvider(
            create: (_) => sl<ProfileHeaderCubit>(),
            child: OtherUsersProfile(userId: userId),
          ),
        );
      },
    ),

    /// Follower/Following - requires userId in path
    GoRoute(
      path: RouteNames.followerFollowing,
      pageBuilder: (context, state) {
        final userId = state.pathParameters['userId'] ?? '';
        final tabStr = state.uri.queryParameters['tab'] ?? '0';
        final tabIndex = int.tryParse(tabStr) ?? 0;

        if (userId.isEmpty) {
          return PageTransitions.smoothTransition(
            Scaffold(
              appBar: AppBar(title: Text(S.of(context).error_label)),
              body: const Center(child: Text('Error: No user data provided')),
            ),
          );
        }

        return PageTransitions.smoothTransition(
          key: state.pageKey,
          FollowerFollowingScreen(
            userId: userId,
            username: state.uri.queryParameters['username'],
            initialTabIndex: tabIndex,
          ),
        );
      },
    ),

    GoRoute(
      path: RouteNames.editProfile,
      pageBuilder: (context, state) {
        return PageTransitions.smoothTransition(
          BlocProvider.value(
            value: sl<ProfileCubit>(),
            child: const EditProfileScreen(),
          ),
        );
      },
    ),

    GoRoute(
      path: RouteNames.editInterests,
      pageBuilder: (context, state) {
        final initialSelected = state.extra as List<String>? ?? [];
        return PageTransitions.smoothTransition(
          BlocProvider.value(
            value: sl<InterestsCubit>(),
            child: EditInterstsScreen(initialSelected: initialSelected),
          ),
        );
      },
    ),

    GoRoute(
      path: RouteNames.settingsScreen,
      pageBuilder: (context, state) {
        return PageTransitions.smoothTransition(const SettingScreen());
      },
    ),

    // ===================== OTHER ROUTES =====================
    GoRoute(
      path: RouteNames.projects,
      pageBuilder: (context, state) {
        return PageTransitions.smoothTransition(const ProjectsScreen());
      },
    ),

    GoRoute(
      path: RouteNames.otherUserReadingList,
      pageBuilder: (context, state) {
        return PageTransitions.smoothTransition(const OtherUserReadingList());
      },
    ),

    GoRoute(
      path: RouteNames.chatbot,
      pageBuilder: (context, state) {
        return PageTransitions.smoothTransition(
          BlocProvider(
            create: (_) => sl<ChatbotCubit>(),
            child: ChatbotScreen(),
          ),
        );
      },
    ),
  ],
);

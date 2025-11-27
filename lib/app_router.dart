import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/utils/page_transitions.dart';
import 'package:mirath/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mirath/features/auth/presentation/screens/signin_screen.dart';
import 'package:mirath/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:mirath/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:mirath/features/onboarding/presentation/screens/onboarding_screen.dart';
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
  initialLocation: '/onboarding',
  refreshListenable: _AuthStateNotifier(sl<AuthCubit>()),

  //   redirect: (context, state) {
  //   final authStatus = sl<AuthCubit>().state.status;

  //   if (authStatus == AuthStatus.initial) return '/splash';

  //   if (authStatus == AuthStatus.unauthenticated) {
  //     if (state.matchedLocation == '/signin' || state.matchedLocation == '/signup') return null;
  //     return '/signin';
  //   }

  //   if (authStatus == AuthStatus.unverified) {
  //     if (state.matchedLocation != '/verify-email') return '/verify-email';
  //   }

  //   if (authStatus == AuthStatus.authenticated) {
  //     if (state.matchedLocation == '/signin' || state.matchedLocation == '/signup') return '/home';
  //   }

  //   return null;
  // },
  routes: [
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

    GoRoute(
      path: '/signin',
      pageBuilder: (context, state) => PageTransitions.smoothTransition(
        BlocProvider(
          create: (context) => sl<AuthCubit>(),
          child: const SigninScreen(),
        ),
      ),
    ),
  ],
);

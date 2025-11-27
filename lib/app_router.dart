import 'package:go_router/go_router.dart';
import 'package:mirath/core/utils/page_transitions.dart';
import 'package:mirath/features/auth/presentation/screens/signin_screen.dart';
import 'package:mirath/features/onboarding/presentation/screens/onboarding_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(path: '/onboarding',
      pageBuilder: (context, state) => PageTransitions.smoothTransition(const OnboardingScreen()),
    ),

    GoRoute(
  path: '/signin',
  pageBuilder: (context, state) => PageTransitions.smoothTransition(const SigninScreen()),
),],
);

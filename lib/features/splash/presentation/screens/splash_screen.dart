import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_logger.dart';
import '../cubit/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkAuthStatus();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  void _checkAuthStatus() {
    MyLogger.info('[SplashScreen] Calling checkAuthStatus on cubit');
    context.read<SplashCubit>().checkAuthStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        MyLogger.debug('[SplashScreen] State changed to ${state.runtimeType}');

        if (state is SplashNavigateToOnboarding) {
          MyLogger.info('[SplashScreen] Navigating to /onboarding');
          context.go('/onboarding');
        } else if (state is SplashNavigateToSignIn) {
          MyLogger.info('[SplashScreen] Navigating to /signin');
          context.go('/signin');
        } else if (state is SplashNavigateToVerifyAccount) {
          MyLogger.info('[SplashScreen] Navigating to /verify-account');
          context.go('/verify-account');
        } else if (state is SplashNavigateToHome) {
          MyLogger.info('[SplashScreen] Navigating to /home');
          context.go('/home');
        }
      },
      child: Scaffold(
        body: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Logo/Icon
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: MyColors.primaryColor,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: MyColors.primaryColor.withAlpha(30),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.apps_rounded,
                          size: 60,
                          color: isDarkMode
                              ? MyColors.textPrimaryDark
                              : MyColors.white,
                        ),
                      ),
                      SizedBox(height: MySizes.spaceXl(context)),
                      // App Name
                      // Tagline
                      Text('Welcome to', style: context.bodyMedium),
                      SizedBox(height: MySizes.spaceXs(context)),

                      Text('Mirath', style: context.headlineLarge),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/core/utils/page_transitions.dart';
import 'package:mirath/features/auth/presentation/screens/signin_screen.dart';
import 'package:mirath/features/common/widgets/screen_decoration.dart';
import 'package:mirath/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:mirath/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:mirath/features/onboarding/presentation/widgets/onboarding_page_widget.dart';
import 'package:mirath/features/onboarding/presentation/widgets/page_indicator.dart';
import 'package:mirath/features/onboarding/presentation/widgets/skip_button.dart';
import 'package:mirath/generated/l10n.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = OnboardingRepository.getData(context);
    return BlocProvider(
      create: (context) => OnboardingCubit(totalPages: pages.length),
      child: OnboardingView(pages: pages),
    );
  }
}

class OnboardingView extends StatefulWidget {
  final List pages;

  const OnboardingView({super.key, required this.pages});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingCompleted) {
            
            context.go('/signin');
          } else if (state is OnboardingPageChanged) {
            _pageController.animateToPage(
              state.currentPage,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: ScreenDecoration(
              child: SafeArea(
                child: Column(
                  children: [
                    // PageView
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          context.read<OnboardingCubit>().goToPage(index);
                        },
                        itemCount: widget.pages.length,
                        itemBuilder: (context, index) {
                          return OnboardingPageWidget(
                            page: widget.pages[index],
                          );
                        },
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(MySizes.spaceLg(context)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Page indicator
                          PageIndicator(
                            currentPage: state.currentPage,
                            totalPages: state.totalPages,
                          ),
                          SizedBox(height: MySizes.spaceXl(context)),
                          // Navigation button
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (!state.isLastPage)
                                    SkipButton(
                                      onPressed: () => context
                                          .read<OnboardingCubit>()
                                          .skipOnboarding(),
                                    ),
                                ],
                              ),
                              SizedBox(
                                width: MySizes.buttonWidth(context),
                                height: MySizes.buttonHeight(context),
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<OnboardingCubit>().nextPage();
                                  },
                                  child: Text(
                                    state.isLastPage
                                        ? S.of(context).get_started
                                        : S.of(context).next,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../injection/injection_container.dart';
import '../../../common/widgets/screen_decoration.dart';
import '../cubit/onboarding_cubit.dart';
import '../widgets/onboarding_page_widget.dart';
import '../widgets/page_indicator.dart';
import '../widgets/skip_button.dart';
import '../../../../generated/l10n.dart';

class OnboardingScreen extends StatefulWidget {
  final List pages;

  const OnboardingScreen({super.key, required this.pages});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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
            // Mark onboarding as seen in local storage
            sl<LocalStorageService>().setOnboardingSeen(true);
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 850),
                      child: Center(
                        child: Column(
                          children: [
                            // PageView
                            Expanded(
                              child: PageView.builder(
                                controller: _pageController,
                                onPageChanged: (index) {
                                  context.read<OnboardingCubit>().goToPage(
                                    index,
                                  );
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
                                  SizedBox(
                                    height: ResponsiveHelper.responsiveValue(
                                      context,
                                      20,
                                    ),
                                  ),
                                  // Navigation button
                                  Row(
                                    mainAxisAlignment: .spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: .end,
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
                                            context
                                                .read<OnboardingCubit>()
                                                .nextPage();
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
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

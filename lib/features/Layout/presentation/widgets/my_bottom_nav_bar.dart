import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_sizes.dart';
import '../cubit/layout_cubit.dart';
import 'nav_item.dart';

class MyBottomNavBar extends StatelessWidget {
  const MyBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCubit, LayoutState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = MediaQuery.of(context).size.width;
            final bottomPadding = MediaQuery.of(context).padding.bottom;
            final isLargeScreen = screenWidth >= 650;

            return Container(
              height:
                  ResponsiveHelper.responsiveValue(context, 55) +
                  bottomPadding +
                  MySizes.spaceMd(context),
              padding: EdgeInsets.only(
                left: isLargeScreen
                    ? (screenWidth - 650) / 2 + MySizes.spaceLg(context)
                    : MySizes.spaceMd(context),
                right: isLargeScreen
                    ? (screenWidth - 650) / 2 + MySizes.spaceLg(context)
                    : MySizes.spaceMd(context),
                bottom: bottomPadding > 0
                    ? bottomPadding + MySizes.spaceXs(context) * 0.5
                    : MySizes.spaceMd(context) * 0.5,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // Bottom Navigation Bar
                  Container(
                    height: ResponsiveHelper.responsiveValue(context, 55),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.responsiveValue(context, 10),
                    ),
                    decoration: BoxDecoration(
                      color: MyColors.primaryShade400,
                      borderRadius: BorderRadius.circular(
                        MySizes.borderRadiusLg(context),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(30),
                          blurRadius: MySizes.spaceLg(context),
                          spreadRadius: 0,
                          offset: Offset(0, MySizes.spaceXs(context)),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        MySizes.borderRadiusLg(context),
                      ),
                      child: Row(
                        children: [
                          NavItem(
                            icon: HugeIcons.strokeRoundedHome01,
                            label: 'Home',
                            index: 0,
                            currentIndex: state.currentIndex,
                            onTap: () {
                              context.read<LayoutCubit>().changeTab(0);
                              context.go('/home');
                            },
                          ),
                          NavItem(
                            icon: HugeIcons.strokeRoundedUserGroup03,
                            label: 'Community',
                            index: 1,
                            currentIndex: state.currentIndex,
                            onTap: () {
                              context.read<LayoutCubit>().changeTab(1);
                              context.go('/community');
                            },
                          ),
                          SizedBox(
                            width: ResponsiveHelper.responsiveValue(
                              context,
                              80,
                            ),
                          ),
                          NavItem(
                            icon: HugeIcons.strokeRoundedBookBookmark02,
                            label: 'Library',
                            index: 2,
                            currentIndex: state.currentIndex,
                            onTap: () {
                              context.read<LayoutCubit>().changeTab(2);
                              context.go('/library');
                            },
                          ),
                          NavItem(
                            icon: HugeIcons.strokeRoundedUser,
                            label: 'Profile',
                            index: 3,
                            currentIndex: state.currentIndex,
                            onTap: () {
                              context.read<LayoutCubit>().changeTab(3);
                              context.go('/profile');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Floating Action Button
                  Positioned(
                    top: ResponsiveHelper.responsiveValue(context, -15),
                    child: Container(
                      width: ResponsiveHelper.responsiveValue(context, 65),
                      height: ResponsiveHelper.responsiveValue(context, 65),
                      padding: EdgeInsets.all(MySizes.spaceXs(context) * 0.6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: MyColors.light,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(25),
                            blurRadius: MySizes.spaceMd(context),
                            offset: Offset(0, MySizes.spaceXs(context) * 0.5),
                          ),
                        ],
                      ),
                      child: FittedBox(
                        child: SizedBox(
                          width: ResponsiveHelper.responsiveValue(context, 56),
                          height: ResponsiveHelper.responsiveValue(context, 56),
                          child: FloatingActionButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('FAB Pressed!')),
                              );
                            },
                            backgroundColor: MyColors.primaryShade800,
                            foregroundColor: MyColors.light,
                            elevation: 0,
                            shape: const CircleBorder(),
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedSparkles,
                              color: MyColors.light,
                              size: MySizes.iconMedium(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

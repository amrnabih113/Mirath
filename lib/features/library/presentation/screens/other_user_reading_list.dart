import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/features/profile/presentation/widgets/profile_reading_list_card.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../../../common/widgets/tag_chip.dart';

class OtherUserReadingList extends StatelessWidget {
  const OtherUserReadingList({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: ResponsiveHelper.responsiveValue(context, 50),
        leadingWidth: ResponsiveHelper.responsiveValue(context, 50),
        leading: const MyBackIcon(),
        titleSpacing: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: MySizes.spaceSm(context)),
            child: IconButton(
              onPressed: () {},
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedMoreHorizontal,
                size: MySizes.iconMedium(context),
                strokeWidth: ResponsiveHelper.responsiveValue(context, 2),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Padding(
                padding: MySizes.paddingMd(context),
                child: SafeArea(
                  bottom: false,
                  child: CustomScrollView(
                    slivers: [
                      /// USER HEADER
                      SliverToBoxAdapter(
                        child: Row(
                          children: [
                            SizedBox(width: MySizes.spaceSm(context)),
                            CircleAvatar(
                              radius: MySizes.borderRadiusLg(context) * 2,
                              backgroundColor: MyColors.primaryShade50,
                              child: SvgPicture.asset(
                                'assets/images/Profile picture (1).svg',
                              ),
                            ),
                            SizedBox(width: MySizes.spaceSm(context)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'John Doe',
                                    style: context.titleSmall.copyWith(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(
                                    height: MySizes.spaceXs(context) * 0.5,
                                  ),
                                  Text(
                                    '3 papers • 5 saves • Updated 2 days ago',
                                    style: context.bodySmall.copyWith(
                                      color: MyColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            HugeIcon(icon: HugeIcons.strokeRoundedGlobal),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceMd(context)),
                      ),

                      /// TITLE
                      SliverToBoxAdapter(
                        child: Text(
                          'Introduction to CNN',
                          style: context.titleSmall.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceSm(context)),
                      ),

                      /// DESCRIPTION
                      SliverToBoxAdapter(
                        child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nisl eget ultricies lacinia.',
                          style: context.bodyMedium.copyWith(
                            color: MyColors.textSecondary,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceSm(context)),
                      ),

                      /// TAGS
                      SliverToBoxAdapter(
                        child: Wrap(
                          children: [
                            TagChip(label: 'Artificial Intelligence'),
                            SizedBox(width: MySizes.spaceXs(context) * .5),
                            TagChip(label: 'CNN'),
                            SizedBox(width: MySizes.spaceLg(context) * 5),
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedMoreHorizontal,
                            ),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceMd(context)),
                      ),

                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MySizes.spaceMd(context),
                            ),
                            child: ProfileReadingListCard(),
                          );
                        }, childCount: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

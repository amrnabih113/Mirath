import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_formaters.dart';

import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/profile_avatar.dart';
import 'follow_button.dart';
import 'interaction_button.dart';
import 'tag_chip.dart';

class DiscussionCard extends StatelessWidget {
  const DiscussionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MySizes.paddingMd(context),
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(MySizes.borderRadiusMd(context)),
        border: Border.all(color: MyColors.primaryShade500),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ProfileAvatar(
                size: ResponsiveHelper.responsiveValue(context, 40),
              ),
              SizedBox(width: MySizes.spaceSm(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Jane Doe',
                          style: context.titleSmall.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: MySizes.spaceXs(context)),
                        const FollowButton(),
                      ],
                    ),
                    SizedBox(height: MySizes.spaceXs(context) * 0.5),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur...',
                      style: context.bodySmall.copyWith(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedMoreHorizontal,
                  size: MySizes.iconMedium(context),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          SizedBox(height: MySizes.spaceMd(context)),
          Text(
            'Quantum Computing and Cybersecurity',
            style: context.titleLarge.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: MySizes.spaceSm(context)),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque ante dui, lobortis sed orci vitae, molestie convallis justo. Fusce efficitur...',
            style: context.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: MySizes.spaceMd(context)),
          Container(
            padding: MySizes.paddingSm(context),
            decoration: BoxDecoration(
              color: MyColors.primaryShade50,
              borderRadius: BorderRadius.circular(
                MySizes.borderRadiusSm(context),
              ),
              border: Border.all(color: MyColors.primaryShade400),
            ),
            child: Row(
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedFile02,
                  size: MySizes.iconLarge(context),
                  color: MyColors.textSecondary,
                ),
                SizedBox(width: MySizes.spaceSm(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What does it take to solve the...',
                        style: context.titleSmall.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: MySizes.spaceXs(context) * 0.5),
                      Text(
                        'Jonte R Hance and Sabine Hossenfelder',
                        style: context.bodySmall.copyWith(
                          color: MyColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MySizes.spaceMd(context)),
          Wrap(
            spacing: MySizes.spaceXs(context),
            children: const [
              TagChip(label: 'Quantum Computing'),
              TagChip(label: 'Cybersecurity'),
            ],
          ),
          SizedBox(height: MySizes.spaceMd(context)),
          Row(
            children: [
              Text(
                MyFormaters.relativeTime(
                  DateTime.now().subtract(const Duration(hours: 5)),
                ),
                style: context.bodySmall.copyWith(
                  color: MyColors.textSecondary,
                ),
              ),
              const Spacer(),
              const InteractionButton(
                icon: HugeIcons.strokeRoundedArrowUp01,
                count: 123,
              ),
              SizedBox(width: MySizes.spaceSm(context)),
              const InteractionButton(
                icon: HugeIcons.strokeRoundedArrowDown01,
                count: 3,
              ),
              SizedBox(width: MySizes.spaceSm(context)),
              const InteractionButton(
                icon: HugeIcons.strokeRoundedComment01,
                count: 20,
              ),
              SizedBox(width: MySizes.spaceSm(context)),
              IconButton(
                onPressed: () {},
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedShare08,
                  size: MySizes.iconMedium(context),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

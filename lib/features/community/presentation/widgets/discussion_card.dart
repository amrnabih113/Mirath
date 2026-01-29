import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_formaters.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/profile_avatar.dart';
import 'follow_button.dart';
import 'interaction_button.dart';
import 'tag_chip.dart';

class DiscussionCard extends StatefulWidget {
  const DiscussionCard({super.key});

  @override
  State<DiscussionCard> createState() => _DiscussionCardState();
}

class _DiscussionCardState extends State<DiscussionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
        child: Container(
          padding: MySizes.paddingMd(context),
          decoration: BoxDecoration(
            color: MyColors.white,

            borderRadius: BorderRadius.circular(
              ResponsiveHelper.responsiveValue(context, 18),
            ),
            border: Border.all(
              color: MyColors.primaryShade200.withValues(alpha: 0.4),
              width: ResponsiveHelper.responsiveValue(context, 1.5),
            ),
            boxShadow: [
              BoxShadow(
                color: MyColors.primaryShade500.withValues(
                  alpha: _isHovered ? 0.12 : 0.08,
                ),
                blurRadius: _isHovered ? 24 : 18,
                offset: Offset(0, _isHovered ? 8 : 5),
                spreadRadius: -3,
              ),
              BoxShadow(
                color: MyColors.primaryShade900.withValues(alpha: 0.03),
                blurRadius: ResponsiveHelper.responsiveValue(context, 10),
                offset: Offset(0, ResponsiveHelper.responsiveValue(context, 2)),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInformationHeader(),
              SizedBox(height: MySizes.spaceMd(context)),
              Text(
                'Quantum Computing and Cybersecurity',
                style: context.titleLarge.copyWith(
                  fontWeight: FontWeight.w900,
                  fontFamily: GoogleFonts.sourceSerif4().fontFamily,
                  letterSpacing: -0.5,
                  height: 1.3,
                  color: MyColors.primaryShade900,
                ),
              ),
              SizedBox(height: MySizes.spaceSm(context) * 1.2),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque ante dui, lobortis sed orci vitae, molestie convallis justo. Fusce efficitur...',
                style: context.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: MySizes.spaceMd(context)),
              DisscussionPaperCard(),
              SizedBox(height: MySizes.spaceMd(context)),
              Wrap(
                spacing: MySizes.spaceXs(context),
                children: const [
                  TagChip(label: 'Quantum Computing'),
                  TagChip(label: 'Cybersecurity'),
                ],
              ),
              SizedBox(height: MySizes.spaceMd(context)),
              DisscusionActionButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

class DisscusionActionButtons extends StatelessWidget {
  const DisscusionActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          MyFormaters.relativeTime(
            DateTime.now().subtract(const Duration(hours: 5)),
          ),
          style: context.bodySmall.copyWith(color: MyColors.textSecondary),
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
    );
  }
}

class DisscussionPaperCard extends StatelessWidget {
  const DisscussionPaperCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MySizes.paddingSm(context),
      decoration: BoxDecoration(
        color: MyColors.primaryShade50,
        borderRadius: BorderRadius.circular(MySizes.borderRadiusSm(context)),
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
    );
  }
}

class UserInformationHeader extends StatelessWidget {
  const UserInformationHeader({super.key, this.showMoreButton = true});
  final bool showMoreButton;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileAvatar(size: ResponsiveHelper.responsiveValue(context, 40)),
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
        if (showMoreButton)
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
    );
  }
}

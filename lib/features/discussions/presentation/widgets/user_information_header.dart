import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/profile_avatar.dart';
import '../../domain/entities/discussion.dart';
import 'follow_button.dart';

class UserInformationHeader extends StatelessWidget {
  final Discussion discussion;
  final bool showMoreButton;

  const UserInformationHeader({
    super.key,
    required this.discussion,
    this.showMoreButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileAvatar(
          imageUrl: discussion.author.photoUrl,
          size: ResponsiveHelper.responsiveValue(
            context,
            ResponsiveHelper.deviceTypeFromContext(context) != DeviceType.phone
                ? 25
                : 40,
          ),
        ),
        SizedBox(width: MySizes.spaceSm(context)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ResponsiveHelper.responsiveValue(context, 120),
                    ),
                    child: Text(
                      discussion.author.fullName,
                      style: context.titleSmall.copyWith(
                        fontWeight: FontWeight.w900,
                        overflow: TextOverflow.ellipsis,

                        fontSize: ResponsiveHelper.responsiveValue(context, 14),
                      ),
                    ),
                  ),
                  SizedBox(width: MySizes.spaceXs(context)),
                  const FollowButton(),
                ],
              ),
              SizedBox(height: MySizes.spaceXs(context) * 0.5),
              Text(
                discussion.author.bio ?? '@${discussion.author.username}',
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

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_enums.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/custum_text_button.dart';
import 'package:mirath/features/common/widgets/info_row.dart';
import 'package:mirath/features/common/widgets/tag_chip.dart';
import 'package:mirath/features/users/domain/entities/user.dart';

class UserData extends StatelessWidget {
  const UserData({
    super.key,
    required this.user,
    required this.actionLabel,
    required this.color,
    required this.labelColor,
    required this.onActionTap,
    required this.onFollowersTap,
  });
  final User user;
  final String actionLabel;
  final Color color;
  final Color labelColor;
  final VoidCallback onActionTap;
  final VoidCallback onFollowersTap;

  ImageProvider? _avatarImage() {
    if (user.photoUrl == null || user.photoUrl!.isEmpty) {
      return null;
    }
    return NetworkImage(user.photoUrl!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MySizes.paddingMd(context),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: MySizes.borderRadiusLg(context) * 2,
                backgroundColor: MyColors.primaryShade50,
                backgroundImage: _avatarImage(),
                child: _avatarImage() == null
                    ? SvgPicture.asset('assets/images/Profile picture (1).svg')
                    : null,
              ),
              SizedBox(width: MySizes.spaceSm(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(user.fullName, style: context.titleSmall),
                        if (!user.isEmailVisible)
                          Padding(
                            padding: EdgeInsets.only(
                              left: MySizes.spaceXs(context) * .5,
                            ),
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedSquareLock02,
                              size: MySizes.iconSmall(context),
                              color: MyColors.primaryShade500,
                            ),
                          ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '@${user.username}',
                          style: context.bodySmall.copyWith(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: MySizes.spaceXs(context) * .5),
                        GestureDetector(
                          onTap: onFollowersTap,
                          child: Text(
                            ' ${user.followersCount} Followers • ${user.followingCount} Following',
                            style: context.bodySmall.copyWith(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: MySizes.spaceXl(context)),
              CustumTextButton(
                onTap: onActionTap,
                label: actionLabel,
                color: color,
                labelColor: labelColor,
              ),
            ],
          ),
          SizedBox(height: MySizes.spaceSm(context)),
          Text(
            user.bio?.isNotEmpty == true ? user.bio! : 'No bio provided.',
            style: context.bodySmall.copyWith(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
          SizedBox(height: MySizes.spaceXs(context)),
          InfoRow(
            icon: HugeIcons.strokeRoundedMortarboard01,
            text: user.levelOfEducation == EducationLevel.highSchool.serverValue
                ? 'High School Student'
                : user.levelOfEducation ==
                      EducationLevel.underGraduate.serverValue
                ? 'Bachelor\'s Degree at ${user.university}'
                : user.levelOfEducation == EducationLevel.graduated.serverValue
                ? 'Graduated From ${user.university}'
                : 'Not specified',
          ),
          SizedBox(height: MySizes.spaceXs(context) * 0.5),
          if (user.country != null && user.country!.isNotEmpty)
            InfoRow(
              icon: HugeIcons.strokeRoundedPinLocation02,
              text: user.country!,
            ),
          SizedBox(height: MySizes.spaceXs(context) * 0.5),
          InfoRow(icon: HugeIcons.strokeRoundedMail01, text: user.email),
          SizedBox(height: MySizes.spaceXs(context)),
          SizedBox(
            height: MySizes.spaceXl(context),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return TagChip(label: user.interests[index].name);
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(width: MySizes.spaceXs(context) * .5);
              },
              itemCount: user.interests.isEmpty ? 0 : user.interests.length,
            ),
          ),
        ],
      ),
    );
  }
}

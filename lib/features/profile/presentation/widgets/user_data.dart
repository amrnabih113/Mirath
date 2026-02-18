import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/custum_text_button.dart';
import 'package:mirath/features/common/widgets/info_row.dart';
import 'package:mirath/features/common/widgets/tag_chip.dart';

class UserData extends StatelessWidget {
  const UserData({
    super.key,
    required this.label,
    required this.color,
    required this.labelColor,
  });
  final String label;
  final Color color;
  final Color labelColor;

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
                child: SvgPicture.asset(
                  'assets/images/Profile picture (1).svg',
                ),
              ),
              SizedBox(width: MySizes.spaceSm(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('John Doe', style: context.titleSmall),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '@username',
                          style: context.bodySmall.copyWith(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: MySizes.spaceXs(context) * .5),
                        GestureDetector(
                          onTap: () =>
                              context.push('/follower_following_screen'),
                          child: Text(
                            ' 123 Followers • 456 Following',
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
                onTap: () {
                  context.push('/edit_profile_screen');
                },
                label: label,
                color: color,
                labelColor: labelColor,
              ),
            ],
          ),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque ante dui, lobortis sed orci vitae, molestie convallis justo. Fusce...more',
            style: context.bodySmall.copyWith(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
          SizedBox(height: MySizes.spaceXs(context)),
          InfoRow(
            icon: HugeIcons.strokeRoundedMortarboard01,
            text: 'Undergraduate student at Mansoura University',
          ),
          SizedBox(height: MySizes.spaceXs(context) * 0.5),
          InfoRow(
            icon: HugeIcons.strokeRoundedBriefcase06,
            text: 'Junior Researcher',
          ),
          SizedBox(height: MySizes.spaceXs(context) * 0.5),
          InfoRow(icon: HugeIcons.strokeRoundedPinLocation02, text: 'Egypt'),
          SizedBox(height: MySizes.spaceXs(context) * 0.5),
          InfoRow(
            icon: HugeIcons.strokeRoundedMail01,
            text: 'johndoe@gmail.com',
          ),
          SizedBox(height: MySizes.spaceXs(context)),
          SizedBox(
            height: MySizes.spaceXl(context),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return TagChip(label: 'Physics');
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(width: MySizes.spaceXs(context) * .5);
              },
              itemCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}

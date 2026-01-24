import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/community/presentation/widgets/tag_chip.dart';

class ReadingListCard extends StatelessWidget {
  const ReadingListCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MySizes.paddingMd(context),
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(MySizes.borderRadiusMd(context)),
        border: Border.all(color: MyColors.primaryShade500, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jane Doe',
                      style: context.titleSmall.copyWith(
                        color: MyColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: MySizes.spaceXs(context)),
                    Text(
                      'Introduction to CNN',
                      style: context.titleLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        color: MyColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: MySizes.spaceSm(context)),
                    Text(
                      '8 papers • Updated 2 days ago',
                      style: context.bodyLarge.copyWith(
                        color: MyColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedBookmark02,
                  size: MySizes.iconMedium(context),
                  color: MyColors.textPrimary,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          SizedBox(height: MySizes.spaceSm(context)),
          Divider(
            color: MyColors.primaryShade300,
            thickness: 1,
            height: MySizes.spaceMd(context),
          ),
          Text(
            'Lorem Ipsum is simply dummy text of the printing and...',
            style: context.bodyLarge.copyWith(color: MyColors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: MySizes.spaceSm(context)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Wrap(
                  spacing: MySizes.spaceXs(context),
                  runSpacing: MySizes.spaceXs(context) * 0.5,
                  children: const [
                    TagChip(label: 'Artificial Intelligence'),
                    TagChip(label: 'CNN'),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedShare08,
                  size: MySizes.iconMedium(context),
                  color: MyColors.textPrimary,
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

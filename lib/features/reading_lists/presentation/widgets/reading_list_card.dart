import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/tag_chip.dart';
import '../../domain/entities/reading_list.dart';

class ReadingListCard extends StatelessWidget {
  final ReadingList readingList;
  final VoidCallback? onTap;

  const ReadingListCard({super.key, required this.readingList, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: MySizes.paddingMd(context),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.responsiveValue(context, 20),
          ),
          border: Border.all(
            color: MyColors.primaryShade400.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: MyColors.primaryShade600.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: -4,
            ),
            BoxShadow(
              color: MyColors.primaryShade400.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: MyColors.white.withValues(alpha: 0.8),
              blurRadius: 2,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: .center,
              children: [
                readingList.owner?.fullName == null
                    ? const SizedBox.shrink()
                    : Text(
                        readingList.owner!.fullName,
                        style: context.titleSmall.copyWith(
                          fontSize: ResponsiveHelper.responsiveValue(
                            context,
                            12,
                          ),
                        ),

                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                HugeIcon(
                  icon: readingList.isPublic
                      ? HugeIcons.strokeRoundedGlobal
                      : HugeIcons.strokeRoundedLocked,
                  size: MySizes.iconSmall(context),
                  color: MyColors.primaryShade700,
                ),
              ],
            ),
            Text(
              readingList.title,
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: ResponsiveHelper.responsiveValue(context, 16),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: MySizes.spaceXs(context) * 0.75),
            Text(
              '${readingList.paperCount} papers  •  Updated ${_formatDate(readingList.updatedAt)}',
              style: context.bodySmall,
            ),
            Divider(
              color: MyColors.primaryShade300,
              thickness: 1,
              height: MySizes.spaceMd(context),
            ),

            Row(
              children: [
                if (readingList.description != null &&
                    readingList.description!.trim().isNotEmpty)
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ResponsiveHelper.responsiveValue(context, 230),
                    ),
                    child: Text(
                      readingList.description!,
                      style: context.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedShare08,
                    size: MySizes.iconSmall(context),
                    color: MyColors.primaryShade700,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            if (readingList.description != null &&
                readingList.description!.trim().isNotEmpty)
              SizedBox(height: MySizes.spaceSm(context)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (readingList.previewTags.isNotEmpty)
                  Expanded(
                    child: SizedBox(
                      height: ResponsiveHelper.responsiveValue(context, 28),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: readingList.previewTags.length,
                        separatorBuilder: (_, _) =>
                            SizedBox(width: MySizes.spaceXs(context)),
                        itemBuilder: (_, index) =>
                            TagChip(label: readingList.previewTags[index]),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return '1 day ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    }

    final months = (difference.inDays / 30).floor();
    return '$months month${months > 1 ? 's' : ''} ago';
  }
}

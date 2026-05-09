import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/library/domain/entities/library_data.dart';
import 'package:mirath/features/library/presentation/widgets/lib_item.dart';

class MyItem extends StatelessWidget {
  const MyItem({super.key, required this.data});
  final LibraryData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: MySizes.paddingMd(context),
      padding: EdgeInsets.symmetric(horizontal: MySizes.spaceLg(context) * 1.5),
      height: ResponsiveHelper.responsiveValue(context, 122),
      decoration: BoxDecoration(
        color: Color(0xffE3D9CD).withAlpha((255 * .5).toInt()),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.responsiveValue(context, 12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: LibItem(
              onTap: () {
                // Handle tap event
              },
              icon: HugeIcons.strokeRoundedFile02,
              title: '${data.listsCount}',
              subtitle: 'Lists',
            ),
          ),
          Expanded(
            child: LibItem(
              onTap: () {
                // Handle tap event
              },
              icon: HugeIcons.strokeRoundedFileEdit,
              title: '${data.createdCount}',
              subtitle: 'created',
            ),
          ),
          Expanded(
            child: LibItem(
              onTap: () {
                // Handle tap event
              },
              icon: HugeIcons.strokeRoundedFileBookmark,
              title: '${data.savedCount}',
              subtitle: 'Saved',
            ),
          ),
          Expanded(
            child: LibItem(
              onTap: () {
                // Handle tap event
              },
              icon: HugeIcons.strokeRoundedFolder02,
              title: '${data.projectsCount}',
              subtitle: 'Projects',
            ),
          ),
        ],
      ),
    );
  }
}

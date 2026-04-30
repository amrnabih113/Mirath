import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/generated/l10n.dart';

class LibTiles extends StatelessWidget {
  const LibTiles({super.key, required this.title, required this.onTap});
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: MyColors.primaryShade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      style: ListTileStyle.list,
      title: Text(title),

      trailing: GestureDetector(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(S.of(context).view_all_button),
            HugeIcon(
              icon: HugeIcons.strokeRoundedArrowRight01,
              size: MySizes.iconMedium(context),
            ),
          ],
        ),
      ),
    );
  }
}

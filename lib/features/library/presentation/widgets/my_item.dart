import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/generated/l10n.dart';

class MyItem extends StatelessWidget {
  const MyItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: MySizes.paddingMd(context),
      padding: EdgeInsets.symmetric(horizontal: MySizes.spaceLg(context) * 1.5),
      height: 122,
      width: 358,
      decoration: BoxDecoration(
        color: Color(0xffE3D9CD).withAlpha((255 * .5).toInt()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HugeIcon(icon: HugeIcons.strokeRoundedFile02),
              SizedBox(height: MySizes.spaceSm(context) * .5),
              Text(S.of(context).placeholder_lists_count),
              SizedBox(height: MySizes.spaceSm(context) * .5),
              Text(S.of(context).lists_label),
            ],
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HugeIcon(icon: HugeIcons.strokeRoundedFileEdit),
              SizedBox(height: MySizes.spaceSm(context) * .5),
              Text(S.of(context).placeholder_created_count),
              SizedBox(height: MySizes.spaceSm(context) * .5),
              Text(S.of(context).created_label),
            ],
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HugeIcon(icon: HugeIcons.strokeRoundedFileBookmark),
              SizedBox(height: MySizes.spaceSm(context) * .5),
              Text(S.of(context).placeholder_saved_count),
              SizedBox(height: MySizes.spaceSm(context) * .5),
              Text(S.of(context).saved_label),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HugeIcon(icon: HugeIcons.strokeRoundedFolder02),
              SizedBox(height: MySizes.spaceSm(context) * .5),
              Text(S.of(context).placeholder_projects_count),
              SizedBox(height: MySizes.spaceSm(context) * .5),
              Text(S.of(context).projects_label),
            ],
          ),
        ],
      ),
    );
  }
}

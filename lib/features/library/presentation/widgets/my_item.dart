import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_sizes.dart';

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
              Text('35'),
              SizedBox(height: MySizes.spaceSm(context) * .5),
              Text('Lists'),
            ],
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HugeIcon(icon: HugeIcons.strokeRoundedFileEdit),
              SizedBox(height: MySizes.spaceSm(context) * .5),
              Text('10'),
              SizedBox(height: MySizes.spaceSm(context) * .5),
              Text('created'),
            ],
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HugeIcon(icon: HugeIcons.strokeRoundedFileBookmark),
              SizedBox(height: MySizes.spaceSm(context) * .5),
              Text('25'),
              SizedBox(height: MySizes.spaceSm(context) * .5),
              Text('Saved'),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HugeIcon(icon: HugeIcons.strokeRoundedFolder02),
              SizedBox(height: MySizes.spaceSm(context) * .5),
              Text('2'),
              SizedBox(height: MySizes.spaceSm(context) * .5),
              Text('Projects'),
            ],
          ),
        ],
      ),
    );
  }
}

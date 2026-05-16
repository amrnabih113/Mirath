import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/utils/my_sizes.dart';

class LibItem extends StatelessWidget {
  const LibItem({
    super.key,
    this.onTap,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final VoidCallback? onTap;
  final List<List<dynamic>> icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HugeIcon(icon: icon),
          SizedBox(height: MySizes.spaceSm(context) * .5),
          Text(title),
          SizedBox(height: MySizes.spaceSm(context) * .5),
          Text(subtitle),
        ],
      ),
    );
  }
}

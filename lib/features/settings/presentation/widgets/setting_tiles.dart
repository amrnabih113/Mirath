import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';

class SettingTiles extends StatelessWidget {
  const SettingTiles({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final List<List<dynamic>> icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: HugeIcon(icon: icon, size: MySizes.iconMedium(context)),
      title: Text(
        title,
        style: context.bodyLarge.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: context.bodySmall.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

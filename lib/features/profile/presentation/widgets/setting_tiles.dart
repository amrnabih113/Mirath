import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class SettingTiles extends StatelessWidget {
  const SettingTiles({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });
  final List<List<dynamic>> icon;
  final String text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: HugeIcon(icon: icon, size: MySizes.iconMedium(context)),
      title: Text(
        text,
        style: context.bodyLarge.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

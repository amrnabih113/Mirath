import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/utils/my_extenstions.dart';
import '../../../core/utils/my_sizes.dart';

class InfoRow extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String text;

  const InfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: HugeIcon(
              icon: icon,
              size: MySizes.iconSmall(context) * 0.75,
            ),
          ),
          WidgetSpan(child: SizedBox(width: MySizes.spaceXs(context) * 0.5)),
          TextSpan(
            text: text,
            style: context.bodySmall.copyWith(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

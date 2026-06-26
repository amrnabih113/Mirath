import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class SpecialText extends StatelessWidget {
  const SpecialText({
    super.key,
    this.text,
    required this.addText,
    this.backColor,
    this.style,
  });
  final String? text;
  final String addText;
  final Color? backColor;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: text, style: style),

          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              padding: MySizes.paddingSm(context) * .5,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: backColor ?? MyColors.primaryShade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                addText,
                style: context.bodyLarge.copyWith(
                  color: MyColors.primaryShade900,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

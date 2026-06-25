import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/settings/presentation/widgets/setting_text_field.dart';

class ChangeUserCard extends StatelessWidget {
  const ChangeUserCard({
    super.key,
    required this.label,
    required this.hintText,
    required this.btnName,
    required this.controller,
    required this.onPressed,
  });
  final String label;
  final String hintText;
  final String btnName;
  final TextEditingController controller;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MySizes.paddingLg(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: context.bodyLarge.copyWith(fontSize: 24)),
          SizedBox(height: MySizes.spaceXl(context)),
          SettingsTextField(controller: controller, hintText: hintText),
          SizedBox(height: MySizes.spaceXl(context)),
          TextButton(
            onPressed: controller.text.isEmpty ? null : onPressed,
            style: TextButton.styleFrom(
              backgroundColor: controller.text.isEmpty
                  ? MyColors.primaryShade800.withAlpha((255 * 0.5).toInt())
                  : MyColors.primaryShade800,
            ),
            child: Text(
              btnName,
              style: context.bodyLarge.copyWith(color: MyColors.white),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/utils/my_extenstions.dart';
import '../../../core/utils/my_sizes.dart';

class TextFeildWithLable extends StatelessWidget {
  const TextFeildWithLable({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.readOnly = false,
  });
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.bodyLarge, textAlign: TextAlign.left),
        SizedBox(height: MySizes.spaceXs(context)),
        TextField(
          readOnly: readOnly,
          controller: controller,
          decoration: InputDecoration(hintText: hintText),
        ),
      ],
    );
  }
}

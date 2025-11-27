import 'package:flutter/material.dart';

import '../../utils/my_colors.dart';

class MyChipTheme {
  MyChipTheme._();

  static final lightChipTheme = ChipThemeData(
    disabledColor: Colors.grey.withValues(alpha: 0.4),
    labelStyle: const TextStyle(color: MyColors.textPrimary),
    selectedColor: MyColors.primaryColor,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    checkmarkColor: Colors.white,
  );

  static final darkChipTheme = ChipThemeData(
    disabledColor: Colors.grey.withValues(alpha: 0.4),
    labelStyle: const TextStyle(color: MyColors.textPrimaryDark),
    selectedColor: MyColors.primaryColor,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    checkmarkColor: MyColors.textPrimaryDark,
  );
}

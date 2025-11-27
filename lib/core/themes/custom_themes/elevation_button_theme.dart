import 'package:flutter/material.dart';

import '../../utils/my_colors.dart';

class MyElevationButtonTheme {
  MyElevationButtonTheme._();

  static final lightelevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shadowColor: MyColors.primaryColor.withAlpha(128),
      foregroundColor: Colors.white,
      backgroundColor: MyColors.primaryColor,
      disabledBackgroundColor: Colors.grey,
      disabledForegroundColor: Colors.grey,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(vertical: 12),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shadowColor: MyColors.primaryColor.withAlpha(128),
      foregroundColor: Colors.white,
      backgroundColor: MyColors.primaryColor,
      disabledBackgroundColor: MyColors.primaryShade300,
      disabledForegroundColor: Colors.grey,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(vertical: 12),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
  );
}

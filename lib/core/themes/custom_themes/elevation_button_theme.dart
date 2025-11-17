import 'package:flutter/material.dart';

import '../../utils/my_colors.dart';

class MyElevationButtonTheme {
  MyElevationButtonTheme._();

  static final lightelevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    elevation: 0,
    foregroundColor: Colors.white,
    backgroundColor: MyColors.primaryColor,
    disabledBackgroundColor: Colors.grey,
    disabledForegroundColor: Colors.grey,
    side: BorderSide.none,
    padding: const EdgeInsets.symmetric(vertical: 18),
    textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: MyColors.dark,
        fontFamily: 'Poppins'),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(60))),
  ));

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: MyColors.primaryColor,
      disabledBackgroundColor: Colors.grey,
      disabledForegroundColor: Colors.grey,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(vertical: 18),
      textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: MyColors.dark,
          fontFamily: 'Poppins'),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(60))),
    ),
  );
}

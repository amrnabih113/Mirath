import 'package:flutter/material.dart';

import '../../utils/my_colors.dart';

class MyAppBarTheme {
  MyAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: MyColors.textPrimary, size: 24),
    actionsIconTheme: IconThemeData(color: MyColors.textPrimary, size: 24),
    titleTextStyle: TextStyle(color: MyColors.textPrimary, fontSize: 24),
  );

  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: MyColors.textPrimaryDark, size: 24),
    actionsIconTheme: IconThemeData(color: MyColors.textPrimaryDark, size: 24),
    titleTextStyle: TextStyle(color: MyColors.textPrimaryDark, fontSize: 24),
  );
}

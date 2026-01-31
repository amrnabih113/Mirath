import 'package:flutter/material.dart';

import '../../utils/my_colors.dart';

class MySwitchTheme {
  MySwitchTheme._();

  static SwitchThemeData lightSwitchTheme = SwitchThemeData(
    trackColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected)
          ? MyColors.primaryShade700
          : MyColors.primaryShade200,
    ),
    thumbColor: WidgetStateProperty.resolveWith((states) => MyColors.white),
    overlayColor: WidgetStateProperty.all(
      MyColors.primaryShade200.withValues(alpha: 0.2),
    ),
  );

  static SwitchThemeData darkSwitchTheme = SwitchThemeData(
    trackColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected)
          ? MyColors.primaryShade700
          : MyColors.primaryShade600,
    ),
    thumbColor: WidgetStateProperty.resolveWith((states) => MyColors.white),
    overlayColor: WidgetStateProperty.all(
      MyColors.primaryShade700.withValues(alpha: 0.2),
    ),
  );
}

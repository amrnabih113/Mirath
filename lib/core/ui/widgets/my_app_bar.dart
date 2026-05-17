import 'package:flutter/material.dart';

import '../../helpers/responsive_helper.dart';

/// A consistent app bar that constrains width like the project layout.
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.centerTitle,
    this.maxWidth = 850,
    this.height,
    this.backgroundColor,
    this.elevation,
    this.automaticallyImplyLeading,
  });

  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;
  final bool? centerTitle;
  final double maxWidth;
  final double? height;
  final Color? backgroundColor;
  final double? elevation;
  final bool? automaticallyImplyLeading;

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final computedHeight =
        height ?? ResponsiveHelper.responsiveValue(context, 40);

    return PreferredSize(
      preferredSize: Size.fromHeight(computedHeight),
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: AppBar(
                leading: leading,
                title: title,
                actions: actions,
                centerTitle: centerTitle,
                backgroundColor: backgroundColor,
                elevation: elevation,
                automaticallyImplyLeading: automaticallyImplyLeading ?? true,
              ),
            );
          },
        ),
      ),
    );
  }
}

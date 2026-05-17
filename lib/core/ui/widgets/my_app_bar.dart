import 'package:flutter/material.dart';

import '../../helpers/responsive_helper.dart';

/// A consistent app bar that constrains width like the project layout.
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.leadingWidth,
    this.titleSpacing,
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
  final double? leadingWidth;
  final double? titleSpacing;
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
        height ?? ResponsiveHelper.responsiveValue(context, 50);

    return PreferredSize(
      preferredSize: Size.fromHeight(computedHeight),
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: AppBar(
                leading: leading,
                leadingWidth: leadingWidth,
                title: title,
                titleSpacing: titleSpacing,
                actions: actions,
                toolbarHeight: computedHeight,
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

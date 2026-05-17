import 'package:flutter/material.dart';

import '../../utils/my_sizes.dart';

/// Wrapper that centers content and constrains max width to match app layout.
class MyBody extends StatelessWidget {
  const MyBody({
    super.key,
    required this.child,
    this.maxWidth = 850,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: padding ?? MySizes.paddingMd(context),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

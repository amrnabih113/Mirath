import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_sizes.dart';

class ExpandableFAB extends StatefulWidget {
  final VoidCallback onAddTag;
  final VoidCallback onAddPaper;

  const ExpandableFAB({
    super.key,
    required this.onAddTag,
    required this.onAddPaper,
  });

  @override
  State<ExpandableFAB> createState() => _ExpandableFABState();
}

class _ExpandableFABState extends State<ExpandableFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotateAnimation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 0.75,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _toggle() {
    if (_isExpanded) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() => _isExpanded = !_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = MySizes.spaceMd(context);

    return SizedBox(
      width: 160,
      height: 220,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          /// Add Tag
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            right: spacing + ResponsiveHelper.responsiveValue(context, 4.0),
            bottom: _isExpanded ? 80 : 16,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: _isExpanded ? 1 : 0,
              child: FloatingActionButton(
                mini: true,
                heroTag: 'tag-fab',
                backgroundColor: MyColors.primaryColor.withValues(alpha: 0.85),
                onPressed: widget.onAddTag,
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedTag01,
                  color: Colors.white,
                  size: ResponsiveHelper.responsiveValue(context, 20.0),
                ),
              ),
            ),
          ),

          /// Add Paper
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            right: spacing + ResponsiveHelper.responsiveValue(context, 4.0),
            bottom: _isExpanded ? 136 : 16,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: _isExpanded ? 1 : 0,
              child: FloatingActionButton(
                mini: true,
                heroTag: 'paper-fab',
                backgroundColor: MyColors.primaryColor.withValues(alpha: 0.85),
                onPressed: widget.onAddPaper,
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedFile02,
                  color: Colors.white,
                  size: ResponsiveHelper.responsiveValue(context, 20.0),
                ),
              ),
            ),
          ),

          /// Main FAB
          Positioned(
            bottom: 16,
            right: spacing,
            child: FloatingActionButton(
              heroTag: 'main-fab',
              backgroundColor: MyColors.primaryShade700,
              onPressed: _toggle,
              child: RotationTransition(
                turns: _rotateAnimation,
                child: HugeIcon(
                  icon: _isExpanded
                      ? HugeIcons.strokeRoundedCancel01
                      : HugeIcons.strokeRoundedAdd01,
                  color: Colors.white,
                  size: ResponsiveHelper.responsiveValue(context, 28.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

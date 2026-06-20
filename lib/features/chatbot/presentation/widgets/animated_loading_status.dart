import 'package:flutter/material.dart';

import '../../../../core/utils/my_colors.dart';

class AnimatedLoadingStatus extends StatefulWidget {
  final String status;
  final TextStyle style;

  const AnimatedLoadingStatus({
    super.key,
    required this.status,
    required this.style,
  });

  @override
  State<AnimatedLoadingStatus> createState() => _AnimatedLoadingStatusState();
}

class _AnimatedLoadingStatusState extends State<AnimatedLoadingStatus>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: FadeTransition(
        key: ValueKey<String>(widget.status),
        opacity: _opacityAnimation,
        child: Container(
          decoration: BoxDecoration(
           
          ),
          child: Text(
            widget.status,
            style: widget.style.copyWith(
              color: MyColors.primaryButton,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                  color: MyColors.primaryButton.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

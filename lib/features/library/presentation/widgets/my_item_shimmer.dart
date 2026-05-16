import 'package:flutter/material.dart';

import '../../../../core/utils/my_sizes.dart';

class MyItemShimmer extends StatefulWidget {
  const MyItemShimmer({super.key});

  @override
  State<MyItemShimmer> createState() => _MyItemShimmerState();
}

class _MyItemShimmerState extends State<MyItemShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _animation = Tween<double>(
      begin: -1.5,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: MySizes.spaceLg(context) * 1.5),
      height: 122,
      width: 358,
      decoration: BoxDecoration(
        color: const Color(0xffE3D9CD).withAlpha((255 * .5).toInt()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          4,
          (_) => _ShimmerLibItem(animation: _animation),
        ),
      ),
    );
  }
}

class _ShimmerLibItem extends StatelessWidget {
  const _ShimmerLibItem({required this.animation});
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon placeholder
            _ShimmerBox(
              width: 28,
              height: 28,
              borderRadius: 6,
              animation: animation,
            ),
            const SizedBox(height: 8),
            // Title placeholder
            _ShimmerBox(
              width: 32,
              height: 14,
              borderRadius: 4,
              animation: animation,
            ),
            const SizedBox(height: 5),
            // Subtitle placeholder
            _ShimmerBox(
              width: 40,
              height: 11,
              borderRadius: 4,
              animation: animation,
            ),
          ],
        );
      },
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.animation,
  });

  final double width;
  final double height;
  final double borderRadius;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: const [
            Color(0xFFD4C9BB),
            Color(0xFFEDE6DC),
            Color(0xFFD4C9BB),
          ],
          stops: [
            (animation.value - 0.5).clamp(0.0, 1.0),
            animation.value.clamp(0.0, 1.0),
            (animation.value + 0.5).clamp(0.0, 1.0),
          ],
        ),
      ),
    );
  }
}

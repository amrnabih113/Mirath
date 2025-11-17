import 'my_helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../utils/my_colors.dart';

class MyLoaders {
  MyLoaders._();

  static void hideSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  static void customToast({
    required BuildContext context,
    required String message,
  }) {
    final isDark = MyHelperFunctions.isDarkMode(context);
    final bgColor = isDark
        ? MyColors.darkerGrey.withValues(alpha: 0.9)
        : MyColors.grey.withValues(alpha: 0.9);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.transparent,
          content: Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: bgColor,
            ),
            child: Center(
              child: Text(
                message,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ),
      );
  }

  static void successSnackBar({
    required BuildContext context,
    required String title,
    String message = '',
    int duration = 3,
  }) {
    _showCustomOverlay(
      context,
      title: title,
      message: message,
      icon: Iconsax.check,
      backgroundColor: MyColors.primaryColor,
      duration: duration,
    );
  }

  static void warningSnackBar({
    required BuildContext context,
    required String title,
    String message = '',
  }) {
    _showCustomOverlay(
      context,
      title: title,
      message: message,
      icon: Iconsax.warning_2,
      backgroundColor: Colors.orange,
    );
  }

  static void errorSnackBar({
    required BuildContext context,
    required String title,
    String message = '',
  }) {
    _showCustomOverlay(
      context,
      title: title,
      message: message,
      icon: Iconsax.warning_2,
      backgroundColor: Colors.red.shade600,
    );
  }

  static void _showCustomOverlay(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
    required Color backgroundColor,
    int duration = 3,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          bottom: 30,
          left: 16,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 200),
              offset: const Offset(0, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: backgroundColor.withValues(alpha: 0.6),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(icon, color: MyColors.white, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: MyColors.white),
                          ),
                          if (message.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              message,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: MyColors.white),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: duration)).then((_) {
      overlayEntry.remove();
    });
  }
}

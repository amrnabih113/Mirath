import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../utils/my_colors.dart';
import 'my_helper_functions.dart';

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
        ? MyColors.darkerGrey.withValues(alpha: 0.85)
        : MyColors.white.withOpacity(0.96);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: bgColor,
              border: Border.all(
                color: MyColors.grey.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    message,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: MyColors.textPrimary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
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
      backgroundColor: MyColors.success,
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
      backgroundColor: MyColors.warning,
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
      backgroundColor: MyColors.error,
    );
  }

  static void _showCustomOverlay(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
    required Color backgroundColor,
    int duration = 2,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 200),
              offset: const Offset(0, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: backgroundColor.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: MyColors.white.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(icon, color: MyColors.white, size: 18),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: MyColors.white, fontWeight: FontWeight.w600),
                          ),
                          if (message.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              message,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: MyColors.white.withOpacity(0.95)),
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

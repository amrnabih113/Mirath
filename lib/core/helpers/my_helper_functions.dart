import 'package:flutter/material.dart';

import '../utils/my_colors.dart';

class MyHelperFunctions {
  static void showSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      duration: duration,
      backgroundColor: isDark
          ? MyColors.darkContainer
          : MyColors.lightContainer,
      content: Text(
        message,
        style: TextStyle(
          color: isDark ? MyColors.textWhite : MyColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      action: (actionLabel != null && onAction != null)
          ? SnackBarAction(
              label: actionLabel,
              textColor: MyColors.primaryColor,
              onPressed: onAction,
            )
          : null,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static Future<T?> showAlertDialog<T>(
    BuildContext context, {
    required String title,
    required String message,
    bool barrierDismissible = true,
    String confirmLabel = 'OK',
    String? cancelLabel,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) {
        return AlertDialog(
          elevation: 6,
          backgroundColor: isDark
              ? MyColors.darkContainer
              : MyColors.lightContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          actionsPadding: const EdgeInsets.only(right: 16, bottom: 10),
          title: Text(
            title,
            style: TextStyle(
              color: isDark ? MyColors.textWhite : MyColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              color: isDark ? MyColors.textWhite : MyColors.textSecondary,
              height: 1.4,
            ),
          ),
          actions: <Widget>[
            if (cancelLabel != null)
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (onCancel != null) onCancel();
                },
                child: Text(
                  cancelLabel,
                  style: TextStyle(
                    color: isDark ? MyColors.textWhite : MyColors.textSecondary,
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                if (onConfirm != null) onConfirm();
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: MyColors.primaryColor,
                foregroundColor: MyColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                confirmLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: MyColors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  static String truncateText(String text, int maxChars, {endWith = '...'}) {
    if (text.length <= maxChars) return text;
    return text.substring(0, maxChars) + endWith;
  }

  static bool isDarkMode(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Size getScreenSize(BuildContext context) =>
      MediaQuery.of(context).size;

  static double getScreenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static List<T> removeDuplicates<T>(List<T> list) => list.toSet().toList();

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrapped = <Widget>[];
    for (int i = 0; i < widgets.length; i += rowSize) {
      wrapped.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widgets
              .sublist(
                i,
                i + rowSize > widgets.length ? widgets.length : i + rowSize,
              )
              .toList(),
        ),
      );
    }
    return wrapped;
  }
}

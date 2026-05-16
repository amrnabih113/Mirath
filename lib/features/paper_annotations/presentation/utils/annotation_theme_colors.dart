import 'package:flutter/material.dart';
import '../../../../core/utils/my_colors.dart';

/// Annotation Theme Colors
/// Provides theme-aware colors for the annotation feature
/// Supports both light and dark modes
class AnnotationThemeColors {
  final Color primaryColor;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final Color highlightOpacity;

  // Highlight color palette (theme-aware)
  final List<Map<String, String>> highlightColors;

  const AnnotationThemeColors({
    required this.primaryColor,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.highlightOpacity,
    required this.highlightColors,
  });

  /// Get light theme colors
  static AnnotationThemeColors light() {
    return AnnotationThemeColors(
      primaryColor: MyColors.black,
      backgroundColor: MyColors.light,
      textColor: MyColors.textPrimary,
      borderColor: MyColors.primaryShade300,
      highlightOpacity: const Color.fromARGB(
        102,
        185,
        160,
        130,
      ), // ~0.4 opacity
      highlightColors: [
        {'name': 'Yellow', 'hex': '#FDE995', 'rgb': 'rgb(253, 233, 149)'},
        {'name': 'Green', 'hex': '#A6E1C5', 'rgb': 'rgb(166, 255, 197)'},
        {'name': 'blue', 'hex': '#A7E0F6', 'rgb': 'rgb(167, 224, 246)'},
        {'name': 'Purple', 'hex': '#E1A7FB', 'rgb': 'rgb(225, 167, 251)'},
        {'name': 'Red', 'hex': '#FF9FAE', 'rgb': 'rgb(255, 159, 174)'},
        {'name': 'Cyan', 'hex': '#9FA5FF', 'rgb': 'rgb(159, 165, 255)'},
      ],
    );
  }

  /// Get dark theme colors
  static AnnotationThemeColors dark() {
    return AnnotationThemeColors(
      primaryColor: MyColors.primaryColor,
      backgroundColor: MyColors.dark,
      textColor: MyColors.textPrimaryDark,
      borderColor: MyColors.primaryShade700,
      highlightOpacity: const Color.fromARGB(102, 185, 160, 130),
      highlightColors: [
          {'name': 'Yellow', 'hex': '#FDE995', 'rgb': 'rgb(253, 233, 149)'},
        {'name': 'Green', 'hex': '#A6E1C5', 'rgb': 'rgb(166, 255, 197)'},
        {'name': 'blue', 'hex': '#A7E0F6', 'rgb': 'rgb(167, 224, 246)'},
        {'name': 'Purple', 'hex': '#E1A7FB', 'rgb': 'rgb(225, 167, 251)'},
        {'name': 'Red', 'hex': '#FF9FAE', 'rgb': 'rgb(255, 159, 174)'},
        {'name': 'Cyan', 'hex': '#9FA5FF', 'rgb': 'rgb(159, 165, 255)'},
      ],
    );
  }

  /// Get colors based on brightness
  static AnnotationThemeColors fromBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? dark() : light();
  }

  /// Convert hex color to RGB string for CSS
  static String hexToRgb(String hex) {
    hex = hex.replaceAll('#', '');
    int r = int.parse(hex.substring(0, 2), radix: 16);
    int g = int.parse(hex.substring(2, 4), radix: 16);
    int b = int.parse(hex.substring(4, 6), radix: 16);
    return 'rgb($r, $g, $b)';
  }

  /// Get color value as hex string
  String colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  /// Get highlight color at index
  Map<String, String>? getHighlightColorAt(int index) {
    if (index >= 0 && index < highlightColors.length) {
      return highlightColors[index];
    }
    return null;
  }

  /// Get all highlight colors as map for JavaScript
  Map<String, dynamic> toJavaScriptMap() {
    return {
      'primaryColor': _colorToHex(primaryColor),
      'backgroundColor': _colorToHex(backgroundColor),
      'textColor': _colorToHex(textColor),
      'borderColor': _colorToHex(borderColor),
      'highlightColors': highlightColors.asMap(),
    };
  }

  /// Convert Color to hex string
  static String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  }
}

import 'package:flutter/material.dart';

class MyColors {
  MyColors._();

  // App basic Colors
  //static const Color primaryColor = Color(0xFFB8956A);

  // // Primary Color Shades (from darkest to lightest) - Enhanced warm golden palette
  // static const Color primaryShade900 = Color(0xFF2A2419);
  // static const Color primaryShade800 = Color(0xFF3E3426);
  // static const Color primaryShade700 = Color(0xFF5D4E38);
  // static const Color primaryShade600 = Color(0xFF8C7350);
  // static const Color primaryShade500 = Color(
  //   0xFFB8956A,
  // ); // Base primary color - richer gold
  // static const Color primaryShade400 = Color(0xFFC7A87D);
  // static const Color primaryShade300 = Color(0xFFD6BC96);
  // static const Color primaryShade200 = Color(0xFFE5D1AF);
  // static const Color primaryShade100 = Color(0xFFF0E5D3);
  // static const Color primaryShade50 = Color(0xFFF8F4ED);

  // static const Color secondaryColor = Color(0xFF6B5D4F);
  static const Color primaryColor = Color(0xFFB9A082);

  // Primary Color Shades (from darkest to lightest)
  static const Color primaryShade900 = Color(0xFF25201A);
  static const Color primaryShade800 = Color(0xFF4A4034);
  static const Color primaryShade700 = Color(0xFF4A4034);
  static const Color primaryShade600 = Color(0xFF948068);
  static const Color primaryShade500 = Color(0xFFB9A082); // Base primary color
  static const Color primaryShade400 = Color(0xFFC7B39B);
  static const Color primaryShade300 = Color(0xFFD5C6B4);
  static const Color primaryShade200 = Color(0xFFDECFBE);
  static const Color primaryShade100 = Color(0xFFEBE3D6);
  static const Color primaryShade50 = Color(0xFFF7F3EF);

  static const Color secondaryColor = primaryShade700;

  static const Color lightCircle = Color(0xFFE8DCC8); // Base primary color

  // //Gradient Colors
  // static const Gradient orangeGradient = LinearGradient(
  //   begin: Alignment.centerRight,
  //   end: Alignment.centerLeft,
  //   colors: [Color(0xffF68B3F), Color(0xffF6C63F)],
  // );

  // static const Gradient blueGradient = LinearGradient(
  //   begin: Alignment.centerRight,
  //   end: Alignment.centerLeft,
  //   colors: [Color(0xff1A73BD), Color.fromRGBO(90, 219, 228, 1)],
  // );

  static LinearGradient customGradient(MaterialColor color) {
    return LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      stops: const [0.0, 0.5, 0.8],
      colors: [color.shade800, color.shade500, color.shade300],
    );
  }

  static LinearGradient customGradient2(Color color) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: const [0.5, 0.9],
      colors: [color, white],
    );
  }

  static SweepGradient customSweepGradient(MaterialColor color) {
    return SweepGradient(
      startAngle: 0.0,
      endAngle: 3.14 * 2,
      tileMode: TileMode.clamp,
      colors: [
        color.shade900,
        color.shade700,
        color.shade500,
        color.shade300,
        color.shade100,
      ],
      stops: const [0.2, 0.5, 0.7, 0.9, 1.0],
    );
  }

  // Text Colors - Improved contrast
  static const Color textPrimary = Color(0xFF2A2419);
  static Color textSecondary = Color(0xFF5D4E38).withValues(alpha: 0.85);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Dark Mode Text Colors - Better visibility
  static const Color textPrimaryDark = Color(0xFFF8F4ED);
  static Color textSecondaryDark = Color(0xFFD6BC96).withValues(alpha: 0.9);

  static const Color cardColor = Color(0xFFFFFBF5);

  // Background Colors - Refined for better readability
  static const Color light = Color(0xFFFFFDF8); // Softer warm white
  static const Color dark = Color(0xFF1F1B16); // Deeper warm dark
  static const Color darker = Color(0xFF171410); // Rich dark with warmth

  // Container Colors with better contrast
  static Color lightContainer = Color(0xFF7A6A54).withValues(alpha: 0.06);
  static const Color darkContainer = Color(
    0xFF2D2822,
  ); // Better elevated container

  // Navigation Colors - Enhanced visibility
  static const Color lightNav = Color(0xFFFFFFFF);
  static const Color darkNav = Color(0xFF252018);

  // Button Colors - More vibrant and professional
  static const Color primaryButton = Color(0xFFB8956A);
  static const Color secondaryButton = Color(0xFF7A6A54);
  static const Color disabledButton = Color(0xFFBDB5AA);

  // Semantic Colors - Modern and accessible
  static const Color error = Color(0xFFDC3545);
  static const Color success = Color(0xFF28C76F);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF00BCD4);

  // Neutral Shades - Enhanced contrast and hierarchy
  static const Color black = Color(0xFF1A1614);
  static const Color darkerGrey = Color(0xFF4A4542);
  static const Color darkGrey = Color(0xFF857F78);
  static const Color grey = Color(0xFFD1CCC4);
  static const Color softGrey = Color(0xFFF2EFE9);
  static const Color lightGrey = Color(0xFFFAF8F5);
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Colors.transparent;

  // Utility method to get Color from string
  static Color? getColor(String value) {
    switch (value) {
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'orange':
        return Colors.orange;
      case 'pink':
        return Colors.pink;
      case 'brown':
        return Colors.brown;
      case 'grey':
        return Colors.grey;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'cyan':
        return Colors.cyan;
      case 'indigo':
        return Colors.indigo;
      case 'teal':
        return Colors.teal;
      default:
        return null;
    }
  }
}

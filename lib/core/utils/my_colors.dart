import 'package:flutter/material.dart';

class MyColors {
  MyColors._();

  // App basic Colors
  static const Color primaryColor = Color(0xFFB9A082);

  // Primary Color Shades (from darkest to lightest)
  static const Color primaryShade900 = Color(0xFF25201A);
  static const Color primaryShade800 = Color(0xFF4A4034);
  static const Color primaryShade700 = Color(0xFF6F604E);
  static const Color primaryShade600 = Color(0xFF948068);
  static const Color primaryShade500 = Color(0xFFB9A082); // Base primary color
  static const Color primaryShade400 = Color(0xFFC7B39B);
  static const Color primaryShade300 = Color(0xFFD5C6B4);
  static const Color primaryShade200 = Color(0xFFDECFBE);
  static const Color primaryShade100 = Color(0xFFEBE3D6);
  static const Color primaryShade50 = Color(0xFFF7F3EF);

  static const Color secondaryColor = primaryShade700;

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

  // Text Colors
  static const Color textPrimary = primaryShade900;
  static Color textSecondary = primaryShade900.withValues(alpha: 0.8);
  static const Color textWhite = Colors.white;

  // Dark Mode Text Colors
  static const Color textPrimaryDark = Color(
    0xFFF5F1ED,
  ); // Warm white for dark mode
  static Color textSecondaryDark = Color(
    0xFFD4C9BD,
  ).withValues(alpha: 0.9); // Muted warm text

  static const Color cardColor = Color.fromARGB(255, 227, 217, 205);
  // Background Colors
  static const Color light = primaryShade100;
  static const Color dark = Color(
    0xFF2D2926,
  ); // Medium-dark with warm undertone
  static const Color darker = Color(0xFF252220); // Slightly deeper warm dark

  //Background container Colors
  static Color lightContainer = Color(0xFF6F604E).withValues(alpha: 0.05);
  static const Color darkContainer = Color(
    0xFF3A3530,
  ); // Elevated container for medium-dark mode

  //Navigation Colors
  static const Color lightNav = primaryShade500;
  static const Color darkNav = Color(
    0xFF332E2A,
  ); // Navigation bar for medium-dark mode

  // Button Colors
  static const Color primaryButton = primaryShade500;
  static const Color secondaryButton = Color(0xff6c757d);
  static const Color disabledButton = Color.fromARGB(255, 40, 32, 32);

  //Error Colors
  static const Color error = Color.fromARGB(255, 129, 67, 50);
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF17A2B8);

  // Neutral Shades
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
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

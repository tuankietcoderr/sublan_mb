import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class CustomTextStyle extends TextStyle {
  static TextStyle h1({required Color color}) {
    return GoogleFonts.questrial(
        fontSize: 44,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.5,
        textStyle: const TextStyle(height: 3));
  }

  static TextStyle h2({required Color color}) {
    return GoogleFonts.questrial(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.5,
        textStyle: const TextStyle(height: 2.5));
  }

  static TextStyle h3({required Color color}) {
    return GoogleFonts.questrial(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.5,
        textStyle: const TextStyle(height: 2));
  }

  static TextStyle h4({required Color color}) {
    return GoogleFonts.questrial(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.5,
        textStyle: const TextStyle(height: 1.5));
  }

  static TextStyle sub({required Color color}) {
    return GoogleFonts.questrial(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: color,
      letterSpacing: 0.5,
    );
  }

  static TextStyle title({required Color color}) {
    return GoogleFonts.questrial(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.5,
        textStyle: const TextStyle(height: 1.5));
  }

  static TextStyle bodyBold({required Color color}) {
    return GoogleFonts.questrial(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.5,
        textStyle: const TextStyle(height: 1.5));
  }

  static TextStyle large({required Color color}) {
    return GoogleFonts.questrial(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
        letterSpacing: 0.5,
        textStyle: const TextStyle(height: 1.5));
  }

  static TextStyle medium({required Color color}) {
    return GoogleFonts.questrial(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
        letterSpacing: 0.5,
        textStyle: const TextStyle(height: 1.5));
  }

  static TextStyle normal({required Color color}) {
    return GoogleFonts.questrial(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
        letterSpacing: 0.5,
        textStyle: const TextStyle(height: 1.5));
  }

  static TextStyle boldButton({required Color color}) {
    return GoogleFonts.questrial(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle button({required Color color}) {
    return GoogleFonts.questrial(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle link({required Color color}) {
    return GoogleFonts.questrial(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.5);
  }

  static TextStyle tinyText({required Color color}) {
    return GoogleFonts.questrial(
      fontSize: 7,
      fontWeight: FontWeight.w300,
      color: color,
    );
  }

  static TextStyle custom(
      {required Color color, double? size, FontWeight? fontWeight}) {
    return GoogleFonts.questrial(
      fontSize: size ?? 14,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color,
    );
  }
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light().copyWith(
      primary: AppColors.primary,
    ),
  );
}

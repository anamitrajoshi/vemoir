import 'package:flutter/material.dart';

class AppColors {
  static const Color secondary = Color(0xFFA99985);
  static const Color tertiary = Color(0xFF70798C);
  static const Color alternate = Color(0xFF252323);
  static const Color primaryBackground = Color(0xFFF5F1ED);
  static const Color secondaryBackground = Color(0xFFFFFFFF);
  static const Color primaryText = Color(0xFF162D3A);
  static const Color secondaryText = Color(0xFF57636C);
  static const Color accent1 = Color(0xFF4C4B39);
}

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.secondary,
  scaffoldBackgroundColor: AppColors.primaryBackground,

  colorScheme: ColorScheme.light(
    primary: AppColors.secondary,
    secondary: AppColors.tertiary,
    background: AppColors.primaryBackground,
    surface: AppColors.secondaryBackground,
  ),

);

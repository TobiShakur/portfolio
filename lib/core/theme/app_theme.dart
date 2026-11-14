import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';

/// Root dark theme configuration for the portfolio web application.
abstract final class AppTheme {
  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bgCanvas,
      canvasColor: AppColors.bgCanvas,
      textTheme: base.textTheme.apply(fontFamily: 'Inter'),
      primaryTextTheme: base.primaryTextTheme.apply(fontFamily: 'Inter'),
      colorScheme: const ColorScheme.dark(
        surface: AppColors.bgSurface,
        primary: AppColors.textPrimary,
        onPrimary: AppColors.ctaInkOnAccent,
        secondary: AppColors.accentEngineering,
        onSecondary: AppColors.ctaInkOnAccent,
        onSurface: AppColors.textPrimary,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.borderFocus),
        thickness: WidgetStateProperty.all(6.0),
        radius: const Radius.circular(999),
      ),
      focusColor: AppColors.borderFocus,
    );
  }
}

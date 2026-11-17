import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';

/// Semantic typography tokens using locally bundled Inter (`w400`/`w500`).
/// Minimum font size across the application is 13.0px; headings stay at `w500`.
abstract final class AppTextStyles {
  static const String _displayFamily = 'Inter';
  static const String _bodyFamily = 'Inter';

  static TextStyle heroDisplay({required bool isMobile}) {
    final size = isMobile ? 36.0 : 56.0;
    return TextStyle(
      fontFamily: _displayFamily,
      fontSize: size,
      fontWeight: FontWeight.w500,
      height: 1.06,
      letterSpacing: size * -0.025,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle sectionHeading({required bool isMobile}) {
    final size = isMobile ? 28.0 : 32.0;
    return TextStyle(
      fontFamily: _displayFamily,
      fontSize: size,
      fontWeight: FontWeight.w500,
      height: 1.15,
      letterSpacing: size * -0.02,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle projectTitle({required bool isMobile}) {
    final size = isMobile ? 26.0 : 30.0;
    return TextStyle(
      fontFamily: _displayFamily,
      fontSize: size,
      fontWeight: FontWeight.w500,
      height: 1.15,
      letterSpacing: size * -0.02,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle cardTitle({required bool isMobile}) {
    final size = isMobile ? 17.0 : 18.0;
    return TextStyle(
      fontFamily: _displayFamily,
      fontSize: size,
      fontWeight: FontWeight.w500,
      height: 1.30,
      letterSpacing: size * -0.01,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle bodyLead({required bool isMobile}) {
    final size = isMobile ? 16.0 : 18.0;
    return TextStyle(
      fontFamily: _bodyFamily,
      fontSize: size,
      fontWeight: FontWeight.w400,
      height: 1.55,
      letterSpacing: 0,
      color: AppColors.textSecondary,
    );
  }

  static TextStyle bodyDefault({Color color = AppColors.textSecondary}) {
    return TextStyle(
      fontFamily: _bodyFamily,
      fontSize: 15.0,
      fontWeight: FontWeight.w400,
      height: 1.55,
      letterSpacing: 0,
      color: color,
    );
  }

  static TextStyle labelSmall({
    Color color = AppColors.textPrimary,
    FontWeight fontWeight = FontWeight.w500,
    bool tabular = false,
  }) {
    return TextStyle(
      fontFamily: _bodyFamily,
      fontSize: 13.0,
      fontWeight: fontWeight,
      height: 1.4,
      letterSpacing: 0,
      color: color,
      fontFeatures: tabular ? const [FontFeature.tabularFigures()] : null,
    );
  }

  static TextStyle buttonLabel({Color color = AppColors.ctaInkOnAccent}) {
    return TextStyle(
      fontFamily: _bodyFamily,
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      height: 1.2,
      letterSpacing: 0,
      color: color,
    );
  }
}

import 'package:flutter/material.dart';

/// Centralized color tokens for the Dark Engineering design system.
abstract final class AppColors {
  static const Color bgCanvas = Color(0xFF080A0C);
  static const Color bgSurface = Color(0xFF101318);
  static const Color bgSurfaceElevated = Color(0xFF171C23);

  static const Color sidebarBg = Color(0xFF050608);
  static const Color sidebarBorder = Color(0xFF303642);
  static const Color sidebarShadow = Color(0xA6000000);

  static const Color bezelFrame = Color(0xFF14181F);
  static const Color bezelSpecular = Color(0x24FFFFFF);

  static const Color borderHairline = Color(0x14FFFFFF);
  static const Color borderFocus = Color(0x38FFFFFF);

  static const Color textPrimary = Color(0xFFF4F6F8);
  static const Color textSecondary = Color(0xFF9AA4B2);
  static const Color textMuted = Color(0xFF7A8594);

  static const Color accentEngineering = Color(0xFF34D399);
  static const Color accentNutriLens = Color(0xFFD2F07A);
  static const Color accentNutriLensDeep = Color(0xFF0C4E36);
  static const Color accentSetPoint = Color(0xFFC8E652);
  static const Color accentSetPointDeep = Color(0xFF229C80);

  static const Color ctaInkOnAccent = Color(0xFF080A0C);
  static const Color scrimHover = Color(0xB8080A0C);

  // NutriLens AI inner preview screen palette (derived from NutriLens app)
  static const Color nutriForestSlot = Color(0xFF185B47);
  static const Color nutriScaffold = Color(0xFFF6F8F5);
  static const Color nutriCard = Color(0xFFFFFFFF);
  static const Color nutriTextDark = Color(0xFF0D291E);
  static const Color nutriTextMuted = Color(0xFF51665E);
  static const Color nutriScannerDark = Color(0xFF0F1B16);
  static const Color nutriSuccess = Color(0xFF10B981);
}

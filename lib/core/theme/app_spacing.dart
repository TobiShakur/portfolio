import 'package:flutter/material.dart';

/// Centralized 4px spacing scale, responsive breakpoints, and safe zones.
abstract final class AppSpacing {
  // Breakpoints
  static const double wideDesktop = 1200.0;
  static const double desktop = 960.0;
  static const double tablet = 600.0;

  // Rhythm
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double sectionVerticalMobile = 48.0;

  // Sidebar geometry & unified desktop anchor rail (Pass 4)
  static const double sidebarWidth = 64.0;
  static const double sidebarHeight = 272.0;
  static const double sidebarItemSize = 44.0;
  static const double sidebarItemIconSize = 40.0;
  static const double sidebarPadding = 8.0;
  static const double sidebarGap = 8.0;
  static const double sidebarBorderWidth = 1.0;
  static const double sidebarInsetWide = 24.0;
  static const double sidebarInsetCompact = 16.0;

  static const double desktopLeftAnchorWide = 120.0;
  static const double desktopLeftAnchorCompact = 100.0;
  static const double desktopRightPaddingWide = 64.0;
  static const double desktopRightPaddingCompact = 32.0;
  static const double mobileHorizontalPadding = 20.0;
  static const double mobileTopBarHeight = 56.0;

  // Legacy aliases mapped to the unified anchor rail
  static const double desktopLeftSafePadding = desktopLeftAnchorWide;
  static const double showcaseLeftSafePadding = desktopLeftAnchorCompact;
  static const double showcaseRightPaddingWide = desktopRightPaddingWide;

  // Touch & layout constraints
  static const double minTouchTarget = 44.0;
  static const double minMobileTouchTarget = 48.0;
  static const double maxContentWidth = 1240.0;
  static const double minDesktopSectionHeight = 680.0;
  static const double phoneAspectRatio = 9.0 / 19.5;
}

/// Disciplined motion tokens sharing one deceleration curve.
abstract final class AppMotion {
  static const Curve standardCurve = Cubic(0.22, 1.0, 0.36, 1.0);
  static const Duration interactive = Duration(milliseconds: 150);
  static const Duration hoverBlur = Duration(milliseconds: 180);
  static const Duration slideFade = Duration(milliseconds: 440);
}

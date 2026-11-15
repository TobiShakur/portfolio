/// Centralized 4pt/8pt spacing scale, responsive breakpoints, and safe zones.
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
  static const double sectionVerticalMobile = 64.0;

  // Sidebar geometry & safe zones
  static const double sidebarWidth = 64.0;
  static const double sidebarHeight = 272.0;
  static const double sidebarItemSize = 44.0;
  static const double sidebarItemIconSize = 40.0;
  static const double sidebarPadding = 8.0;
  static const double sidebarGap = 8.0;
  static const double sidebarBorderWidth = 1.75;
  static const double sidebarInsetWide = 24.0;
  static const double sidebarInsetCompact = 16.0;

  static const double desktopLeftSafePadding = 116.0;
  static const double desktopRightPaddingWide = 64.0;
  static const double desktopRightPaddingCompact = 32.0;
  static const double showcaseLeftSafePadding = 112.0;
  static const double showcaseRightPaddingWide = 40.0;

  // Touch & layout constraints
  static const double minTouchTarget = 44.0;
  static const double minMobileTouchTarget = 48.0;
  static const double maxContentWidth = 1280.0;
  static const double maxShowcaseContentWidth = 1360.0;
  static const double minDesktopSectionHeight = 680.0;
  static const double phoneAspectRatio = 9.0 / 19.5;
}

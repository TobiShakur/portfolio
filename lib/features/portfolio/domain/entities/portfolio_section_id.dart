import 'dart:ui';
import 'package:portfolio/core/theme/app_colors.dart';

/// Ordered sections of the single-page portfolio.
enum PortfolioSectionId {
  overview(
    anchor: 'overview',
    navLabel: 'Overview',
    accentColor: AppColors.accentEngineering,
  ),
  howIHelp(
    anchor: 'how-i-help',
    navLabel: 'How I Help',
    accentColor: AppColors.accentEngineering,
  ),
  engineering(
    anchor: 'stack',
    navLabel: 'Core Stack',
    accentColor: AppColors.accentEngineering,
  ),
  nutrilens(
    anchor: 'nutrilens',
    navLabel: 'NutriLens AI',
    accentColor: AppColors.accentNutriLens,
  ),
  setpoint(
    anchor: 'setpoint',
    navLabel: 'SetPoint',
    accentColor: AppColors.accentSetPoint,
  );

  const PortfolioSectionId({
    required this.anchor,
    required this.navLabel,
    required this.accentColor,
  });

  final String anchor;
  final String navLabel;
  final Color accentColor;
}

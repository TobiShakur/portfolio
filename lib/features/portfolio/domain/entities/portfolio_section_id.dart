import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';

/// Ordered 5 scroll stops spanning the 4 acts of the portfolio experience.
enum PortfolioSectionId {
  overview(
    anchor: 'overview',
    navLabel: 'Overview',
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
  ),
  capabilities(
    anchor: 'capabilities',
    navLabel: 'Capabilities',
    accentColor: AppColors.accentEngineering,
  ),
  contact(
    anchor: 'contact',
    navLabel: 'Contact',
    accentColor: AppColors.accentEngineering,
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

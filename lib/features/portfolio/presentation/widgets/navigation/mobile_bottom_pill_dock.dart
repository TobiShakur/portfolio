import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/features/portfolio/data/portfolio_catalog.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_section_id.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/navigation/sidebar_nav_item.dart';

/// Compact centered bottom pill dock for tablet and mobile viewports (< 960px).
class MobileBottomPillDock extends StatelessWidget {
  const MobileBottomPillDock({
    required this.activeSection,
    required this.onSelectSection,
    super.key,
  });

  final PortfolioSectionId activeSection;
  final ValueChanged<PortfolioSectionId> onSelectSection;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        minimum: const EdgeInsets.only(bottom: 16.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: AppColors.sidebarBg,
            borderRadius: BorderRadius.circular(999.0),
            border: Border.all(
              color: AppColors.sidebarBorder,
              width: AppSpacing.sidebarBorderWidth,
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.sidebarShadow,
                blurRadius: 24.0,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SidebarNavItem(
                section: PortfolioSectionId.overview,
                isActive: activeSection == PortfolioSectionId.overview,
                showTooltipOnHover: false,
                onTap: () => onSelectSection(PortfolioSectionId.overview),
              ),
              const SizedBox(width: AppSpacing.sidebarGap),
              SidebarNavItem(
                section: PortfolioSectionId.engineering,
                isActive: activeSection == PortfolioSectionId.engineering,
                showTooltipOnHover: false,
                onTap: () => onSelectSection(PortfolioSectionId.engineering),
              ),
              const SizedBox(width: AppSpacing.sidebarGap),
              SidebarNavItem(
                section: PortfolioSectionId.nutrilens,
                isActive: activeSection == PortfolioSectionId.nutrilens,
                iconAssetPath: PortfolioCatalog.nutriLens.logoAsset,
                showTooltipOnHover: false,
                onTap: () => onSelectSection(PortfolioSectionId.nutrilens),
              ),
              const SizedBox(width: AppSpacing.sidebarGap),
              SidebarNavItem(
                section: PortfolioSectionId.setpoint,
                isActive: activeSection == PortfolioSectionId.setpoint,
                iconAssetPath: PortfolioCatalog.setPoint.logoAsset,
                showTooltipOnHover: false,
                onTap: () => onSelectSection(PortfolioSectionId.setpoint),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

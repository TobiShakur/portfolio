import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/features/portfolio/data/portfolio_catalog.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_section_id.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/navigation/sidebar_nav_item.dart';

/// Compact vertically-centered floating pill sidebar for desktop viewports.
class FloatingPillSidebar extends StatelessWidget {
  const FloatingPillSidebar({
    required this.activeSection,
    required this.onSelectSection,
    required this.isWideDesktop,
    super.key,
    this.onHoverSection,
  });

  final PortfolioSectionId activeSection;
  final ValueChanged<PortfolioSectionId> onSelectSection;
  final ValueChanged<PortfolioSectionId?>? onHoverSection;
  final bool isWideDesktop;

  @override
  Widget build(BuildContext context) {
    final leftInset = isWideDesktop
        ? AppSpacing.sidebarInsetWide
        : AppSpacing.sidebarInsetCompact;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: leftInset),
        child: Container(
          width: AppSpacing.sidebarWidth,
          padding: const EdgeInsets.all(AppSpacing.sidebarPadding),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SidebarNavItem(
                section: PortfolioSectionId.overview,
                isActive: activeSection == PortfolioSectionId.overview,
                onTap: () => onSelectSection(PortfolioSectionId.overview),
                onHoverChanged: (hovered) => onHoverSection
                    ?.call(hovered ? PortfolioSectionId.overview : null),
              ),
              const SizedBox(height: AppSpacing.sidebarGap),
              SidebarNavItem(
                section: PortfolioSectionId.howIHelp,
                isActive: activeSection == PortfolioSectionId.howIHelp,
                onTap: () => onSelectSection(PortfolioSectionId.howIHelp),
                onHoverChanged: (hovered) => onHoverSection
                    ?.call(hovered ? PortfolioSectionId.howIHelp : null),
              ),
              const SizedBox(height: AppSpacing.sidebarGap),
              SidebarNavItem(
                section: PortfolioSectionId.engineering,
                isActive: activeSection == PortfolioSectionId.engineering,
                onTap: () => onSelectSection(PortfolioSectionId.engineering),
                onHoverChanged: (hovered) => onHoverSection
                    ?.call(hovered ? PortfolioSectionId.engineering : null),
              ),
              const SizedBox(height: AppSpacing.sidebarGap),
              SidebarNavItem(
                section: PortfolioSectionId.nutrilens,
                isActive: activeSection == PortfolioSectionId.nutrilens,
                iconAssetPath: PortfolioCatalog.nutriLens.logoAsset,
                onTap: () => onSelectSection(PortfolioSectionId.nutrilens),
                onHoverChanged: (hovered) => onHoverSection
                    ?.call(hovered ? PortfolioSectionId.nutrilens : null),
              ),
              const SizedBox(height: AppSpacing.sidebarGap),
              SidebarNavItem(
                section: PortfolioSectionId.setpoint,
                isActive: activeSection == PortfolioSectionId.setpoint,
                iconAssetPath: PortfolioCatalog.setPoint.logoAsset,
                onTap: () => onSelectSection(PortfolioSectionId.setpoint),
                onHoverChanged: (hovered) => onHoverSection
                    ?.call(hovered ? PortfolioSectionId.setpoint : null),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

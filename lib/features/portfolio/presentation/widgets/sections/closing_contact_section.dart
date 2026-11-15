import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_text_styles.dart';
import 'package:portfolio/features/portfolio/data/portfolio_catalog.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_concept_id.dart';
import 'package:portfolio/features/portfolio/presentation/controllers/portfolio_navigation_controller.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/portfolio_action_button.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/wide_section_chevron.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/sections/portfolio_footer_strip.dart';

/// Act 3 (`#contact`): Commercial closing CTA band and WCAG 2.2 AA footer strip.
class ClosingContactSection extends StatelessWidget {
  const ClosingContactSection({
    required this.concept,
    required this.controller,
    required this.isDesktop,
    required this.isWideDesktop,
    required this.onBackToTop,
    super.key,
  });

  final PortfolioConceptId concept;
  final PortfolioNavigationController controller;
  final bool isDesktop;
  final bool isWideDesktop;
  final VoidCallback onBackToTop;

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final isMobile = screenW < AppSpacing.tablet;

    final leftPadding = isDesktop
        ? (isWideDesktop
            ? AppSpacing.desktopLeftAnchorWide
            : AppSpacing.desktopLeftAnchorCompact)
        : AppSpacing.mobileHorizontalPadding;
    final rightPadding = isDesktop
        ? (isWideDesktop
            ? AppSpacing.desktopRightPaddingWide
            : AppSpacing.desktopRightPaddingCompact)
        : AppSpacing.mobileHorizontalPadding;

    final profile = PortfolioCatalog.profile;
    final copyLabel = controller.copyEmailState is CopyEmailCopied
        ? 'Copied ${profile.email} ✓'
        : 'Copy ${profile.email}';

    final topRuleColor = concept == PortfolioConceptId.swissGrid
        ? AppColors.swissGridBorder
        : AppColors.borderHairline;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: topRuleColor, width: 1.0),
        ),
      ),
      padding: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        top: isMobile ? 36.0 : 48.0,
        bottom: isMobile ? 28.0 : 32.0,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                header: true,
                child: Text(
                  PortfolioCatalog.closingHeading,
                  style: AppTextStyles.sectionHeading(isMobile: isMobile)
                      .copyWith(fontSize: isMobile ? 24.0 : 30.0),
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                PortfolioCatalog.closingSubcopy,
                style: AppTextStyles.bodyLead(isMobile: isMobile)
                    .copyWith(fontSize: isMobile ? 15.0 : 16.5),
              ),
              const SizedBox(height: 24.0),
              Wrap(
                spacing: 12.0,
                runSpacing: 12.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  PortfolioActionButton(
                    label: copyLabel,
                    variant: PortfolioButtonVariant.primary,
                    borderRadiusOverride: concept.buttonRadius,
                    onPressed: () => controller.copyEmail(profile.email),
                  ),
                  PortfolioActionButton(
                    label: 'Open Email ↗',
                    variant: PortfolioButtonVariant.secondary,
                    borderRadiusOverride: concept.buttonRadius,
                    onPressed: () => controller.openExternalUrl(profile.mailtoUrl),
                  ),
                  PortfolioFooterLink(
                    label: 'GitHub ↗',
                    onTap: () => controller.openExternalUrl(profile.githubUrl),
                  ),
                  PortfolioFooterLink(
                    label: 'LinkedIn ↗',
                    onTap: () => controller.openExternalUrl(profile.linkedInUrl),
                  ),
                ],
              ),
              const SizedBox(height: 36.0),
              PortfolioFooterStrip(
                profile: profile,
                onOpenUrl: controller.openExternalUrl,
                onBackToTop: onBackToTop,
              ),
              const SizedBox(height: 12.0),
              Center(
                child: WideSectionChevron(
                  direction: WideSectionChevronDirection.up,
                  semanticLabel: 'Back to top',
                  onPressed: onBackToTop,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

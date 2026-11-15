import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_text_styles.dart';
import 'package:portfolio/features/portfolio/domain/entities/profile_data.dart';
import 'package:portfolio/features/portfolio/domain/entities/project_showcase.dart';
import 'package:portfolio/features/portfolio/domain/entities/tech_brand.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/portfolio_action_button.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/tech_stack_chip.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/mockups/interactive_right_phone_mockup.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/mockups/tilted_left_phone_mockup.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/sections/portfolio_footer_strip.dart';

/// Sections 2 & 3 (#nutrilens, #setpoint): 3-column desktop showcase with tilted
/// left iPhone, technical problem/solution core, and interactive hover right iPhone.
class ProjectShowcaseSection extends StatelessWidget {
  const ProjectShowcaseSection({
    required this.project,
    required this.onOpenUrl,
    required this.isDesktop,
    required this.isWideDesktop,
    required this.isTablet,
    required this.isMobile,
    super.key,
    this.sectionHeight,
    this.footerProfile,
  });

  final ProjectShowcase project;
  final ValueChanged<String> onOpenUrl;
  final bool isDesktop;
  final bool isWideDesktop;
  final bool isTablet;
  final bool isMobile;
  final double? sectionHeight;
  final ProfileData? footerProfile;

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return _buildDesktopLayout();
    }
    if (isTablet) {
      return _buildTabletLayout();
    }
    return _buildMobileLayout();
  }

  Widget _buildDesktopLayout() {
    final effectiveHeight = sectionHeight ?? 900.0;
    final compact = !isWideDesktop || effectiveHeight < 820.0;
    final rightPad = isWideDesktop
        ? AppSpacing.desktopRightPaddingWide
        : AppSpacing.desktopRightPaddingCompact;

    final maxPhoneHeight =
        effectiveHeight * (footerProfile != null ? 0.59 : 0.63);
    final maxPhoneWidthByHeight =
        math.max(200.0, maxPhoneHeight - 46.0) * AppSpacing.phoneAspectRatio;
    final leftPhoneWidth =
        math.min(isWideDesktop ? 245.0 : 205.0, maxPhoneWidthByHeight * 0.94);
    final rightPhoneWidth =
        math.min(isWideDesktop ? 260.0 : 218.0, maxPhoneWidthByHeight);

    return SizedBox(
      height: effectiveHeight,
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.desktopLeftSafePadding,
              right: rightPad,
              top: compact ? 18.0 : 28.0,
              bottom: compact ? 16.0 : 24.0,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 26,
                        child: Center(
                          child: TiltedLeftPhoneMockup(
                            project: project,
                            width: leftPhoneWidth,
                          ),
                        ),
                      ),
                      SizedBox(width: isWideDesktop ? 28.0 : 18.0),
                      Expanded(
                        flex: 44,
                        child: LayoutBuilder(
                          builder: (context, narrativeConstraints) {
                            return SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: narrativeConstraints.maxHeight,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: _ProjectNarrativeColumn(
                                    project: project,
                                    isMobile: false,
                                    compact: compact,
                                    onOpenUrl: onOpenUrl,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: isWideDesktop ? 28.0 : 18.0),
                      Expanded(
                        flex: 30,
                        child: Center(
                          child: InteractiveRightPhoneMockup(
                            project: project,
                            width: rightPhoneWidth,
                            onOpenLiveDemo: () => onOpenUrl(project.liveDemoUrl),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (footerProfile != null) ...[
                  const SizedBox(height: 12.0),
                  PortfolioFooterStrip(
                    profile: footerProfile!,
                    onOpenUrl: onOpenUrl,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: AppSpacing.sectionVerticalMobile,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 740.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProjectNarrativeColumn(
                project: project,
                isMobile: false,
                compact: false,
                onOpenUrl: onOpenUrl,
              ),
              const SizedBox(height: 36.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: TiltedLeftPhoneMockup(
                      project: project,
                      width: 215.0,
                    ),
                  ),
                  InteractiveRightPhoneMockup(
                    project: project,
                    width: 230.0,
                    showPersistentMobileCta: true,
                    onOpenLiveDemo: () => onOpenUrl(project.liveDemoUrl),
                  ),
                ],
              ),
              if (footerProfile != null) ...[
                const SizedBox(height: 48.0),
                PortfolioFooterStrip(
                  profile: footerProfile!,
                  onOpenUrl: onOpenUrl,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20.0,
        AppSpacing.sectionVerticalMobile,
        20.0,
        footerProfile != null ? 96.0 : AppSpacing.sectionVerticalMobile,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProjectNarrativeColumn(
            project: project,
            isMobile: true,
            compact: false,
            onOpenUrl: onOpenUrl,
            includeActionButtons: false,
          ),
          const SizedBox(height: 28.0),
          Center(
            child: InteractiveRightPhoneMockup(
              project: project,
              width: 240.0,
              showPersistentMobileCta: true,
              onOpenLiveDemo: () => onOpenUrl(project.liveDemoUrl),
            ),
          ),
          const SizedBox(height: 32.0),
          Center(
            child: TiltedLeftPhoneMockup(
              project: project,
              width: 210.0,
            ),
          ),
          const SizedBox(height: 24.0),
          PortfolioActionButton(
            label: 'View Source on GitHub ↗',
            variant: PortfolioButtonVariant.secondary,
            height: 48.0,
            onPressed: () => onOpenUrl(project.repoUrl),
          ),
          if (footerProfile != null) ...[
            const SizedBox(height: 40.0),
            PortfolioFooterStrip(
              profile: footerProfile!,
              onOpenUrl: onOpenUrl,
            ),
          ],
        ],
      ),
    );
  }
}

class _ProjectNarrativeColumn extends StatelessWidget {
  const _ProjectNarrativeColumn({
    required this.project,
    required this.isMobile,
    required this.compact,
    required this.onOpenUrl,
    this.includeActionButtons = true,
  });

  final ProjectShowcase project;
  final bool isMobile;
  final bool compact;
  final ValueChanged<String> onOpenUrl;
  final bool includeActionButtons;

  @override
  Widget build(BuildContext context) {
    final bulletBodyStyle = AppTextStyles.bodyDefault().copyWith(
      fontSize: compact ? 13.5 : 14.5,
      height: compact ? 1.42 : 1.5,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                project.logoAsset,
                width: compact ? 40.0 : 46.0,
                height: compact ? 40.0 : 46.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: AppTextStyles.projectTitle(isMobile: isMobile)
                        .copyWith(fontSize: compact ? 27.0 : null),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    project.subtitle,
                    style: AppTextStyles.bodyDefault(
                      color: AppColors.textSecondary,
                    ).copyWith(fontSize: compact ? 14.0 : 15.0),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: compact ? 14.0 : 20.0),
        Text(
          'THE PROBLEM',
          style: AppTextStyles.labelSmall(
            color: project.accentColor,
            fontWeight: FontWeight.w700,
          ).copyWith(letterSpacing: 1.1),
        ),
        const SizedBox(height: 6.0),
        Text(
          project.problemStatement,
          style: AppTextStyles.bodyDefault(
            color: AppColors.textPrimary.withValues(alpha: 0.9),
          ).copyWith(
            fontSize: compact ? 14.0 : 15.0,
            height: compact ? 1.44 : 1.52,
          ),
        ),
        SizedBox(height: compact ? 14.0 : 18.0),
        Text(
          'HOW IT\'S BUILT',
          style: AppTextStyles.labelSmall(
            color: project.accentColor,
            fontWeight: FontWeight.w700,
          ).copyWith(letterSpacing: 1.1),
        ),
        const SizedBox(height: 8.0),
        for (var i = 0; i < project.engineeringHighlights.length; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 7.0, right: 10.0),
                child: Container(
                  width: 5.0,
                  height: 5.0,
                  decoration: BoxDecoration(
                    color: project.accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: bulletBodyStyle,
                    children: [
                      TextSpan(
                        text: '${project.engineeringHighlights[i].title} ',
                        style: bulletBodyStyle.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: project.engineeringHighlights[i].detail,
                        style: bulletBodyStyle.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (i < project.engineeringHighlights.length - 1)
            SizedBox(height: compact ? 7.0 : 10.0),
        ],
        SizedBox(height: compact ? 14.0 : 18.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            for (final item in project.techStack)
              TechStackChip(
                label: item,
                brand: _brandForTechLabel(item),
                iconSize: 14.0,
              ),
            TechStackChip(
              label: project.testLabel,
              accentColor: project.accentColor,
              isHighlighted: true,
            ),
          ],
        ),
        if (includeActionButtons) ...[
          SizedBox(height: compact ? 14.0 : 20.0),
          Wrap(
            spacing: 12.0,
            runSpacing: 10.0,
            children: [
              PortfolioActionButton(
                label: 'View Source on GitHub ↗',
                variant: PortfolioButtonVariant.secondary,
                height: 46.0,
                onPressed: () => onOpenUrl(project.repoUrl),
              ),
              PortfolioActionButton(
                label: 'Open Live Demo ↗',
                variant: PortfolioButtonVariant.secondary,
                height: 46.0,
                onPressed: () => onOpenUrl(project.liveDemoUrl),
              ),
            ],
          ),
        ],
      ],
    );
  }

  TechBrand? _brandForTechLabel(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('flutter')) return TechBrand.flutter;
    if (lower.contains('dart')) return TechBrand.dart;
    if (lower.contains('firebase')) return TechBrand.firebase;
    if (lower.contains('cloudflare')) return TechBrand.cloudflare;
    if (lower.contains('gemini')) return TechBrand.gemini;
    if (lower.contains('openstreetmap')) return TechBrand.openStreetMap;
    return null;
  }
}

import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_text_styles.dart';
import 'package:portfolio/features/portfolio/domain/entities/profile_data.dart';
import 'package:portfolio/features/portfolio/presentation/controllers/portfolio_navigation_controller.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/portfolio_action_button.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/tech_stack_chip.dart';

/// Section 0 (#overview): Clean Hero with direct pitch, contact CTAs, and
/// key Flutter/Dart hiring stack strip.
class OverviewHeroSection extends StatelessWidget {
  const OverviewHeroSection({
    required this.profile,
    required this.copyEmailState,
    required this.onExploreProjects,
    required this.onOpenUrl,
    required this.onCopyEmail,
    required this.isDesktop,
    required this.isMobile,
    super.key,
    this.sectionHeight,
  });

  final ProfileData profile;
  final CopyEmailState copyEmailState;
  final VoidCallback onExploreProjects;
  final ValueChanged<String> onOpenUrl;
  final VoidCallback onCopyEmail;
  final bool isDesktop;
  final bool isMobile;
  final double? sectionHeight;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = isDesktop
        ? const EdgeInsets.only(
            left: AppSpacing.desktopLeftSafePadding,
            right: AppSpacing.desktopRightPaddingWide,
          )
        : EdgeInsets.symmetric(
            horizontal: isMobile ? 20.0 : 32.0,
          );

    final heroBody = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          profile.identityLine.toUpperCase(),
          style: AppTextStyles.labelSmall(
            color: AppColors.accentEngineering,
            fontWeight: FontWeight.w600,
          ).copyWith(letterSpacing: 1.4),
        ),
        SizedBox(height: isMobile ? 16.0 : 20.0),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroHeadlineLine(
              text: profile.headlineLine1,
              isMobile: isMobile,
            ),
            _HeroHeadlineLine(
              text: profile.headlineLine2,
              isMobile: isMobile,
            ),
          ],
        ),
        SizedBox(height: isMobile ? 16.0 : 18.0),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 660.0),
          child: Text(
            profile.supportingPitch,
            style: AppTextStyles.bodyLead(isMobile: isMobile),
          ),
        ),
        SizedBox(height: isMobile ? 26.0 : 30.0),
        Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            PortfolioActionButton(
              label: 'Explore Projects',
              variant: PortfolioButtonVariant.primary,
              trailingIcon: Icons.arrow_downward_rounded,
              height: isMobile ? 48.0 : 46.0,
              onPressed: onExploreProjects,
            ),
            PortfolioActionButton(
              label: 'GitHub ↗',
              variant: PortfolioButtonVariant.secondary,
              height: isMobile ? 48.0 : 46.0,
              onPressed: () => onOpenUrl(profile.githubUrl),
            ),
            PortfolioActionButton(
              label: 'LinkedIn ↗',
              variant: PortfolioButtonVariant.secondary,
              height: isMobile ? 48.0 : 46.0,
              onPressed: () => onOpenUrl(profile.linkedInUrl),
            ),
            _EmailActionGroup(
              email: profile.email,
              copyEmailState: copyEmailState,
              height: isMobile ? 48.0 : 46.0,
              onOpenMailto: () => onOpenUrl(profile.mailtoUrl),
              onCopyEmail: onCopyEmail,
            ),
          ],
        ),
        SizedBox(height: isMobile ? 28.0 : 36.0),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 18.0),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.borderHairline,
                width: 1.0,
              ),
            ),
          ),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final item in profile.coreStackLogos)
                TechStackChip(
                  label: item.label,
                  brand: item.brand,
                  iconSize: 15.0,
                  textColor: const Color(0xFFD1D5DB),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11.0,
                    vertical: 7.0,
                  ),
                ),
            ],
          ),
        ),
      ],
    );

    final content = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960.0),
        child: Padding(
          padding: horizontalPadding.add(
            EdgeInsets.symmetric(
              vertical: isDesktop ? 24.0 : AppSpacing.sectionVerticalMobile,
            ),
          ),
          child: heroBody,
        ),
      ),
    );

    if (isDesktop && sectionHeight != null) {
      return SizedBox(
        height: sectionHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: content,
              ),
            );
          },
        ),
      );
    }
    return content;
  }
}

class _HeroHeadlineLine extends StatelessWidget {
  const _HeroHeadlineLine({
    required this.text,
    required this.isMobile,
  });

  final String text;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        maxLines: 1,
        style: AppTextStyles.heroDisplay(isMobile: isMobile),
      ),
    );
  }
}

class _EmailActionGroup extends StatelessWidget {
  const _EmailActionGroup({
    required this.email,
    required this.copyEmailState,
    required this.height,
    required this.onOpenMailto,
    required this.onCopyEmail,
  });

  final String email;
  final CopyEmailState copyEmailState;
  final double height;
  final VoidCallback onOpenMailto;
  final VoidCallback onCopyEmail;

  @override
  Widget build(BuildContext context) {
    final copyLabel = switch (copyEmailState) {
      CopyEmailIdle() => 'Copy',
      CopyEmailCopied() => 'Copied ✓',
      CopyEmailError() => 'Retry',
    };

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        PortfolioActionButton(
          label: email,
          variant: PortfolioButtonVariant.secondary,
          height: height,
          onPressed: onOpenMailto,
        ),
        PortfolioActionButton(
          label: copyLabel,
          variant: switch (copyEmailState) {
            CopyEmailCopied() => PortfolioButtonVariant.accentPill,
            CopyEmailIdle() ||
            CopyEmailError() =>
              PortfolioButtonVariant.secondary,
          },
          accentColor: AppColors.accentEngineering,
          height: height,
          horizontalPadding: 14.0,
          onPressed: onCopyEmail,
        ),
      ],
    );
  }
}

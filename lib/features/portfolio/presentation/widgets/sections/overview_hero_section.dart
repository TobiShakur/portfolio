import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_text_styles.dart';
import 'package:portfolio/features/portfolio/data/portfolio_catalog.dart';
import 'package:portfolio/features/portfolio/domain/entities/profile_data.dart';
import 'package:portfolio/features/portfolio/presentation/controllers/portfolio_navigation_controller.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/portfolio_action_button.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/tech_stack_chip.dart';

/// Section 0 (#overview): Asymmetric Hero with freelance pitch, core stack logos,
/// contact actions, and Production Snapshot card.
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

    final leftColumn = Column(
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
        Text(
          profile.supportingPitch,
          style: AppTextStyles.bodyLead(isMobile: isMobile),
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
            spacing: 10.0,
            runSpacing: 10.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final item in profile.coreStackLogos)
                TechStackChip(
                  label: item.label,
                  brand: item.brand,
                  iconSize: 16.0,
                  textColor: const Color(0xFFD1D5DB),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 7.0,
                  ),
                ),
            ],
          ),
        ),
      ],
    );

    final snapshotCard = _ProductionSnapshotCard(
      profile: profile,
      onOpenUrl: onOpenUrl,
    );

    final content = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1220.0),
        child: Padding(
          padding: horizontalPadding.add(
            EdgeInsets.symmetric(
              vertical: isDesktop ? 24.0 : AppSpacing.sectionVerticalMobile,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final useSplitLayout = constraints.maxWidth >= 920.0 && isDesktop;
              if (useSplitLayout) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 58,
                      child: leftColumn,
                    ),
                    const SizedBox(width: 36.0),
                    Expanded(
                      flex: 38,
                      child: snapshotCard,
                    ),
                  ],
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  leftColumn,
                  const SizedBox(height: 28.0),
                  snapshotCard,
                ],
              );
            },
          ),
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

class _ProductionSnapshotCard extends StatelessWidget {
  const _ProductionSnapshotCard({
    required this.profile,
    required this.onOpenUrl,
  });

  final ProfileData profile;
  final ValueChanged<String> onOpenUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22.0),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: AppColors.borderHairline,
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HOW I HELP TEAMS',
            style: AppTextStyles.labelSmall(
              color: AppColors.accentEngineering,
              fontWeight: FontWeight.w700,
            ).copyWith(letterSpacing: 1.2),
          ),
          const SizedBox(height: 16.0),
          for (var i = 0; i < profile.snapshotHighlights.length; i++) ...[
            _SnapshotRow(
              label: profile.snapshotHighlights[i].label,
              value: profile.snapshotHighlights[i].value,
              tabular: profile.snapshotHighlights[i].tabular,
            ),
            const _SnapshotDivider(),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Live Interactive Demos',
                style: AppTextStyles.labelSmall(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 10.0,
                runSpacing: 8.0,
                children: [
                  _SnapshotDemoLink(
                    label: 'NutriLens AI ↗',
                    accent: AppColors.accentNutriLens,
                    onTap: () => onOpenUrl(PortfolioCatalog.nutriLens.liveDemoUrl),
                  ),
                  _SnapshotDemoLink(
                    label: 'SetPoint ↗',
                    accent: AppColors.accentSetPoint,
                    onTap: () => onOpenUrl(PortfolioCatalog.setPoint.liveDemoUrl),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SnapshotRow extends StatelessWidget {
  const _SnapshotRow({
    required this.label,
    required this.value,
    this.tabular = false,
  });

  final String label;
  final String value;
  final bool tabular;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall(
            color: AppColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: AppTextStyles.bodyDefault(
            color: AppColors.textPrimary,
          ).copyWith(
            fontSize: 14.5,
            height: 1.45,
            fontFeatures:
                tabular ? const [FontFeature.tabularFigures()] : null,
          ),
        ),
      ],
    );
  }
}

class _SnapshotDivider extends StatelessWidget {
  const _SnapshotDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Divider(
        height: 1.0,
        thickness: 1.0,
        color: AppColors.borderHairline,
      ),
    );
  }
}

class _SnapshotDemoLink extends StatefulWidget {
  const _SnapshotDemoLink({
    required this.label,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final Color accent;
  final VoidCallback onTap;

  @override
  State<_SnapshotDemoLink> createState() => _SnapshotDemoLinkState();
}

class _SnapshotDemoLinkState extends State<_SnapshotDemoLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(999.0),
        child: Container(
          constraints: const BoxConstraints(minHeight: 44.0),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.accent.withValues(alpha: 0.16)
                : AppColors.bgSurfaceElevated,
            borderRadius: BorderRadius.circular(999.0),
            border: Border.all(
              color: _hovered
                  ? widget.accent.withValues(alpha: 0.55)
                  : AppColors.borderHairline,
              width: 1.0,
            ),
          ),
          child: Text(
            widget.label,
            style: AppTextStyles.labelSmall(
              color: _hovered ? widget.accent : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
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

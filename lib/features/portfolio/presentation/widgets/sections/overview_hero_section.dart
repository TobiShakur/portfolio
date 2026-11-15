import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_text_styles.dart';
import 'package:portfolio/features/portfolio/data/portfolio_catalog.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_concept_id.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_section_id.dart';
import 'package:portfolio/features/portfolio/presentation/controllers/portfolio_navigation_controller.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/backdrops/diagonal_screen_wall_backdrop.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/portfolio_action_button.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/wide_section_chevron.dart';

enum _HeroProofTarget { nutrilens, setpoint, matchup }

/// Act 0 (`#overview`) supporting 3 structurally distinct Hero concepts:
/// A (Editorial Wall + Deck Switcher), B (Swiss Grid + Spec Table), C (Kinetic Stage + Triptych).
class OverviewHeroSection extends StatefulWidget {
  const OverviewHeroSection({
    required this.concept,
    required this.controller,
    required this.isDesktop,
    required this.isWideDesktop,
    required this.sectionHeight,
    required this.isSectionVisible,
    required this.isMotionPaused,
    required this.onChevronNext,
    super.key,
  });

  final PortfolioConceptId concept;
  final PortfolioNavigationController controller;
  final bool isDesktop;
  final bool isWideDesktop;
  final double sectionHeight;
  final bool isSectionVisible;
  final bool isMotionPaused;
  final VoidCallback onChevronNext;

  @override
  State<OverviewHeroSection> createState() => _OverviewHeroSectionState();
}

class _OverviewHeroSectionState extends State<OverviewHeroSection> {
  _HeroProofTarget _selectedProof = _HeroProofTarget.nutrilens;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < AppSpacing.tablet;
    final isCompactDesktop =
        widget.isDesktop && widget.sectionHeight < 780.0;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    final leftPadding = widget.isDesktop
        ? (widget.isWideDesktop
            ? AppSpacing.desktopLeftAnchorWide
            : AppSpacing.desktopLeftAnchorCompact)
        : AppSpacing.mobileHorizontalPadding;
    final rightPadding = widget.isDesktop
        ? (widget.isWideDesktop
            ? AppSpacing.desktopRightPaddingWide
            : AppSpacing.desktopRightPaddingCompact)
        : AppSpacing.mobileHorizontalPadding;

    final innerContent = Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        top: widget.isDesktop
            ? (isCompactDesktop ? 58.0 : 72.0)
            : 28.0,
        bottom: widget.isDesktop ? 8.0 : 28.0,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: switch (widget.concept) {
            PortfolioConceptId.editorialWall => _buildEditorialWallHero(
                isMobile: isMobile,
                isCompactDesktop: isCompactDesktop,
                reduceMotion: reduceMotion,
              ),
            PortfolioConceptId.swissGrid => _buildSwissGridHero(
                isMobile: isMobile,
                isCompactDesktop: isCompactDesktop,
                reduceMotion: reduceMotion,
              ),
            PortfolioConceptId.kineticStage => _buildKineticStageHero(
                isMobile: isMobile,
                isCompactDesktop: isCompactDesktop,
                reduceMotion: reduceMotion,
              ),
          },
        ),
      ),
    );

    final Widget bodyWithChevron;
    if (widget.isDesktop) {
      bodyWithChevron = ConstrainedBox(
        constraints: BoxConstraints(minHeight: widget.sectionHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox.shrink(),
            innerContent,
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Center(
                child: WideSectionChevron(
                  semanticLabel: 'Scroll to NutriLens AI showcase',
                  onPressed: widget.onChevronNext,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      bodyWithChevron = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          innerContent,
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Center(
              child: WideSectionChevron(
                semanticLabel: 'Scroll to NutriLens AI showcase',
                onPressed: widget.onChevronNext,
              ),
            ),
          ),
        ],
      );
    }

    if (widget.concept == PortfolioConceptId.editorialWall) {
      return SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: DiagonalScreenWallBackdrop(
                imageAssets: PortfolioCatalog.allGalleryScreenshots,
                isSectionVisible: widget.isSectionVisible,
                isPaused: widget.isMotionPaused,
                isMobile: isMobile,
                preScrimOpacity: isMobile ? 0.18 : 0.24,
              ),
            ),
            bodyWithChevron,
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: bodyWithChevron,
    );
  }

  // ---------------------------------------------------------------------------
  // Concept A: Editorial Kinetic Wall (Asymmetric 54% / 46% + Live Deck)
  // ---------------------------------------------------------------------------
  Widget _buildEditorialWallHero({
    required bool isMobile,
    required bool isCompactDesktop,
    required bool reduceMotion,
  }) {
    final pitch = _buildHeroPitchBlock(
      isMobile: isMobile,
      isCompactDesktop: isCompactDesktop,
      centered: false,
      ctaLabel: 'Explore Work ↓',
      reduceMotion: reduceMotion,
      showLedger: true,
    );

    final deck = _HeroAppDeckSwitcher(
      selected: _selectedProof,
      isCompact: isCompactDesktop,
      isMobile: isMobile,
      borderRadius: widget.concept.surfaceRadius,
      buttonRadius: widget.concept.buttonRadius,
      onSelect: (target) => setState(() => _selectedProof = target),
      onLaunchLiveDemo: _launchSelectedProofDemo,
      onJumpToSection: (section) => widget.controller
          .scrollToSection(section, reduceMotion: reduceMotion),
    );

    if (!widget.isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pitch,
          const SizedBox(height: 28.0),
          deck,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 54, child: pitch),
        const SizedBox(width: 36.0),
        Expanded(flex: 46, child: deck),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Concept B: Swiss Grid / Technical Studio (1px #262D38 Spec Grid)
  // ---------------------------------------------------------------------------
  Widget _buildSwissGridHero({
    required bool isMobile,
    required bool isCompactDesktop,
    required bool reduceMotion,
  }) {
    final pitch = Padding(
      padding: EdgeInsets.all(isMobile ? 18.0 : (isCompactDesktop ? 24.0 : 32.0)),
      child: _buildHeroPitchBlock(
        isMobile: isMobile,
        isCompactDesktop: isCompactDesktop,
        centered: false,
        ctaLabel: 'View Selected Work ↓',
        reduceMotion: reduceMotion,
        showLedger: false,
      ),
    );

    final specCell = Padding(
      padding: EdgeInsets.all(isMobile ? 16.0 : (isCompactDesktop ? 20.0 : 24.0)),
      child: _SwissHeroSpecTable(
        selected: _selectedProof,
        isCompact: isCompactDesktop,
        onSelect: (target) => setState(() => _selectedProof = target),
        onLaunchLiveDemo: _launchSelectedProofDemo,
        onJumpToSection: (section) => widget.controller
            .scrollToSection(section, reduceMotion: reduceMotion),
      ),
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bgCanvas.withValues(alpha: 0.92),
        border: Border.all(color: AppColors.swissGridBorder, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top grid specification bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.swissGridBorder,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'ENG-PORTFOLIO // BUENOS AIRES (GMT-3)',
                  style: AppTextStyles.labelSmall(
                    color: AppColors.textSecondary,
                    tabular: true,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (!isMobile)
                  Text(
                    '4 ACTS · SPEC ARCHIVE',
                    style: AppTextStyles.labelSmall(
                      color: AppColors.accentEngineering,
                      tabular: true,
                    ),
                  ),
              ],
            ),
          ),
          if (widget.isDesktop)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 58, child: pitch),
                  Container(width: 1.0, color: AppColors.swissGridBorder),
                  Expanded(flex: 42, child: specCell),
                ],
              ),
            )
          else ...[
            pitch,
            Container(height: 1.0, color: AppColors.swissGridBorder),
            specCell,
          ],
          // Bottom tabular verification strip
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.swissGridBorder, width: 1.0),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
            child: Wrap(
              spacing: 24.0,
              runSpacing: 8.0,
              children: [
                for (final item in PortfolioCatalog.profile.snapshotHighlights)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${item.label}: ',
                          style: AppTextStyles.labelSmall(
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                            tabular: true,
                          ),
                        ),
                        TextSpan(
                          text: item.value,
                          style: AppTextStyles.labelSmall(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            tabular: true,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Concept C: Spatial Kinetic Stage (Editorial Top + 3-App Triptych Bottom)
  // ---------------------------------------------------------------------------
  Widget _buildKineticStageHero({
    required bool isMobile,
    required bool isCompactDesktop,
    required bool reduceMotion,
  }) {
    final pitch = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 760.0),
      child: _buildHeroPitchBlock(
        isMobile: isMobile,
        isCompactDesktop: isCompactDesktop,
        centered: !isMobile,
        ctaLabel: 'Explore Work ↓',
        reduceMotion: reduceMotion,
        showLedger: false,
      ),
    );

    final triptych = _KineticHeroTriptych(
      isMobile: isMobile,
      isCompact: isCompactDesktop,
      reduceMotion: reduceMotion,
      onJumpToSection: (section) => widget.controller
          .scrollToSection(section, reduceMotion: reduceMotion),
      onLaunchLiveDemo: (url) => widget.controller.openExternalUrl(url),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        pitch,
        SizedBox(height: isCompactDesktop ? 22.0 : 32.0),
        triptych,
      ],
    );
  }

  Widget _buildHeroPitchBlock({
    required bool isMobile,
    required bool isCompactDesktop,
    required bool centered,
    required String ctaLabel,
    required bool reduceMotion,
    required bool showLedger,
  }) {
    final profile = PortfolioCatalog.profile;
    final (headline1, headline2) =
        PortfolioCatalog.heroHeadlineFor(widget.concept);

    final baseDisplayStyle = AppTextStyles.heroDisplay(isMobile: isMobile);
    final displayStyle = isCompactDesktop
        ? baseDisplayStyle.copyWith(
            fontSize: widget.concept == PortfolioConceptId.kineticStage
                ? 44.0
                : 48.0,
            letterSpacing: -1.6,
          )
        : baseDisplayStyle;

    final copyState = widget.controller.copyEmailState;
    final align =
        centered ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = centered ? TextAlign.center : TextAlign.start;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: align,
      children: [
        Text(
          profile.identityLine,
          textAlign: textAlign,
          style: AppTextStyles.labelSmall(
            color: AppColors.accentEngineering,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: isCompactDesktop ? 10.0 : 14.0),
        Semantics(
          header: true,
          child: Text(
            '$headline1\n$headline2',
            textAlign: textAlign,
            style: displayStyle,
          ),
        ),
        SizedBox(height: isCompactDesktop ? 12.0 : 16.0),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: centered ? 640.0 : 540.0),
          child: Text(
            profile.supportingPitch,
            textAlign: textAlign,
            style: AppTextStyles.bodyLead(isMobile: isMobile).copyWith(
              fontSize: isCompactDesktop ? 16.0 : null,
            ),
          ),
        ),
        SizedBox(height: isCompactDesktop ? 18.0 : 24.0),
        Wrap(
          alignment: centered ? WrapAlignment.center : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12.0,
          runSpacing: 10.0,
          children: [
            PortfolioActionButton(
              label: ctaLabel,
              variant: PortfolioButtonVariant.primary,
              borderRadiusOverride: widget.concept.buttonRadius,
              onPressed: () => widget.controller.scrollToSection(
                PortfolioSectionId.nutrilens,
                reduceMotion: reduceMotion,
              ),
            ),
            _EmailCopyChip(
              email: profile.email,
              copyState: copyState,
              radius: widget.concept.buttonRadius,
              onCopy: () => widget.controller.copyEmail(profile.email),
            ),
            PortfolioActionButton(
              label: 'GitHub ↗',
              variant: PortfolioButtonVariant.secondary,
              borderRadiusOverride: widget.concept.buttonRadius,
              onPressed: () =>
                  widget.controller.openExternalUrl(profile.githubUrl),
            ),
            PortfolioActionButton(
              label: 'LinkedIn ↗',
              variant: PortfolioButtonVariant.secondary,
              borderRadiusOverride: widget.concept.buttonRadius,
              onPressed: () =>
                  widget.controller.openExternalUrl(profile.linkedInUrl),
            ),
          ],
        ),
        if (showLedger) ...[
          SizedBox(height: isCompactDesktop ? 18.0 : 24.0),
          Text(
            profile.verificationMetrics.join(' · '),
            textAlign: textAlign,
            style: AppTextStyles.labelSmall(
              color: AppColors.textMuted,
              tabular: true,
            ),
          ),
        ],
      ],
    );
  }

  void _launchSelectedProofDemo() {
    switch (_selectedProof) {
      case _HeroProofTarget.nutrilens:
        widget.controller.openExternalUrl(PortfolioCatalog.nutriLens.liveDemoUrl);
      case _HeroProofTarget.setpoint:
        widget.controller.openExternalUrl(PortfolioCatalog.setPoint.liveDemoUrl);
      case _HeroProofTarget.matchup:
        widget.controller.scrollToSection(
          PortfolioSectionId.capabilities,
          reduceMotion: MediaQuery.disableAnimationsOf(context),
        );
    }
  }
}

class _EmailCopyChip extends StatefulWidget {
  const _EmailCopyChip({
    required this.email,
    required this.copyState,
    required this.radius,
    required this.onCopy,
  });

  final String email;
  final CopyEmailState copyState;
  final double radius;
  final VoidCallback onCopy;

  @override
  State<_EmailCopyChip> createState() => _EmailCopyChipState();
}

class _EmailCopyChipState extends State<_EmailCopyChip> {
  bool _focused = false;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final copied = widget.copyState is CopyEmailCopied;
    final buttonRadius = widget.radius > 100.0 ? 999.0 : widget.radius;

    return Semantics(
      button: true,
      label: 'Copy email ${widget.email}',
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: (v) => setState(() => _hovered = v),
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onCopy();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onCopy,
          child: Container(
            constraints: const BoxConstraints(minHeight: 46.0),
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            decoration: BoxDecoration(
              color: _hovered || _focused
                  ? AppColors.bgSurfaceElevated
                  : AppColors.bgSurface,
              borderRadius: BorderRadius.circular(buttonRadius),
              border: Border.all(
                color: _focused
                    ? AppColors.accentEngineering
                    : (copied
                        ? AppColors.accentEngineering
                        : AppColors.borderHairline),
                width: _focused ? 2.0 : 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.email,
                  style: AppTextStyles.labelSmall(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 10.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: copied
                        ? AppColors.accentEngineering.withValues(alpha: 0.18)
                        : AppColors.bgSurfaceElevated,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Text(
                    copied ? 'Copied ✓' : 'Copy',
                    style: AppTextStyles.labelSmall(
                      color: copied
                          ? AppColors.accentEngineering
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Interactive Hero deck card for Concept A switching live between
/// NutriLens AI, SetPoint, and MatchUp 5.0★.
class _HeroAppDeckSwitcher extends StatelessWidget {
  const _HeroAppDeckSwitcher({
    required this.selected,
    required this.isCompact,
    required this.isMobile,
    required this.borderRadius,
    required this.buttonRadius,
    required this.onSelect,
    required this.onLaunchLiveDemo,
    required this.onJumpToSection,
  });

  final _HeroProofTarget selected;
  final bool isCompact;
  final bool isMobile;
  final double borderRadius;
  final double buttonRadius;
  final ValueChanged<_HeroProofTarget> onSelect;
  final VoidCallback onLaunchLiveDemo;
  final ValueChanged<PortfolioSectionId> onJumpToSection;

  @override
  Widget build(BuildContext context) {
    final previewH = isMobile ? 210.0 : (isCompact ? 250.0 : 300.0);

    return Container(
      padding: EdgeInsets.all(isCompact ? 16.0 : 20.0),
      decoration: BoxDecoration(
        color: AppColors.bgSurface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.borderFocus, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x99000000),
            blurRadius: 36.0,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: [
              _DeckTabChip(
                label: 'NutriLens AI',
                isSelected: selected == _HeroProofTarget.nutrilens,
                accentColor: AppColors.accentNutriLens,
                onTap: () => onSelect(_HeroProofTarget.nutrilens),
              ),
              _DeckTabChip(
                label: 'SetPoint',
                isSelected: selected == _HeroProofTarget.setpoint,
                accentColor: AppColors.accentSetPoint,
                onTap: () => onSelect(_HeroProofTarget.setpoint),
              ),
              _DeckTabChip(
                label: 'MatchUp 5.0★',
                isSelected: selected == _HeroProofTarget.matchup,
                accentColor: AppColors.accentEngineering,
                onTap: () => onSelect(_HeroProofTarget.matchup),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            height: previewH,
            child: _ProofPreviewFrame(target: selected),
          ),
          const SizedBox(height: 14.0),
          Text(
            _metaLineFor(selected),
            style: AppTextStyles.labelSmall(
              color: AppColors.textSecondary,
              tabular: true,
            ),
          ),
          const SizedBox(height: 12.0),
          Wrap(
            spacing: 10.0,
            runSpacing: 8.0,
            children: [
              PortfolioActionButton(
                label: selected == _HeroProofTarget.matchup
                    ? 'Inspect Client Proof ↓'
                    : 'Open Live Demo ↗',
                variant: PortfolioButtonVariant.accentPill,
                accentColor: _accentFor(selected),
                borderRadiusOverride: buttonRadius,
                height: 44.0,
                onPressed: onLaunchLiveDemo,
              ),
              PortfolioActionButton(
                label: 'Jump ↓',
                variant: PortfolioButtonVariant.secondary,
                borderRadiusOverride: buttonRadius,
                height: 44.0,
                onPressed: () => onJumpToSection(_sectionFor(selected)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SwissHeroSpecTable extends StatelessWidget {
  const _SwissHeroSpecTable({
    required this.selected,
    required this.isCompact,
    required this.onSelect,
    required this.onLaunchLiveDemo,
    required this.onJumpToSection,
  });

  final _HeroProofTarget selected;
  final bool isCompact;
  final ValueChanged<_HeroProofTarget> onSelect;
  final VoidCallback onLaunchLiveDemo;
  final ValueChanged<PortfolioSectionId> onJumpToSection;

  @override
  Widget build(BuildContext context) {
    final previewH = isCompact ? 150.0 : 190.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'SELECT SHIPPED PROOF',
          style: AppTextStyles.labelSmall(
            color: AppColors.textMuted,
            fontWeight: FontWeight.w700,
            tabular: true,
          ),
        ),
        const SizedBox(height: 10.0),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.swissGridBorder, width: 1.0),
          ),
          child: Column(
            children: [
              _SwissSpecRow(
                index: '01',
                name: 'NutriLens AI',
                badge: '153T',
                isSelected: selected == _HeroProofTarget.nutrilens,
                accentColor: AppColors.accentNutriLens,
                onTap: () => onSelect(_HeroProofTarget.nutrilens),
              ),
              Container(height: 1.0, color: AppColors.swissCellBorder),
              _SwissSpecRow(
                index: '02',
                name: 'SetPoint',
                badge: ' 24T',
                isSelected: selected == _HeroProofTarget.setpoint,
                accentColor: AppColors.accentSetPoint,
                onTap: () => onSelect(_HeroProofTarget.setpoint),
              ),
              Container(height: 1.0, color: AppColors.swissCellBorder),
              _SwissSpecRow(
                index: '03',
                name: 'MatchUp',
                badge: '5.0★',
                isSelected: selected == _HeroProofTarget.matchup,
                accentColor: AppColors.accentEngineering,
                onTap: () => onSelect(_HeroProofTarget.matchup),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14.0),
        SizedBox(
          height: previewH,
          child: _ProofPreviewFrame(target: selected),
        ),
        const SizedBox(height: 12.0),
        Text(
          _metaLineFor(selected),
          style: AppTextStyles.labelSmall(
            color: AppColors.textSecondary,
            tabular: true,
          ),
        ),
        const SizedBox(height: 10.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            PortfolioActionButton(
              label: selected == _HeroProofTarget.matchup
                  ? 'Inspect Client Proof ↓'
                  : 'Open Live Demo ↗',
              variant: PortfolioButtonVariant.accentPill,
              accentColor: _accentFor(selected),
              borderRadiusOverride: 6.0,
              height: 44.0,
              onPressed: onLaunchLiveDemo,
            ),
            PortfolioActionButton(
              label: 'Section ↓',
              variant: PortfolioButtonVariant.secondary,
              borderRadiusOverride: 6.0,
              height: 44.0,
              onPressed: () => onJumpToSection(_sectionFor(selected)),
            ),
          ],
        ),
      ],
    );
  }
}

class _KineticHeroTriptych extends StatelessWidget {
  const _KineticHeroTriptych({
    required this.isMobile,
    required this.isCompact,
    required this.reduceMotion,
    required this.onJumpToSection,
    required this.onLaunchLiveDemo,
  });

  final bool isMobile;
  final bool isCompact;
  final bool reduceMotion;
  final ValueChanged<PortfolioSectionId> onJumpToSection;
  final ValueChanged<String> onLaunchLiveDemo;

  @override
  Widget build(BuildContext context) {
    final cardH = isMobile ? 228.0 : (isCompact ? 228.0 : 272.0);
    final cards = [
      _TriptychProductCard(
        title: PortfolioCatalog.nutriLens.title,
        subtitle: '153 Tests · Gemini Edge Proxy',
        accentColor: AppColors.accentNutriLens,
        screenshotAsset: PortfolioCatalog.nutriLens.leftScreenshotAsset,
        angleRadians: (isMobile || reduceMotion) ? 0.0 : -0.055,
        height: cardH,
        onTap: () => onJumpToSection(PortfolioSectionId.nutrilens),
      ),
      _TriptychProductCard(
        title: PortfolioCatalog.setPoint.title,
        subtitle: '24 Tests · BLoC + Geospatial',
        accentColor: AppColors.accentSetPoint,
        screenshotAsset: PortfolioCatalog.setPoint.leftScreenshotAsset,
        angleRadians: 0.0,
        height: cardH,
        onTap: () => onJumpToSection(PortfolioSectionId.setpoint),
      ),
      _TriptychProductCard(
        title: PortfolioCatalog.matchUpProof.shortName,
        subtitle: 'Apple App Store · 5.0★ Client App',
        accentColor: AppColors.accentEngineering,
        screenshotAsset: null,
        angleRadians: (isMobile || reduceMotion) ? 0.0 : 0.055,
        height: cardH,
        onTap: () => onJumpToSection(PortfolioSectionId.capabilities),
      ),
    ];

    if (isMobile) {
      return SizedBox(
        height: cardH + 12.0,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                if (i > 0) const SizedBox(width: 14.0),
                SizedBox(width: 236.0, child: cards[i]),
              ],
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        for (var i = 0; i < cards.length; i++) ...[
          if (i > 0) const SizedBox(width: 20.0),
          Expanded(child: cards[i]),
        ],
      ],
    );
  }
}

class _TriptychProductCard extends StatefulWidget {
  const _TriptychProductCard({
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.screenshotAsset,
    required this.angleRadians,
    required this.height,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Color accentColor;
  final String? screenshotAsset;
  final double angleRadians;
  final double height;
  final VoidCallback onTap;

  @override
  State<_TriptychProductCard> createState() => _TriptychProductCardState();
}

class _TriptychProductCardState extends State<_TriptychProductCard> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final active = _hovered || _focused;

    return Semantics(
      button: true,
      label: '${widget.title} — ${widget.subtitle}',
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: (v) => setState(() => _hovered = v),
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onTap();
              return null;
            },
          ),
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: Transform.rotate(
            angle: active ? 0.0 : widget.angleRadians,
            child: Container(
              height: widget.height,
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(18.0),
                border: Border.all(
                  color: _focused
                      ? widget.accentColor
                      : (active
                          ? widget.accentColor.withValues(alpha: 0.7)
                          : AppColors.borderHairline),
                  width: _focused ? 2.0 : 1.0,
                ),
                boxShadow: [
                  const BoxShadow(
                    color: Color(0x88000000),
                    blurRadius: 24.0,
                    offset: Offset(0, 12),
                  ),
                  if (active)
                    BoxShadow(
                      color: widget.accentColor.withValues(alpha: 0.14),
                      blurRadius: 28.0,
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.cardTitle(isMobile: false),
                        ),
                      ),
                      Text(
                        '↗',
                        style: AppTextStyles.labelSmall(
                          color: widget.accentColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    widget.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelSmall(
                      color: AppColors.textSecondary,
                      tabular: true,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: widget.screenshotAsset != null
                          ? Container(
                              width: double.infinity,
                              color: AppColors.bgCanvas,
                              child: Image.asset(
                                widget.screenshotAsset!,
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              ),
                            )
                          : const _MatchUpAppStoreCardVisual(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DeckTabChip extends StatefulWidget {
  const _DeckTabChip({
    required this.label,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  State<_DeckTabChip> createState() => _DeckTabChipState();
}

class _DeckTabChipState extends State<_DeckTabChip> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: widget.isSelected,
      label: 'Preview ${widget.label}',
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onTap();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 44.0),
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? widget.accentColor.withValues(alpha: 0.16)
                  : AppColors.bgCanvas,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: _focused || widget.isSelected
                    ? widget.accentColor
                    : AppColors.borderHairline,
                width: _focused ? 2.0 : 1.0,
              ),
            ),
            child: Text(
              widget.label,
              style: AppTextStyles.labelSmall(
                color: widget.isSelected
                    ? widget.accentColor
                    : AppColors.textSecondary,
                fontWeight: widget.isSelected
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SwissSpecRow extends StatefulWidget {
  const _SwissSpecRow({
    required this.index,
    required this.name,
    required this.badge,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  final String index;
  final String name;
  final String badge;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  State<_SwissSpecRow> createState() => _SwissSpecRowState();
}

class _SwissSpecRowState extends State<_SwissSpecRow> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: widget.isSelected,
      label: 'Select ${widget.name} specification',
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onTap();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 44.0),
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? AppColors.bgSurfaceElevated
                  : Colors.transparent,
              border: _focused
                  ? Border.all(color: widget.accentColor, width: 2.0)
                  : null,
            ),
            child: Row(
              children: [
                Text(
                  widget.isSelected ? '>' : ' ',
                  style: AppTextStyles.labelSmall(
                    color: widget.accentColor,
                    fontWeight: FontWeight.w700,
                    tabular: true,
                  ),
                ),
                const SizedBox(width: 6.0),
                Text(
                  widget.index,
                  style: AppTextStyles.labelSmall(
                    color: AppColors.textMuted,
                    tabular: true,
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    widget.name,
                    style: AppTextStyles.labelSmall(
                      color: widget.isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '[${widget.badge}]',
                  style: AppTextStyles.labelSmall(
                    color: widget.isSelected
                        ? widget.accentColor
                        : AppColors.textMuted,
                    tabular: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProofPreviewFrame extends StatelessWidget {
  const _ProofPreviewFrame({required this.target});

  final _HeroProofTarget target;

  @override
  Widget build(BuildContext context) {
    if (target == _HeroProofTarget.matchup) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: const _MatchUpAppStoreCardVisual(),
      );
    }

    final asset = target == _HeroProofTarget.nutrilens
        ? PortfolioCatalog.nutriLens.leftScreenshotAsset
        : PortfolioCatalog.setPoint.leftScreenshotAsset;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCanvas,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.borderHairline, width: 1.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11.0),
        child: Image.asset(
          asset,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

class _MatchUpAppStoreCardVisual extends StatelessWidget {
  const _MatchUpAppStoreCardVisual();

  @override
  Widget build(BuildContext context) {
    final proof = PortfolioCatalog.matchUpProof;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0E1D19), Color(0xFF101318)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentEngineering.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Text(
                    '${proof.storeLabel} · ${proof.ratingLabel}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelSmall(
                      color: AppColors.accentEngineering,
                      fontWeight: FontWeight.w700,
                      tabular: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    proof.shortName,
                    style: AppTextStyles.cardTitle(isMobile: false),
                  ),
                  const SizedBox(height: 4.0),
                  for (final item in proof.highlights) ...[
                    Text(
                      '• $item',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelSmall(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _accentFor(_HeroProofTarget target) {
  return switch (target) {
    _HeroProofTarget.nutrilens => AppColors.accentNutriLens,
    _HeroProofTarget.setpoint => AppColors.accentSetPoint,
    _HeroProofTarget.matchup => AppColors.accentEngineering,
  };
}

PortfolioSectionId _sectionFor(_HeroProofTarget target) {
  return switch (target) {
    _HeroProofTarget.nutrilens => PortfolioSectionId.nutrilens,
    _HeroProofTarget.setpoint => PortfolioSectionId.setpoint,
    _HeroProofTarget.matchup => PortfolioSectionId.capabilities,
  };
}

String _metaLineFor(_HeroProofTarget target) {
  return switch (target) {
    _HeroProofTarget.nutrilens => '153 Tests · Cloudflare Edge API',
    _HeroProofTarget.setpoint => '24 Tests · Clean Arch + BLoC',
    _HeroProofTarget.matchup => 'Client Delivery · iOS App Store (5.0★)',
  };
}

import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_text_styles.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_concept_id.dart';
import 'package:portfolio/features/portfolio/domain/entities/project_showcase.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/backdrops/diagonal_screen_wall_backdrop.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/backdrops/horizontal_filmstrip_backdrop.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/backdrops/parallax_columns_backdrop.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/portfolio_action_button.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/wide_section_chevron.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/mockups/interactive_right_phone_mockup.dart';

/// Act 1 (`#nutrilens` / `#setpoint`) supporting Concepts A, B, and C with
/// edge-to-edge top/bottom rules, kinetic app screen backdrops, and Pause controls.
class ProjectShowcaseSection extends StatefulWidget {
  const ProjectShowcaseSection({
    required this.project,
    required this.projectIndex,
    required this.concept,
    required this.isDesktop,
    required this.isWideDesktop,
    required this.sectionHeight,
    required this.isSectionVisible,
    required this.isMotionPaused,
    required this.onToggleMotionPaused,
    required this.onOpenUrl,
    required this.onChevronNext,
    super.key,
  });

  final ProjectShowcase project;
  final int projectIndex;
  final PortfolioConceptId concept;
  final bool isDesktop;
  final bool isWideDesktop;
  final double sectionHeight;
  final bool isSectionVisible;
  final bool isMotionPaused;
  final VoidCallback onToggleMotionPaused;
  final ValueChanged<String> onOpenUrl;
  final VoidCallback onChevronNext;

  @override
  State<ProjectShowcaseSection> createState() => _ProjectShowcaseSectionState();
}

class _ProjectShowcaseSectionState extends State<ProjectShowcaseSection> {
  int _activeScreenIndex = 0;

  List<String> get _screens => widget.project.allScreenAssets;

  void _stepScreen(int delta) {
    final len = _screens.length;
    if (len == 0) {
      return;
    }
    setState(() {
      _activeScreenIndex = (_activeScreenIndex + delta + len) % len;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < AppSpacing.tablet;
    final isCompactDesktop = widget.isDesktop && widget.sectionHeight < 780.0;

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

    // Responsive bezel width ensures 9:19.5 phone + controls fit inside 1280x720.
    final double phoneWidth = isMobile
        ? 236.0
        : (isCompactDesktop
            ? (widget.concept == PortfolioConceptId.swissGrid ? 192.0 : 198.0)
            : (widget.isWideDesktop ? 276.0 : 244.0));

    final Widget mainLayout;
    if (!widget.isDesktop) {
      mainLayout = _buildMobileShowcase(
        leftPadding: leftPadding,
        rightPadding: rightPadding,
        phoneWidth: phoneWidth,
      );
    } else {
      mainLayout = switch (widget.concept) {
        PortfolioConceptId.editorialWall => _buildConceptADesktop(
            leftPadding: leftPadding,
            rightPadding: rightPadding,
            phoneWidth: phoneWidth,
            isCompactDesktop: isCompactDesktop,
          ),
        PortfolioConceptId.swissGrid => _buildConceptBDesktop(
            leftPadding: leftPadding,
            rightPadding: rightPadding,
            phoneWidth: phoneWidth,
            isCompactDesktop: isCompactDesktop,
          ),
        PortfolioConceptId.kineticStage => _buildConceptCDesktop(
            leftPadding: leftPadding,
            rightPadding: rightPadding,
            phoneWidth: phoneWidth,
            isCompactDesktop: isCompactDesktop,
          ),
      };
    }

    final Widget bodyWithRules = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BoundaryHairlineRule(concept: widget.concept),
        if (widget.isDesktop)
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: widget.sectionHeight - 2.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.concept == PortfolioConceptId.editorialWall)
                  _EditorialTopTagStrip(
                    project: widget.project,
                    leftPadding: leftPadding,
                    rightPadding: rightPadding,
                    isMotionPaused: widget.isMotionPaused,
                    onToggleMotionPaused: widget.onToggleMotionPaused,
                  )
                else if (widget.concept == PortfolioConceptId.swissGrid)
                  _SwissProjectSpecStrip(
                    project: widget.project,
                    leftPadding: leftPadding,
                    rightPadding: rightPadding,
                    onOpenDemo: () =>
                        widget.onOpenUrl(widget.project.liveDemoUrl),
                  )
                else
                  const SizedBox.shrink(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: isCompactDesktop ? 4.0 : 24.0,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppSpacing.maxContentWidth,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: leftPadding,
                          right: rightPadding,
                        ),
                        child: mainLayout,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: isCompactDesktop ? 4.0 : 10.0),
                  child: Center(
                    child: WideSectionChevron(
                      semanticLabel: widget.projectIndex == 0
                          ? 'Scroll to SetPoint showcase'
                          : 'Scroll to Capabilities & Stack',
                      accentColor: widget.project.accentColor,
                      onPressed: widget.onChevronNext,
                    ),
                  ),
                ),
              ],
            ),
          )
        else ...[
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 28.0 : 36.0,
            ),
            child: mainLayout,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Center(
              child: WideSectionChevron(
                semanticLabel: widget.projectIndex == 0
                    ? 'Scroll to SetPoint showcase'
                    : 'Scroll to Capabilities & Stack',
                accentColor: widget.project.accentColor,
                onPressed: widget.onChevronNext,
              ),
            ),
          ),
        ],
        _BoundaryHairlineRule(concept: widget.concept),
      ],
    );

    if (widget.concept == PortfolioConceptId.editorialWall) {
      return SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: DiagonalScreenWallBackdrop(
                imageAssets: _screens,
                isSectionVisible: widget.isSectionVisible,
                isPaused: widget.isMotionPaused,
                isMobile: isMobile,
                preScrimOpacity: isMobile ? 0.22 : 0.34,
              ),
            ),
            bodyWithRules,
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: bodyWithRules,
    );
  }

  // ---------------------------------------------------------------------------
  // Concept A: 50% / 50% Split + Tucked Secondary Screen + Screen Stepper
  // ---------------------------------------------------------------------------
  Widget _buildConceptADesktop({
    required double leftPadding,
    required double rightPadding,
    required double phoneWidth,
    required bool isCompactDesktop,
  }) {
    final secondaryIndex = (_activeScreenIndex + 1) % _screens.length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 50,
          child: _ProjectNarrativeColumn(
            project: widget.project,
            concept: widget.concept,
            isMobile: false,
            isCompactDesktop: isCompactDesktop,
            useAccentSpine: false,
            useIndexedArchitecture: false,
            onOpenUrl: widget.onOpenUrl,
          ),
        ),
        const SizedBox(width: 36.0),
        Expanded(
          flex: 50,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: (phoneWidth / AppSpacing.phoneAspectRatio) + 28.0,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Tucked secondary rotated card behind foreground bezel (+16px X, -18px Y)
                    Transform.translate(
                      offset: const Offset(72.0, -18.0),
                      child: Transform.rotate(
                        angle: 0.08,
                        child: Container(
                          width: phoneWidth * 0.78,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.0),
                            border: Border.all(
                              color: AppColors.borderFocus,
                              width: 1.0,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x88000000),
                                blurRadius: 28.0,
                                offset: Offset(0, 14),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(23.0),
                            child: AspectRatio(
                              aspectRatio: AppSpacing.phoneAspectRatio,
                              child: Opacity(
                                opacity: 0.72,
                                child: Image.asset(
                                  _screens[secondaryIndex],
                                  cacheWidth: 420,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(-26.0, 6.0),
                      child: InteractiveRightPhoneMockup(
                        project: widget.project,
                        width: phoneWidth,
                        previewAssetsOverride: _screens,
                        controlledIndex: _activeScreenIndex,
                        isPaused: widget.isMotionPaused,
                        onScreenChanged: (next) =>
                            setState(() => _activeScreenIndex = next),
                        onOpenLiveDemo: () =>
                            widget.onOpenUrl(widget.project.liveDemoUrl),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12.0),
              _ShowcaseScreenControlsRow(
                activeIndex: _activeScreenIndex,
                totalCount: _screens.length,
                accentColor: widget.project.accentColor,
                isPaused: widget.isMotionPaused,
                onPrev: () => _stepScreen(-1),
                onNext: () => _stepScreen(1),
                onTogglePause: widget.onToggleMotionPaused,
                hintText: 'Hover/click → Demo',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Concept B: Swiss Grid (Mandatory L/R Alternation + Cell Filmstrip + Console)
  // ---------------------------------------------------------------------------
  Widget _buildConceptBDesktop({
    required double leftPadding,
    required double rightPadding,
    required double phoneWidth,
    required bool isCompactDesktop,
  }) {
    final bool invertStageLeft = widget.projectIndex.isOdd;

    final narrativeCell = Padding(
      padding: EdgeInsets.all(isCompactDesktop ? 14.0 : 28.0),
      child: _ProjectNarrativeColumn(
        project: widget.project,
        concept: widget.concept,
        isMobile: false,
        isCompactDesktop: isCompactDesktop,
        useAccentSpine: false,
        useIndexedArchitecture: true,
        onOpenUrl: widget.onOpenUrl,
      ),
    );

    final stageCell = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRect(
          child: SizedBox(
            height: (phoneWidth / AppSpacing.phoneAspectRatio) +
                (isCompactDesktop ? 36.0 : 54.0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                HorizontalFilmstripBackdrop(
                  imageAssets: _screens,
                  isSectionVisible: widget.isSectionVisible,
                  isPaused: widget.isMotionPaused,
                ),
                Center(
                  child: InteractiveRightPhoneMockup(
                    project: widget.project,
                    width: phoneWidth,
                    previewAssetsOverride: _screens,
                    controlledIndex: _activeScreenIndex,
                    isPaused: widget.isMotionPaused,
                    onScreenChanged: (next) =>
                        setState(() => _activeScreenIndex = next),
                    onOpenLiveDemo: () =>
                        widget.onOpenUrl(widget.project.liveDemoUrl),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Bottom Stage console bar: [01] [02] [03] [04]  [⏸]  Launch Demo ↗
        Container(
          height: 46.0,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: const BoxDecoration(
            color: AppColors.bgSurface,
            border: Border(
              top: BorderSide(color: AppColors.swissCellBorder, width: 1.0),
            ),
          ),
          child: Row(
            children: [
              for (var i = 0; i < _screens.length; i++)
                _ConsoleIndexButton(
                  label: '0${i + 1}',
                  isSelected: _activeScreenIndex == i,
                  accentColor: widget.project.accentColor,
                  onTap: () => setState(() => _activeScreenIndex = i),
                ),
              const Spacer(),
              _PauseMotionButton(
                isPaused: widget.isMotionPaused,
                accentColor: widget.project.accentColor,
                onTap: widget.onToggleMotionPaused,
              ),
              const SizedBox(width: 8.0),
              TextButton(
                onPressed: () => widget.onOpenUrl(widget.project.liveDemoUrl),
                style: TextButton.styleFrom(
                  foregroundColor: widget.project.accentColor,
                  minimumSize: const Size(44.0, 44.0),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                ),
                child: const Text('Launch Demo ↗'),
              ),
            ],
          ),
        ),
      ],
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.swissGridBorder, width: 1.0),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: invertStageLeft
              ? [
                  Expanded(flex: 54, child: stageCell),
                  Container(width: 1.0, color: AppColors.swissCellBorder),
                  Expanded(flex: 46, child: narrativeCell),
                ]
              : [
                  Expanded(flex: 46, child: narrativeCell),
                  Container(width: 1.0, color: AppColors.swissCellBorder),
                  Expanded(flex: 54, child: stageCell),
                ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Concept C: Spatial Kinetic Stage (44% Narrative w/ Spine + 56% Parallax Cols)
  // ---------------------------------------------------------------------------
  Widget _buildConceptCDesktop({
    required double leftPadding,
    required double rightPadding,
    required double phoneWidth,
    required bool isCompactDesktop,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 44,
          child: _ProjectNarrativeColumn(
            project: widget.project,
            concept: widget.concept,
            isMobile: false,
            isCompactDesktop: isCompactDesktop,
            useAccentSpine: true,
            useIndexedArchitecture: false,
            onOpenUrl: widget.onOpenUrl,
          ),
        ),
        const SizedBox(width: 32.0),
        Expanded(
          flex: 56,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: (phoneWidth / AppSpacing.phoneAspectRatio) +
                    (isCompactDesktop ? 40.0 : 72.0),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Subtle accent spotlight behind foreground bezel
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          radius: 0.72,
                          colors: [
                            widget.project.accentColor.withValues(alpha: 0.11),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    ParallaxColumnsBackdrop(
                      imageAssets: _screens,
                      isSectionVisible: widget.isSectionVisible,
                      isPaused: widget.isMotionPaused,
                    ),
                    Center(
                      child: InteractiveRightPhoneMockup(
                        project: widget.project,
                        width: phoneWidth,
                        previewAssetsOverride: _screens,
                        controlledIndex: _activeScreenIndex,
                        isPaused: widget.isMotionPaused,
                        onScreenChanged: (next) =>
                            setState(() => _activeScreenIndex = next),
                        onOpenLiveDemo: () =>
                            widget.onOpenUrl(widget.project.liveDemoUrl),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12.0),
              _PillDotsControlsRow(
                activeIndex: _activeScreenIndex,
                totalCount: _screens.length,
                accentColor: widget.project.accentColor,
                isPaused: widget.isMotionPaused,
                onPrev: () => _stepScreen(-1),
                onNext: () => _stepScreen(1),
                onSelectDot: (i) => setState(() => _activeScreenIndex = i),
                onTogglePause: widget.onToggleMotionPaused,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Mobile & Compact Tablet Layout (< 960px, ~880px high, single interactive bezel)
  // ---------------------------------------------------------------------------
  Widget _buildMobileShowcase({
    required double leftPadding,
    required double rightPadding,
    required double phoneWidth,
  }) {
    final screenW = MediaQuery.sizeOf(context).width;
    final isMobile = screenW < AppSpacing.tablet;

    return Padding(
      padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  widget.project.logoAsset,
                  width: 44.0,
                  height: 44.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.project.projectIndexLabel} · ${widget.project.categoryTag}',
                      style: AppTextStyles.labelSmall(
                        color: widget.project.accentColor,
                        fontWeight: FontWeight.w600,
                        tabular: true,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Semantics(
                      header: true,
                      child: Text(
                        widget.project.title,
                        style: AppTextStyles.projectTitle(isMobile: isMobile),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Text(
            widget.project.subtitle,
            style: AppTextStyles.cardTitle(isMobile: isMobile).copyWith(
              color: widget.project.accentColor,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            widget.project.problemStatement,
            style: AppTextStyles.bodyDefault(),
          ),
          const SizedBox(height: 18.0),
          Center(
            child: InteractiveRightPhoneMockup(
              project: widget.project,
              width: phoneWidth,
              previewAssetsOverride: _screens,
              controlledIndex: _activeScreenIndex,
              isPaused: widget.isMotionPaused,
              onScreenChanged: (next) =>
                  setState(() => _activeScreenIndex = next),
              onOpenLiveDemo: () =>
                  widget.onOpenUrl(widget.project.liveDemoUrl),
            ),
          ),
          const SizedBox(height: 12.0),
          Center(
            child: _ShowcaseScreenControlsRow(
              activeIndex: _activeScreenIndex,
              totalCount: _screens.length,
              accentColor: widget.project.accentColor,
              isPaused: widget.isMotionPaused,
              onPrev: () => _stepScreen(-1),
              onNext: () => _stepScreen(1),
              onTogglePause: widget.onToggleMotionPaused,
            ),
          ),
          const SizedBox(height: 18.0),
          for (final item in widget.project.engineeringHighlights) ...[
            Text(
              '• ${item.title}: ',
              style: AppTextStyles.labelSmall(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2.0),
            Text(
              item.detail,
              style: AppTextStyles.bodyDefault(color: AppColors.textSecondary)
                  .copyWith(fontSize: 14.0),
            ),
            const SizedBox(height: 10.0),
          ],
          const SizedBox(height: 6.0),
          Text(
            widget.project.scopeSummary,
            style: AppTextStyles.labelSmall(
              color: AppColors.textMuted,
              tabular: true,
            ),
          ),
          const SizedBox(height: 14.0),
          Wrap(
            spacing: 12.0,
            runSpacing: 10.0,
            children: [
              PortfolioActionButton(
                label: 'Open Live Demo ↗',
                variant: PortfolioButtonVariant.accentPill,
                accentColor: widget.project.accentColor,
                borderRadiusOverride: widget.concept.buttonRadius,
                onPressed: () => widget.onOpenUrl(widget.project.liveDemoUrl),
              ),
              PortfolioActionButton(
                label: 'View Source on GitHub ↗',
                variant: PortfolioButtonVariant.secondary,
                borderRadiusOverride: widget.concept.buttonRadius,
                onPressed: () => widget.onOpenUrl(widget.project.repoUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BoundaryHairlineRule extends StatelessWidget {
  const _BoundaryHairlineRule({required this.concept});

  final PortfolioConceptId concept;

  @override
  Widget build(BuildContext context) {
    return switch (concept) {
      PortfolioConceptId.editorialWall => Container(
          height: 1.0,
          width: double.infinity,
          color: const Color(0x24FFFFFF),
        ),
      PortfolioConceptId.swissGrid => Container(
          height: 1.0,
          width: double.infinity,
          color: AppColors.swissGridBorder,
        ),
      PortfolioConceptId.kineticStage => Container(
          height: 1.0,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Color(0x3DFFFFFF),
                Colors.transparent,
              ],
            ),
          ),
        ),
    };
  }
}

class _EditorialTopTagStrip extends StatelessWidget {
  const _EditorialTopTagStrip({
    required this.project,
    required this.leftPadding,
    required this.rightPadding,
    required this.isMotionPaused,
    required this.onToggleMotionPaused,
  });

  final ProjectShowcase project;
  final double leftPadding;
  final double rightPadding;
  final bool isMotionPaused;
  final VoidCallback onToggleMotionPaused;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        top: 6.0,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: Row(
            children: [
              Text(
                '${project.projectIndexLabel} · ${project.title.toUpperCase()}',
                style: AppTextStyles.labelSmall(
                  color: project.accentColor,
                  fontWeight: FontWeight.w700,
                  tabular: true,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  project.categoryTag,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelSmall(
                    color: AppColors.textMuted,
                    tabular: true,
                  ),
                ),
              ),
              _PauseMotionButton(
                isPaused: isMotionPaused,
                accentColor: project.accentColor,
                label: isMotionPaused ? 'Play bg' : 'Pause bg',
                onTap: onToggleMotionPaused,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwissProjectSpecStrip extends StatelessWidget {
  const _SwissProjectSpecStrip({
    required this.project,
    required this.leftPadding,
    required this.rightPadding,
    required this.onOpenDemo,
  });

  final ProjectShowcase project;
  final double leftPadding;
  final double rightPadding;
  final VoidCallback onOpenDemo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        top: 6.0,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
            decoration: const BoxDecoration(
              color: AppColors.bgSurface,
              border: Border(
                top: BorderSide(color: AppColors.swissGridBorder, width: 1.0),
                left: BorderSide(color: AppColors.swissGridBorder, width: 1.0),
                right: BorderSide(color: AppColors.swissGridBorder, width: 1.0),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'PROJECT ${project.projectIndexLabel} // ${project.title.toUpperCase()}',
                  style: AppTextStyles.labelSmall(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    tabular: true,
                  ),
                ),
                const Spacer(),
                Text(
                  project.architectureTag,
                  style: AppTextStyles.labelSmall(
                    color: AppColors.textSecondary,
                    tabular: true,
                  ),
                ),
                const SizedBox(width: 20.0),
                Text(
                  '${project.testCount} TESTS',
                  style: AppTextStyles.labelSmall(
                    color: project.accentColor,
                    fontWeight: FontWeight.w700,
                    tabular: true,
                  ),
                ),
                const SizedBox(width: 12.0),
                IconButton(
                  onPressed: onOpenDemo,
                  tooltip: 'Open ${project.title} live demo',
                  icon: const Icon(Icons.north_east_rounded, size: 16.0),
                  color: AppColors.textPrimary,
                  constraints: const BoxConstraints(
                    minWidth: 44.0,
                    minHeight: 44.0,
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

class _ProjectNarrativeColumn extends StatelessWidget {
  const _ProjectNarrativeColumn({
    required this.project,
    required this.concept,
    required this.isMobile,
    required this.isCompactDesktop,
    required this.useAccentSpine,
    required this.useIndexedArchitecture,
    required this.onOpenUrl,
  });

  final ProjectShowcase project;
  final PortfolioConceptId concept;
  final bool isMobile;
  final bool isCompactDesktop;
  final bool useAccentSpine;
  final bool useIndexedArchitecture;
  final ValueChanged<String> onOpenUrl;

  @override
  Widget build(BuildContext context) {
    final problemText = Text(
      project.problemStatement,
      style: AppTextStyles.bodyDefault(color: AppColors.textSecondary).copyWith(
        fontSize: isCompactDesktop ? 14.0 : 15.0,
      ),
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
                width: isCompactDesktop ? 40.0 : 48.0,
                height: isCompactDesktop ? 40.0 : 48.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      project.title,
                      style: AppTextStyles.projectTitle(isMobile: isMobile)
                          .copyWith(fontSize: isCompactDesktop ? 24.0 : null),
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    project.subtitle,
                    style: AppTextStyles.cardTitle(isMobile: isMobile).copyWith(
                      color: project.accentColor,
                      fontSize: isCompactDesktop ? 15.5 : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: isCompactDesktop ? 8.0 : 18.0),
        if (useIndexedArchitecture) ...[
          Text(
            'THE GAP',
            style: AppTextStyles.labelSmall(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w700,
              tabular: true,
            ),
          ),
          const SizedBox(height: 4.0),
          problemText,
        ] else if (useAccentSpine)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 2.0,
                  margin: const EdgeInsets.only(right: 14.0),
                  color: project.accentColor,
                ),
                Expanded(child: problemText),
              ],
            ),
          )
        else
          problemText,
        SizedBox(height: isCompactDesktop ? 10.0 : 20.0),
        if (useIndexedArchitecture) ...[
          Text(
            'ARCHITECTURE',
            style: AppTextStyles.labelSmall(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w700,
              tabular: true,
            ),
          ),
          const SizedBox(height: 4.0),
        ],
        for (var i = 0; i < project.engineeringHighlights.length; i++) ...[
          Padding(
            padding: EdgeInsets.only(bottom: isCompactDesktop ? 6.0 : 12.0),
            child: useIndexedArchitecture
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '0${i + 1}',
                        style: AppTextStyles.labelSmall(
                          color: project.accentColor,
                          fontWeight: FontWeight.w700,
                          tabular: true,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.engineeringHighlights[i].title,
                              style: AppTextStyles.labelSmall(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              project.engineeringHighlights[i].detail,
                              style: AppTextStyles.labelSmall(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '•  ${project.engineeringHighlights[i].title}: ',
                          style: AppTextStyles.bodyDefault(
                            color: AppColors.textPrimary,
                          ).copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: isCompactDesktop ? 14.0 : 14.5,
                          ),
                        ),
                        TextSpan(
                          text: project.engineeringHighlights[i].detail,
                          style: AppTextStyles.bodyDefault(
                            color: AppColors.textSecondary,
                          ).copyWith(
                            fontSize: isCompactDesktop ? 14.0 : 14.5,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
        SizedBox(height: isCompactDesktop ? 2.0 : 8.0),
        Text(
          project.scopeSummary,
          style: AppTextStyles.labelSmall(
            color: AppColors.textMuted,
            tabular: true,
          ),
        ),
        SizedBox(height: isCompactDesktop ? 6.0 : 20.0),
        Wrap(
          spacing: 12.0,
          runSpacing: 10.0,
          children: [
            PortfolioActionButton(
              label: 'Open Live Demo ↗',
              variant: PortfolioButtonVariant.accentPill,
              accentColor: project.accentColor,
              borderRadiusOverride: concept.buttonRadius,
              height: isCompactDesktop ? 44.0 : 46.0,
              onPressed: () => onOpenUrl(project.liveDemoUrl),
            ),
            PortfolioActionButton(
              label: 'View Source on GitHub ↗',
              variant: PortfolioButtonVariant.secondary,
              borderRadiusOverride: concept.buttonRadius,
              height: isCompactDesktop ? 44.0 : 46.0,
              onPressed: () => onOpenUrl(project.repoUrl),
            ),
          ],
        ),
      ],
    );
  }
}

class _ShowcaseScreenControlsRow extends StatelessWidget {
  const _ShowcaseScreenControlsRow({
    required this.activeIndex,
    required this.totalCount,
    required this.accentColor,
    required this.isPaused,
    required this.onPrev,
    required this.onNext,
    required this.onTogglePause,
    this.hintText,
  });

  final int activeIndex;
  final int totalCount;
  final Color accentColor;
  final bool isPaused;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onTogglePause;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 6.0,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _StageStepperButton(
          icon: Icons.chevron_left_rounded,
          semanticLabel: 'Previous app screen',
          onTap: onPrev,
        ),
        Text(
          '${activeIndex + 1} / $totalCount',
          style: AppTextStyles.labelSmall(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            tabular: true,
          ),
        ),
        _StageStepperButton(
          icon: Icons.chevron_right_rounded,
          semanticLabel: 'Next app screen',
          onTap: onNext,
        ),
        _PauseMotionButton(
          isPaused: isPaused,
          accentColor: accentColor,
          onTap: onTogglePause,
        ),
        if (hintText != null)
          Text(
            hintText!,
            style: AppTextStyles.labelSmall(color: AppColors.textMuted),
          ),
      ],
    );
  }
}

class _PillDotsControlsRow extends StatelessWidget {
  const _PillDotsControlsRow({
    required this.activeIndex,
    required this.totalCount,
    required this.accentColor,
    required this.isPaused,
    required this.onPrev,
    required this.onNext,
    required this.onSelectDot,
    required this.onTogglePause,
  });

  final int activeIndex;
  final int totalCount;
  final Color accentColor;
  final bool isPaused;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final ValueChanged<int> onSelectDot;
  final VoidCallback onTogglePause;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StageStepperButton(
          icon: Icons.chevron_left_rounded,
          semanticLabel: 'Previous app screen',
          onTap: onPrev,
        ),
        const SizedBox(width: 6.0),
        for (var i = 0; i < totalCount; i++)
          GestureDetector(
            onTap: () => onSelectDot(i),
            child: Container(
              width: 28.0,
              height: 44.0,
              alignment: Alignment.center,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: activeIndex == i ? 16.0 : 7.0,
                height: 7.0,
                decoration: BoxDecoration(
                  color: activeIndex == i ? accentColor : AppColors.textMuted,
                  borderRadius: BorderRadius.circular(999.0),
                ),
              ),
            ),
          ),
        const SizedBox(width: 6.0),
        _StageStepperButton(
          icon: Icons.chevron_right_rounded,
          semanticLabel: 'Next app screen',
          onTap: onNext,
        ),
        const SizedBox(width: 6.0),
        _PauseMotionButton(
          isPaused: isPaused,
          accentColor: accentColor,
          onTap: onTogglePause,
        ),
      ],
    );
  }
}

class _StageStepperButton extends StatefulWidget {
  const _StageStepperButton({
    required this.icon,
    required this.semanticLabel,
    required this.onTap,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  State<_StageStepperButton> createState() => _StageStepperButtonState();
}

class _StageStepperButtonState extends State<_StageStepperButton> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.semanticLabel,
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
            width: 44.0,
            height: 44.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: _focused
                    ? AppColors.accentEngineering
                    : AppColors.borderHairline,
                width: _focused ? 2.0 : 1.0,
              ),
            ),
            child: Icon(
              widget.icon,
              size: 18.0,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ConsoleIndexButton extends StatefulWidget {
  const _ConsoleIndexButton({
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
  State<_ConsoleIndexButton> createState() => _ConsoleIndexButtonState();
}

class _ConsoleIndexButtonState extends State<_ConsoleIndexButton> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: widget.isSelected,
      label: 'Show screen ${widget.label}',
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
            constraints: const BoxConstraints(minWidth: 44.0, minHeight: 44.0),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? widget.accentColor.withValues(alpha: 0.16)
                  : Colors.transparent,
              border: _focused
                  ? Border.all(color: widget.accentColor, width: 2.0)
                  : null,
            ),
            child: Center(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: Text(
                '[${widget.label}]',
                style: AppTextStyles.labelSmall(
                  color: widget.isSelected
                      ? widget.accentColor
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  tabular: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PauseMotionButton extends StatefulWidget {
  const _PauseMotionButton({
    required this.isPaused,
    required this.accentColor,
    required this.onTap,
    this.label,
  });

  final bool isPaused;
  final Color accentColor;
  final VoidCallback onTap;
  final String? label;

  @override
  State<_PauseMotionButton> createState() => _PauseMotionButtonState();
}

class _PauseMotionButtonState extends State<_PauseMotionButton> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: widget.isPaused,
      label: widget.isPaused
          ? 'Resume background motion'
          : 'Pause background motion',
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
            constraints: const BoxConstraints(minWidth: 44.0, minHeight: 44.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: widget.isPaused
                  ? widget.accentColor.withValues(alpha: 0.16)
                  : AppColors.bgSurface,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: _focused
                    ? widget.accentColor
                    : AppColors.borderHairline,
                width: _focused ? 2.0 : 1.0,
              ),
            ),
            child: Center(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.isPaused
                        ? Icons.play_arrow_rounded
                        : Icons.pause_rounded,
                    size: 16.0,
                    color: widget.isPaused
                        ? widget.accentColor
                        : AppColors.textSecondary,
                  ),
                  if (widget.label != null) ...[
                    const SizedBox(width: 6.0),
                    Text(
                      widget.label!,
                      style: AppTextStyles.labelSmall(
                        color: widget.isPaused
                            ? widget.accentColor
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

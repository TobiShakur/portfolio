import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_text_styles.dart';
import 'package:portfolio/features/portfolio/domain/entities/project_showcase.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/backdrops/horizontal_filmstrip_backdrop.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/portfolio_action_button.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/wide_section_chevron.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/mockups/interactive_right_phone_mockup.dart';

/// Act 1 (`#nutrilens` / `#setpoint`): 1px drafting rules, chill two-row
/// horizontal backdrop, single live cycling phone stage, and Pause controls.
class ProjectShowcaseSection extends StatefulWidget {
  const ProjectShowcaseSection({
    required this.project,
    required this.projectIndex,
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
            ? 198.0
            : (widget.isWideDesktop ? 276.0 : 244.0));

    final Widget mainLayout = widget.isDesktop
        ? _buildDesktopShowcase(
            leftPadding: leftPadding,
            rightPadding: rightPadding,
            phoneWidth: phoneWidth,
            isCompactDesktop: isCompactDesktop,
          )
        : _buildMobileShowcase(
            leftPadding: leftPadding,
            rightPadding: rightPadding,
            phoneWidth: phoneWidth,
          );

    final Widget bodyWithRules = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _BoundaryHairlineRule(),
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
                _EditorialTopTagStrip(
                  project: widget.project,
                  leftPadding: leftPadding,
                  rightPadding: rightPadding,
                ),
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
        const _BoundaryHairlineRule(),
      ],
    );

    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              fit: StackFit.expand,
              children: [
                HorizontalFilmstripBackdrop(
                  imageAssets: _screens,
                  isSectionVisible: widget.isSectionVisible,
                  isPaused: widget.isMotionPaused,
                  desaturate: false,
                  tileWidth: isMobile ? 104.0 : 138.0,
                  tileGap: 18.0,
                  imageOpacity: 0.24,
                  topSpeedPxPerSec: -14.0,
                  bottomSpeedPxPerSec: 12.0,
                  showHorizontalEdgeFade: false,
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.0, 0.48, 0.86, 1.0],
                      colors: [
                        Color(0xF40B0D14),
                        Color(0xEC0B0D14),
                        Color(0x8A0B0D14),
                        Color(0xD40B0D14),
                      ],
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 28.0,
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.bgCanvas,
                            AppColors.canvasTransparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 28.0,
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.bgCanvas,
                            AppColors.canvasTransparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bodyWithRules,
        ],
      ),
    );
  }

  Widget _buildDesktopShowcase({
    required double leftPadding,
    required double rightPadding,
    required double phoneWidth,
    required bool isCompactDesktop,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 50,
          child: _ProjectNarrativeColumn(
            project: widget.project,
            isMobile: false,
            isCompactDesktop: isCompactDesktop,
            onOpenUrl: widget.onOpenUrl,
          ),
        ),
        const SizedBox(width: 36.0),
        Expanded(
          flex: 50,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InteractiveRightPhoneMockup(
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
            ],
          ),
        ),
      ],
    );
  }

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
              item.title,
              style: AppTextStyles.labelSmall(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              item.detail,
              style: AppTextStyles.bodyDefault(color: AppColors.textSecondary)
                  .copyWith(fontSize: 14.0),
            ),
            const SizedBox(height: 12.0),
          ],
          const SizedBox(height: 4.0),
          Text(
            widget.project.scopeSummary,
            style: AppTextStyles.labelSmall(
              color: AppColors.textMuted,
              tabular: true,
            ),
          ),
          const SizedBox(height: 16.0),
          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: [
              PortfolioActionButton(
                label: 'Open live demo',
                trailingIcon: Icons.north_east_rounded,
                variant: PortfolioButtonVariant.accentPill,
                accentColor: widget.project.accentColor,
                borderRadiusOverride: 8.0,
                onPressed: () => widget.onOpenUrl(widget.project.liveDemoUrl),
              ),
              PortfolioActionButton(
                label: 'View source',
                trailingIcon: Icons.north_east_rounded,
                variant: PortfolioButtonVariant.secondary,
                borderRadiusOverride: 8.0,
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
  const _BoundaryHairlineRule();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.0,
      width: double.infinity,
      color: AppColors.borderHairline,
    );
  }
}

class _EditorialTopTagStrip extends StatelessWidget {
  const _EditorialTopTagStrip({
    required this.project,
    required this.leftPadding,
    required this.rightPadding,
  });

  final ProjectShowcase project;
  final double leftPadding;
  final double rightPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        top: 12.0,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: Row(
            children: [
              Text(
                '${project.projectIndexLabel} · ${project.title}',
                style: AppTextStyles.labelSmall(
                  color: project.accentColor,
                  fontWeight: FontWeight.w500,
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
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectNarrativeColumn extends StatelessWidget {
  const _ProjectNarrativeColumn({
    required this.project,
    required this.isMobile,
    required this.isCompactDesktop,
    required this.onOpenUrl,
  });

  final ProjectShowcase project;
  final bool isMobile;
  final bool isCompactDesktop;
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
            const SizedBox(width: 12.0),
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
                  const SizedBox(height: 4.0),
                  Text(
                    project.subtitle,
                    style: AppTextStyles.cardTitle(isMobile: isMobile).copyWith(
                      color: project.accentColor,
                      fontSize: isCompactDesktop ? 15.0 : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: isCompactDesktop ? 8.0 : 16.0),
        problemText,
        SizedBox(height: isCompactDesktop ? 12.0 : 20.0),
        for (var i = 0; i < project.engineeringHighlights.length; i++) ...[
          Padding(
            padding: EdgeInsets.only(bottom: isCompactDesktop ? 8.0 : 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.engineeringHighlights[i].title,
                  style: AppTextStyles.bodyDefault(
                    color: AppColors.textPrimary,
                  ).copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  project.engineeringHighlights[i].detail,
                  style: AppTextStyles.bodyDefault(
                    color: AppColors.textSecondary,
                  ).copyWith(fontSize: 14.0),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 4.0),
        Text(
          project.scopeSummary,
          style: AppTextStyles.labelSmall(
            color: AppColors.textMuted,
            tabular: true,
          ),
        ),
        SizedBox(height: isCompactDesktop ? 12.0 : 20.0),
        Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          children: [
            PortfolioActionButton(
              label: 'Open live demo',
              trailingIcon: Icons.north_east_rounded,
              variant: PortfolioButtonVariant.accentPill,
              accentColor: project.accentColor,
              borderRadiusOverride: 8.0,
              height: 44.0,
              onPressed: () => onOpenUrl(project.liveDemoUrl),
            ),
            PortfolioActionButton(
              label: 'View source',
              trailingIcon: Icons.north_east_rounded,
              variant: PortfolioButtonVariant.secondary,
              borderRadiusOverride: 8.0,
              height: 44.0,
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
  });

  final int activeIndex;
  final int totalCount;
  final Color accentColor;
  final bool isPaused;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onTogglePause;

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

class _PauseMotionButton extends StatefulWidget {
  const _PauseMotionButton({
    required this.isPaused,
    required this.accentColor,
    required this.onTap,
  });

  final bool isPaused;
  final Color accentColor;
  final VoidCallback onTap;

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
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: widget.isPaused
                  ? AppColors.bgSurfaceElevated
                  : AppColors.bgSurface,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: _focused
                    ? widget.accentColor
                    : (widget.isPaused
                        ? AppColors.borderFocus
                        : AppColors.borderHairline),
                width: _focused ? 2.0 : 1.0,
              ),
            ),
            child: Center(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: Icon(
                widget.isPaused
                    ? Icons.play_arrow_rounded
                    : Icons.pause_rounded,
                size: 16.0,
                color: widget.isPaused
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

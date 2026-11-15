import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_text_styles.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_concept_id.dart';
import 'package:portfolio/features/portfolio/presentation/controllers/portfolio_concept_controller.dart';

/// Top-right desktop floating Concept Switcher Menu (`A·Wall | B·Grid | C·Stage | Mix`)
/// with URL synchronization and Hero/Work mixing popover.
class ConceptSwitcherMenu extends StatelessWidget {
  const ConceptSwitcherMenu({
    required this.controller,
    required this.viewportWidth,
    super.key,
  });

  final PortfolioConceptController controller;
  final double viewportWidth;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final compactTabs = viewportWidth < 1120.0;
        final reduceMotion = MediaQuery.disableAnimationsOf(context);
        final animDuration =
            reduceMotion ? Duration.zero : const Duration(milliseconds: 160);

        return Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 18.0, right: 24.0),
            child: RepaintBoundary(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 44.0,
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: const Color(0xEB0A0D12),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: AppColors.borderFocus,
                        width: 1.0,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x99000000),
                          blurRadius: 18.0,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final concept in PortfolioConceptId.values) ...[
                          _ConceptSegmentButton(
                            label: compactTabs
                                ? concept.shortCode
                                : concept.menuLabel,
                            semanticLabel: 'Switch design concept to ${concept.fullName}',
                            isSelected: !controller.isMixed &&
                                controller.heroConcept == concept,
                            isPartiallyActive: controller.isMixed &&
                                (controller.heroConcept == concept ||
                                    controller.workConcept == concept),
                            duration: animDuration,
                            onPressed: () =>
                                controller.selectUnifiedConcept(concept),
                          ),
                        ],
                        Container(
                          width: 1.0,
                          height: 20.0,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          color: AppColors.borderHairline,
                        ),
                        _ConceptSegmentButton(
                          label: controller.isMixed
                              ? '${controller.heroConcept.shortCode}+${controller.workConcept.shortCode}'
                              : 'Mix',
                          semanticLabel: 'Mix Hero and Project concepts',
                          isSelected: controller.isMixExpanded || controller.isMixed,
                          isPartiallyActive: false,
                          duration: animDuration,
                          trailingIcon: controller.isMixExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.tune_rounded,
                          onPressed: controller.toggleMixExpanded,
                        ),
                      ],
                    ),
                  ),
                  if (controller.isMixExpanded) ...[
                    const SizedBox(height: 8.0),
                    _MixConceptPopover(controller: controller),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Compact inline concept switcher embedded inside [MobileTopAppBar] (`< 960px`).
class InlineCompactConceptTabs extends StatelessWidget {
  const InlineCompactConceptTabs({
    required this.controller,
    super.key,
    this.showMixButton = false,
    this.onMixPressed,
  });

  final PortfolioConceptController controller;
  final bool showMixButton;
  final VoidCallback? onMixPressed;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Container(
          height: 44.0,
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: AppColors.borderHairline, width: 1.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final concept in PortfolioConceptId.values)
                _ConceptSegmentButton(
                  label: concept.shortCode,
                  semanticLabel: 'Switch concept to ${concept.fullName}',
                  minWidth: 38.0,
                  height: 40.0,
                  horizontalPadding: 6.0,
                  isSelected:
                      !controller.isMixed && controller.heroConcept == concept,
                  isPartiallyActive: controller.isMixed &&
                      (controller.heroConcept == concept ||
                          controller.workConcept == concept),
                  duration: Duration.zero,
                  onPressed: () => controller.selectUnifiedConcept(concept),
                ),
              if (showMixButton && onMixPressed != null) ...[
                Container(
                  width: 1.0,
                  height: 18.0,
                  color: AppColors.borderHairline,
                ),
                _ConceptSegmentButton(
                  label: 'Mix',
                  semanticLabel: 'Mix Hero and Project concepts',
                  minWidth: 44.0,
                  height: 40.0,
                  horizontalPadding: 8.0,
                  isSelected: controller.isMixed,
                  isPartiallyActive: false,
                  duration: Duration.zero,
                  onPressed: onMixPressed!,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ConceptSegmentButton extends StatefulWidget {
  const _ConceptSegmentButton({
    required this.label,
    required this.semanticLabel,
    required this.isSelected,
    required this.isPartiallyActive,
    required this.duration,
    required this.onPressed,
    this.minWidth = 44.0,
    this.height = 36.0,
    this.horizontalPadding = 10.0,
    this.trailingIcon,
  });

  final String label;
  final String semanticLabel;
  final bool isSelected;
  final bool isPartiallyActive;
  final Duration duration;
  final VoidCallback onPressed;
  final double minWidth;
  final double height;
  final double horizontalPadding;
  final IconData? trailingIcon;

  @override
  State<_ConceptSegmentButton> createState() => _ConceptSegmentButtonState();
}

class _ConceptSegmentButtonState extends State<_ConceptSegmentButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    if (widget.isSelected) {
      bg = AppColors.accentEngineering;
      fg = AppColors.ctaInkOnAccent;
    } else if (widget.isPartiallyActive) {
      bg = AppColors.accentEngineering.withValues(alpha: 0.16);
      fg = AppColors.accentEngineering;
    } else if (_hovered || _focused) {
      bg = AppColors.bgSurfaceElevated;
      fg = AppColors.textPrimary;
    } else {
      bg = Colors.transparent;
      fg = AppColors.textSecondary;
    }

    return Semantics(
      button: true,
      selected: widget.isSelected,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: (v) => setState(() => _hovered = v),
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onPressed();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44.0, minWidth: 40.0),
            child: Center(
              child: AnimatedContainer(
                duration: widget.duration,
                curve: Curves.easeOutCubic,
                constraints: BoxConstraints(
                  minWidth: widget.minWidth,
                  minHeight: widget.height,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: widget.horizontalPadding,
                ),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(8.0),
                  border: _focused
                      ? Border.all(
                          color: AppColors.accentEngineering,
                          width: 2.0,
                        )
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.label,
                      style: AppTextStyles.labelSmall(
                        color: fg,
                        fontWeight: widget.isSelected
                            ? FontWeight.w700
                            : FontWeight.w600,
                      ),
                    ),
                    if (widget.trailingIcon != null) ...[
                      const SizedBox(width: 4.0),
                      Icon(widget.trailingIcon, size: 15.0, color: fg),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MixConceptPopover extends StatelessWidget {
  const _MixConceptPopover({required this.controller});

  final PortfolioConceptController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.0,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: const Color(0xF50A0D12),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.borderFocus, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0xAA000000),
            blurRadius: 24.0,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Mix Hero & Stage',
                  style: AppTextStyles.labelSmall(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: controller.syncMatchingToHero,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.accentEngineering,
                  minimumSize: const Size(44.0, 36.0),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                ),
                child: const Text('Sync matching'),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          _MixRow(
            title: 'Hero (#overview)',
            selected: controller.heroConcept,
            onSelect: controller.setHeroConcept,
          ),
          const SizedBox(height: 8.0),
          _MixRow(
            title: 'Work & Stage',
            selected: controller.workConcept,
            onSelect: controller.setWorkConcept,
          ),
        ],
      ),
    );
  }
}

class _MixRow extends StatelessWidget {
  const _MixRow({
    required this.title,
    required this.selected,
    required this.onSelect,
  });

  final String title;
  final PortfolioConceptId selected;
  final ValueChanged<PortfolioConceptId> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.labelSmall(color: AppColors.textSecondary),
          ),
        ),
        for (final concept in PortfolioConceptId.values)
          _ConceptSegmentButton(
            label: concept.shortCode,
            semanticLabel: '$title: ${concept.fullName}',
            minWidth: 38.0,
            height: 36.0,
            horizontalPadding: 6.0,
            isSelected: selected == concept,
            isPartiallyActive: false,
            duration: Duration.zero,
            onPressed: () => onSelect(concept),
          ),
      ],
    );
  }
}

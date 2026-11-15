import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_text_styles.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_concept_id.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_section_id.dart';
import 'package:portfolio/features/portfolio/presentation/controllers/portfolio_concept_controller.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/navigation/concept_switcher_menu.dart';

/// Fixed opaque 56px top navigation bar for Tablet & Mobile (`< 960px`).
/// Placed in a layout Column above scrolling content so it never collides with text.
class MobileTopAppBar extends StatelessWidget {
  const MobileTopAppBar({
    required this.activeSection,
    required this.onSelectSection,
    required this.conceptController,
    required this.isTablet,
    super.key,
  });

  final PortfolioSectionId activeSection;
  final ValueChanged<PortfolioSectionId> onSelectSection;
  final PortfolioConceptController conceptController;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.mobileTopBarHeight,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 20.0 : 12.0,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bgCanvas,
        border: Border(
          bottom: BorderSide(color: AppColors.borderHairline, width: 1.0),
        ),
      ),
      child: Row(
        children: [
          _BrandHomePill(
            isActive: activeSection == PortfolioSectionId.overview,
            onTap: () => onSelectSection(PortfolioSectionId.overview),
          ),
          const SizedBox(width: 8.0),
          if (isTablet)
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final section in PortfolioSectionId.values)
                      _TabletNavTextLink(
                        label: section == PortfolioSectionId.nutrilens
                            ? 'NutriLens'
                            : section.navLabel,
                        isActive: activeSection == section,
                        accentColor: section.accentColor,
                        onTap: () => onSelectSection(section),
                      ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: _MobileSectionMenuTrigger(
                  activeSection: activeSection,
                  onPressed: () => _openMobileNavSheet(context),
                ),
              ),
            ),
          const SizedBox(width: 8.0),
          InlineCompactConceptTabs(
            controller: conceptController,
            showMixButton: isTablet,
            onMixPressed: isTablet ? () => _openMobileNavSheet(context) : null,
          ),
        ],
      ),
    );
  }

  void _openMobileNavSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.0)),
        side: BorderSide(color: AppColors.borderFocus, width: 1.0),
      ),
      builder: (sheetContext) {
        return ListenableBuilder(
          listenable: conceptController,
          builder: (context, _) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jump to Section',
                      style: AppTextStyles.cardTitle(isMobile: true),
                    ),
                    const SizedBox(height: 10.0),
                    for (final section in PortfolioSectionId.values)
                      InkWell(
                        onTap: () {
                          Navigator.of(sheetContext).pop();
                          onSelectSection(section);
                        },
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 48.0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 10.0,
                          ),
                          decoration: BoxDecoration(
                            color: activeSection == section
                                ? section.accentColor.withValues(alpha: 0.14)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8.0,
                                height: 8.0,
                                decoration: BoxDecoration(
                                  color: section.accentColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Text(
                                section.navLabel,
                                style: AppTextStyles.bodyDefault(
                                  color: activeSection == section
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const Divider(color: AppColors.borderHairline, height: 24.0),
                    Text(
                      'Mix Hero & Project Concept',
                      style: AppTextStyles.labelSmall(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    _MobileMixSelectorRow(
                      label: 'Hero',
                      selected: conceptController.heroConcept,
                      onSelect: conceptController.setHeroConcept,
                    ),
                    const SizedBox(height: 8.0),
                    _MobileMixSelectorRow(
                      label: 'Work',
                      selected: conceptController.workConcept,
                      onSelect: conceptController.setWorkConcept,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _BrandHomePill extends StatefulWidget {
  const _BrandHomePill({
    required this.isActive,
    required this.onTap,
  });

  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_BrandHomePill> createState() => _BrandHomePillState();
}

class _BrandHomePillState extends State<_BrandHomePill> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Jump to Overview',
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
              color: widget.isActive
                  ? AppColors.accentEngineering.withValues(alpha: 0.16)
                  : AppColors.bgSurface,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: _focused || widget.isActive
                    ? AppColors.accentEngineering
                    : AppColors.borderHairline,
                width: _focused ? 2.0 : 1.0,
              ),
            ),
            child: Text(
              'TG',
              style: AppTextStyles.labelSmall(
                color: widget.isActive
                    ? AppColors.accentEngineering
                    : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileSectionMenuTrigger extends StatefulWidget {
  const _MobileSectionMenuTrigger({
    required this.activeSection,
    required this.onPressed,
  });

  final PortfolioSectionId activeSection;
  final VoidCallback onPressed;

  @override
  State<_MobileSectionMenuTrigger> createState() =>
      _MobileSectionMenuTriggerState();
}

class _MobileSectionMenuTriggerState extends State<_MobileSectionMenuTrigger> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Open sections menu (${widget.activeSection.navLabel})',
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
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
            constraints: const BoxConstraints(minWidth: 108.0, minHeight: 44.0),
            child: Container(
              height: 40.0,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.0,
                    height: 6.0,
                    decoration: BoxDecoration(
                      color: widget.activeSection.accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6.0),
                  Flexible(
                    child: Text(
                      widget.activeSection.navLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelSmall(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 16.0,
                    color: AppColors.textSecondary,
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

class _TabletNavTextLink extends StatefulWidget {
  const _TabletNavTextLink({
    required this.label,
    required this.isActive,
    required this.accentColor,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  State<_TabletNavTextLink> createState() => _TabletNavTextLinkState();
}

class _TabletNavTextLinkState extends State<_TabletNavTextLink> {
  bool _focused = false;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: widget.isActive,
      label: 'Jump to ${widget.label}',
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        onShowHoverHighlight: (v) => setState(() => _hovered = v),
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
            constraints: const BoxConstraints(minHeight: 44.0, minWidth: 44.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: _focused
                  ? Border.all(color: widget.accentColor, width: 2.0)
                  : null,
            ),
            child: Center(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: Text(
                widget.label,
                style: AppTextStyles.labelSmall(
                  color: widget.isActive
                      ? widget.accentColor
                      : (_hovered ? AppColors.textPrimary : AppColors.textSecondary),
                  fontWeight:
                      widget.isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileMixSelectorRow extends StatelessWidget {
  const _MobileMixSelectorRow({
    required this.label,
    required this.selected,
    required this.onSelect,
  });

  final String label;
  final PortfolioConceptId selected;
  final ValueChanged<PortfolioConceptId> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 48.0,
          child: Text(
            label,
            style: AppTextStyles.labelSmall(color: AppColors.textSecondary),
          ),
        ),
        for (final concept in PortfolioConceptId.values) ...[
          const SizedBox(width: 6.0),
          Expanded(
            child: OutlinedButton(
              onPressed: () => onSelect(concept),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(44.0, 44.0),
                backgroundColor: selected == concept
                    ? AppColors.accentEngineering
                    : AppColors.bgSurfaceElevated,
                foregroundColor: selected == concept
                    ? AppColors.ctaInkOnAccent
                    : AppColors.textPrimary,
                side: BorderSide(
                  color: selected == concept
                      ? AppColors.accentEngineering
                      : AppColors.borderHairline,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(concept.menuLabel),
            ),
          ),
        ],
      ],
    );
  }
}

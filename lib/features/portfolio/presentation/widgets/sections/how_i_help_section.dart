import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_text_styles.dart';
import 'package:portfolio/features/portfolio/data/portfolio_catalog.dart';
import 'package:portfolio/features/portfolio/domain/entities/profile_data.dart';

/// Section 1 (#how-i-help): Vertical 1 -> 2 -> 3 -> 4 stepper explaining how
/// Tobías works with startups, freelance clients, and remote product teams.
class HowIHelpSection extends StatelessWidget {
  const HowIHelpSection({
    required this.steps,
    required this.isDesktop,
    required this.isMobile,
    super.key,
    this.sectionHeight,
  });

  final List<SnapshotHighlight> steps;
  final bool isDesktop;
  final bool isMobile;
  final double? sectionHeight;

  @override
  Widget build(BuildContext context) {
    final compactVertical =
        isDesktop && sectionHeight != null && sectionHeight! < 820.0;

    final horizontalPadding = isDesktop
        ? const EdgeInsets.only(
            left: AppSpacing.desktopLeftSafePadding,
            right: AppSpacing.desktopRightPaddingWide,
          )
        : EdgeInsets.symmetric(
            horizontal: isMobile ? 20.0 : 32.0,
          );

    final content = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 880.0),
        child: Padding(
          padding: horizontalPadding.add(
            EdgeInsets.symmetric(
              vertical: isDesktop
                  ? (compactVertical ? 20.0 : 28.0)
                  : AppSpacing.sectionVerticalMobile,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WORKING TOGETHER',
                style: AppTextStyles.labelSmall(
                  color: AppColors.accentEngineering,
                  fontWeight: FontWeight.w600,
                ).copyWith(letterSpacing: 1.4),
              ),
              const SizedBox(height: 10.0),
              Text(
                PortfolioCatalog.howIHelpSectionTitle,
                style: AppTextStyles.sectionHeading(isMobile: isMobile),
              ),
              const SizedBox(height: 8.0),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 660.0),
                child: Text(
                  PortfolioCatalog.howIHelpSectionSubtitle,
                  style: AppTextStyles.bodyLead(isMobile: isMobile),
                ),
              ),
              SizedBox(height: compactVertical ? 24.0 : 34.0),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 740.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < steps.length; i++)
                      _TimelineStepRow(
                        stepNumber: i + 1,
                        step: steps[i],
                        isLast: i == steps.length - 1,
                        compact: compactVertical,
                        isMobile: isMobile,
                      ),
                  ],
                ),
              ),
            ],
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

class _TimelineStepRow extends StatelessWidget {
  const _TimelineStepRow({
    required this.stepNumber,
    required this.step,
    required this.isLast,
    required this.compact,
    required this.isMobile,
  });

  final int stepNumber;
  final SnapshotHighlight step;
  final bool isLast;
  final bool compact;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final bottomGap = isLast ? 0.0 : (compact ? 18.0 : 24.0);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 32.0,
            child: Column(
              children: [
                Container(
                  width: 32.0,
                  height: 32.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.bgSurface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.accentEngineering.withValues(alpha: 0.65),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    '$stepNumber',
                    style: AppTextStyles.labelSmall(
                      color: AppColors.accentEngineering,
                      fontWeight: FontWeight.w700,
                    ).copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: const Color(0xFF2A313D),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: isMobile ? 14.0 : 20.0),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 3.0, bottom: bottomGap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    step.label,
                    style: AppTextStyles.cardTitle(isMobile: isMobile),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    step.value,
                    style: AppTextStyles.bodyDefault(
                      color: AppColors.textSecondary,
                    ).copyWith(
                      fontSize: compact ? 14.5 : 15.5,
                      height: 1.5,
                      fontFeatures: step.tabular
                          ? const [FontFeature.tabularFigures()]
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_text_styles.dart';
import 'package:portfolio/features/portfolio/data/portfolio_catalog.dart';
import 'package:portfolio/features/portfolio/domain/entities/capability_row.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_concept_id.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/wide_section_chevron.dart';

/// Act 2 (`#capabilities`): verified MatchUp Apple App Store 5.0★ client proof
/// paired with 4 clean indexed capability rows (<= 580px content height on desktop).
class CapabilitiesSection extends StatelessWidget {
  const CapabilitiesSection({
    required this.concept,
    required this.isDesktop,
    required this.isWideDesktop,
    required this.sectionHeight,
    required this.onChevronNext,
    super.key,
  });

  final PortfolioConceptId concept;
  final bool isDesktop;
  final bool isWideDesktop;
  final double sectionHeight;
  final VoidCallback onChevronNext;

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final isMobile = screenW < AppSpacing.tablet;
    final isCompactDesktop = isDesktop && sectionHeight < 780.0;

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

    final proofRadius = switch (concept) {
      PortfolioConceptId.editorialWall => 10.0,
      PortfolioConceptId.swissGrid => 6.0,
      PortfolioConceptId.kineticStage => 16.0,
    };

    final borderColor = concept == PortfolioConceptId.swissGrid
        ? AppColors.swissGridBorder
        : AppColors.borderHairline;

    final content = Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        top: isDesktop ? (isCompactDesktop ? 16.0 : 28.0) : 32.0,
        bottom: isDesktop ? 8.0 : 24.0,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upper Band: MatchUp Apple App Store 5.0★ Client Proof Strip
              _MatchUpProofBanner(
                proof: PortfolioCatalog.matchUpProof,
                isMobile: isMobile,
                isCompactDesktop: isCompactDesktop,
                borderRadius: proofRadius,
                borderColor: borderColor,
              ),
              SizedBox(height: isCompactDesktop ? 22.0 : 32.0),
              Semantics(
                header: true,
                child: Text(
                  PortfolioCatalog.capabilitiesSectionTitle,
                  style: AppTextStyles.sectionHeading(isMobile: isMobile)
                      .copyWith(fontSize: isCompactDesktop ? 30.0 : null),
                ),
              ),
              const SizedBox(height: 6.0),
              Text(
                PortfolioCatalog.capabilitiesSectionSubtitle,
                style: AppTextStyles.bodyLead(isMobile: isMobile).copyWith(
                  fontSize: isCompactDesktop ? 15.5 : null,
                ),
              ),
              SizedBox(height: isCompactDesktop ? 16.0 : 22.0),
              Container(height: 1.0, color: borderColor),
              for (final row in PortfolioCatalog.capabilityRows)
                _CapabilityLedgerRow(
                  row: row,
                  isMobile: isMobile,
                  isCompactDesktop: isCompactDesktop,
                  borderColor: borderColor,
                ),
            ],
          ),
        ),
      ),
    );

    if (isDesktop) {
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: sectionHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox.shrink(),
            content,
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Center(
                child: WideSectionChevron(
                  semanticLabel: 'Scroll to Contact & Resume options',
                  onPressed: onChevronNext,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        content,
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Center(
            child: WideSectionChevron(
              semanticLabel: 'Scroll to Contact section',
              onPressed: onChevronNext,
            ),
          ),
        ),
      ],
    );
  }
}

class _MatchUpProofBanner extends StatelessWidget {
  const _MatchUpProofBanner({
    required this.proof,
    required this.isMobile,
    required this.isCompactDesktop,
    required this.borderRadius,
    required this.borderColor,
  });

  final ClientAppProof proof;
  final bool isMobile;
  final bool isCompactDesktop;
  final double borderRadius;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final leftInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          proof.badgeLabel,
          style: AppTextStyles.labelSmall(
            color: AppColors.accentEngineering,
            fontWeight: FontWeight.w700,
            tabular: true,
          ),
        ),
        const SizedBox(height: 6.0),
        Text(
          proof.title,
          style: AppTextStyles.cardTitle(isMobile: isMobile).copyWith(
            fontSize: isMobile ? 18.0 : (isCompactDesktop ? 18.5 : 20.0),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6.0),
        Text(
          proof.summary,
          style: AppTextStyles.bodyDefault(color: AppColors.textSecondary)
              .copyWith(fontSize: 14.0),
        ),
      ],
    );

    final rightSpecs = Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          proof.platformsLine,
          style: AppTextStyles.labelSmall(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            tabular: true,
          ),
        ),
        const SizedBox(height: 6.0),
        Text(
          proof.stackLine,
          textAlign: isMobile ? TextAlign.start : TextAlign.end,
          style: AppTextStyles.labelSmall(
            color: AppColors.textSecondary,
            tabular: true,
          ),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16.0 : 24.0,
        vertical: isCompactDesktop ? 14.0 : 18.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                leftInfo,
                const SizedBox(height: 12.0),
                rightSpecs,
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 60, child: leftInfo),
                const SizedBox(width: 24.0),
                Expanded(flex: 40, child: rightSpecs),
              ],
            ),
    );
  }
}

class _CapabilityLedgerRow extends StatefulWidget {
  const _CapabilityLedgerRow({
    required this.row,
    required this.isMobile,
    required this.isCompactDesktop,
    required this.borderColor,
  });

  final CapabilityRowItem row;
  final bool isMobile;
  final bool isCompactDesktop;
  final Color borderColor;

  @override
  State<_CapabilityLedgerRow> createState() => _CapabilityLedgerRowState();
}

class _CapabilityLedgerRowState extends State<_CapabilityLedgerRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final row = widget.row;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: widget.isMobile ? 4.0 : 12.0,
          vertical: widget.isMobile
              ? 14.0
              : (widget.isCompactDesktop ? 11.0 : 14.0),
        ),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.bgSurface : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: widget.borderColor, width: 1.0),
          ),
        ),
        child: widget.isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        row.indexLabel,
                        style: AppTextStyles.labelSmall(
                          color: AppColors.accentEngineering,
                          fontWeight: FontWeight.w700,
                          tabular: true,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          row.title,
                          style: AppTextStyles.cardTitle(isMobile: true)
                              .copyWith(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    row.description,
                    style: AppTextStyles.bodyDefault(
                      color: AppColors.textSecondary,
                    ).copyWith(fontSize: 14.0),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    row.techSpecs,
                    style: AppTextStyles.labelSmall(
                      color: AppColors.textMuted,
                      tabular: true,
                    ),
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 28,
                    child: Row(
                      children: [
                        Text(
                          row.indexLabel,
                          style: AppTextStyles.labelSmall(
                            color: AppColors.accentEngineering,
                            fontWeight: FontWeight.w700,
                            tabular: true,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Text(
                            row.title,
                            style: AppTextStyles.cardTitle(isMobile: false)
                                .copyWith(
                              fontSize: widget.isCompactDesktop ? 15.5 : 17.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    flex: 44,
                    child: Text(
                      row.description,
                      style: AppTextStyles.bodyDefault(
                        color: AppColors.textSecondary,
                      ).copyWith(fontSize: 14.0),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    flex: 28,
                    child: Text(
                      row.techSpecs,
                      textAlign: TextAlign.end,
                      style: AppTextStyles.labelSmall(
                        color: AppColors.textMuted,
                        tabular: true,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

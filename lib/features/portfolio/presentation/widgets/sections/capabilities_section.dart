import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_text_styles.dart';
import 'package:portfolio/features/portfolio/data/portfolio_catalog.dart';
import 'package:portfolio/features/portfolio/domain/entities/capability_row.dart';
import 'package:portfolio/features/portfolio/domain/entities/tech_brand.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/tech_brand_icon.dart';

/// Act 2 (`#capabilities`): verified MatchUp Apple App Store 5.0 client proof,
/// 4 streamlined 2-column capability rows, and minimal outlined platform badges.
class CapabilitiesSection extends StatelessWidget {
  const CapabilitiesSection({
    required this.isDesktop,
    required this.isWideDesktop,
    required this.sectionHeight,
    super.key,
  });

  final bool isDesktop;
  final bool isWideDesktop;
  final double sectionHeight;

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

    const proofRadius = 10.0;
    const borderColor = AppColors.borderHairline;

    final content = Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        top: isDesktop ? (isCompactDesktop ? 16.0 : 24.0) : 32.0,
        bottom: isDesktop ? (isCompactDesktop ? 16.0 : 24.0) : 32.0,
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
              // Upper Band: MatchUp Apple App Store 5.0 Client Proof Strip
              _MatchUpProofBanner(
                proof: PortfolioCatalog.matchUpProof,
                isMobile: isMobile,
                isCompactDesktop: isCompactDesktop,
                borderRadius: proofRadius,
              ),
              SizedBox(height: isCompactDesktop ? 16.0 : 24.0),
              Semantics(
                header: true,
                child: Text(
                  PortfolioCatalog.capabilitiesSectionTitle,
                  style: AppTextStyles.sectionHeading(isMobile: isMobile)
                      .copyWith(fontSize: isCompactDesktop ? 28.0 : null),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                PortfolioCatalog.capabilitiesSectionSubtitle,
                style: AppTextStyles.bodyLead(isMobile: isMobile).copyWith(
                  fontSize: isCompactDesktop ? 15.0 : null,
                ),
              ),
              SizedBox(height: isCompactDesktop ? 12.0 : 16.0),
              Container(height: 1.0, color: borderColor),
              for (final row in PortfolioCatalog.capabilityRows)
                _CapabilityLedgerRow(
                  row: row,
                  isMobile: isMobile,
                  isCompactDesktop: isCompactDesktop,
                  borderColor: borderColor,
                ),
              SizedBox(height: isCompactDesktop ? 16.0 : 24.0),
              Text(
                'Core platforms & tooling',
                style: AppTextStyles.labelSmall(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  for (final item in PortfolioCatalog.profile.coreStackLogos)
                    _OutlinedPlatformButton(item: item),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (isDesktop) {
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: sectionHeight),
        child: Center(child: content),
      );
    }

    return content;
  }
}

class _MatchUpProofBanner extends StatelessWidget {
  const _MatchUpProofBanner({
    required this.proof,
    required this.isMobile,
    required this.isCompactDesktop,
    required this.borderRadius,
  });

  final ClientAppProof proof;
  final bool isMobile;
  final bool isCompactDesktop;
  final double borderRadius;

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
            fontWeight: FontWeight.w500,
            tabular: true,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          proof.title,
          style: AppTextStyles.cardTitle(isMobile: isMobile).copyWith(
            fontSize: isMobile ? 18.0 : (isCompactDesktop ? 18.0 : 20.0),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8.0),
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
            fontWeight: FontWeight.w500,
            tabular: true,
          ),
        ),
        const SizedBox(height: 8.0),
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
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.borderHairline, width: 1.0),
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
        duration: AppMotion.interactive,
        curve: AppMotion.standardCurve,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: widget.isMobile ? 4.0 : 12.0,
          vertical: 12.0,
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
                      SizedBox(
                        width: 28.0,
                        child: Text(
                          row.indexLabel,
                          style: AppTextStyles.labelSmall(
                            color: AppColors.accentEngineering,
                            fontWeight: FontWeight.w500,
                            tabular: true,
                          ),
                        ),
                      ),
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
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 32,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 28.0,
                          child: Text(
                            row.indexLabel,
                            style: AppTextStyles.labelSmall(
                              color: AppColors.accentEngineering,
                              fontWeight: FontWeight.w500,
                              tabular: true,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            row.title,
                            style: AppTextStyles.cardTitle(isMobile: false)
                                .copyWith(
                              fontSize: widget.isCompactDesktop ? 15.0 : 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    flex: 68,
                    child: Text(
                      row.description,
                      style: AppTextStyles.bodyDefault(
                        color: AppColors.textSecondary,
                      ).copyWith(fontSize: 14.0),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _OutlinedPlatformButton extends StatefulWidget {
  const _OutlinedPlatformButton({required this.item});

  final TechBrandChipItem item;

  @override
  State<_OutlinedPlatformButton> createState() =>
      _OutlinedPlatformButtonState();
}

class _OutlinedPlatformButtonState extends State<_OutlinedPlatformButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        _hovered ? AppColors.borderChipHover : AppColors.borderChip;
    final iconColor = _hovered ? AppColors.textPrimary : AppColors.textSecondary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: AppMotion.interactive,
        curve: AppMotion.standardCurve,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: borderColor, width: 1.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.item.brand != null) ...[
              ColorFiltered(
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                child: TechBrandIcon(brand: widget.item.brand!, size: 16.0),
              ),
              const SizedBox(width: 8.0),
            ],
            Text(
              widget.item.label,
              style: AppTextStyles.labelSmall(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

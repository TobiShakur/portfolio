import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_text_styles.dart';
import 'package:portfolio/features/portfolio/data/portfolio_catalog.dart';
import 'package:portfolio/features/portfolio/domain/entities/engineering_pillar.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/tech_stack_chip.dart';

/// Section 1 (#engineering): 2x2 client capability matrix plus Core Ecosystem
/// brand strip.
class EngineeringApproachSection extends StatelessWidget {
  const EngineeringApproachSection({
    required this.pillars,
    required this.isDesktop,
    required this.isWideDesktop,
    required this.isMobile,
    super.key,
    this.sectionHeight,
  });

  final List<EngineeringPillar> pillars;
  final bool isDesktop;
  final bool isWideDesktop;
  final bool isMobile;
  final double? sectionHeight;

  @override
  Widget build(BuildContext context) {
    final compactVertical =
        isDesktop && sectionHeight != null && sectionHeight! < 820.0;

    final horizontalPadding = isDesktop
        ? EdgeInsets.only(
            left: AppSpacing.desktopLeftSafePadding,
            right: isWideDesktop
                ? AppSpacing.desktopRightPaddingWide
                : AppSpacing.desktopRightPaddingCompact,
          )
        : EdgeInsets.symmetric(
            horizontal: isMobile ? 20.0 : 32.0,
          );

    final content = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
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
                PortfolioCatalog.engineeringSectionTitle,
                style: AppTextStyles.sectionHeading(isMobile: isMobile),
              ),
              const SizedBox(height: 10.0),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720.0),
                child: Text(
                  PortfolioCatalog.engineeringSectionSubtitle,
                  style: AppTextStyles.bodyLead(isMobile: isMobile),
                ),
              ),
              SizedBox(height: compactVertical ? 18.0 : 26.0),
              if (isMobile)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < pillars.length; i++) ...[
                      _PillarCard(
                        pillar: pillars[i],
                        isMobile: true,
                        compact: false,
                      ),
                      if (i < pillars.length - 1) const SizedBox(height: 16.0),
                    ],
                  ],
                )
              else
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _PillarCard(
                              pillar: pillars[0],
                              isMobile: false,
                              compact: compactVertical,
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            child: _PillarCard(
                              pillar: pillars[1],
                              isMobile: false,
                              compact: compactVertical,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _PillarCard(
                              pillar: pillars[2],
                              isMobile: false,
                              compact: compactVertical,
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            child: _PillarCard(
                              pillar: pillars[3],
                              isMobile: false,
                              compact: compactVertical,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              SizedBox(height: compactVertical ? 18.0 : 26.0),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(compactVertical ? 16.0 : 20.0),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(
                    color: AppColors.borderHairline,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CORE ECOSYSTEM',
                      style: AppTextStyles.labelSmall(
                        color: AppColors.accentEngineering,
                        fontWeight: FontWeight.w700,
                      ).copyWith(letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 12.0),
                    Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: [
                        for (final item in PortfolioCatalog.coreEcosystem)
                          TechStackChip(
                            label: item.label,
                            brand: item.brand,
                            iconSize: 18.0,
                            textColor: AppColors.textPrimary,
                            backgroundColor: AppColors.bgSurfaceElevated,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13.0,
                              vertical: 8.0,
                            ),
                          ),
                      ],
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

class _PillarCard extends StatelessWidget {
  const _PillarCard({
    required this.pillar,
    required this.isMobile,
    required this.compact,
  });

  final EngineeringPillar pillar;
  final bool isMobile;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 18.0 : 22.0),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: AppColors.borderHairline,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CustomPaint(
                size: const Size.square(20.0),
                painter: _PillarVectorPainter(
                  kind: pillar.iconKind,
                  color: AppColors.accentEngineering,
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Text(
                  pillar.title,
                  style: AppTextStyles.cardTitle(isMobile: isMobile),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            pillar.description,
            style: AppTextStyles.bodyDefault(),
          ),
          SizedBox(height: compact ? 12.0 : 14.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              for (final badge in pillar.badges)
                TechStackChip(
                  label: badge.label,
                  brand: badge.brand,
                  iconSize: 15.0,
                  textColor: const Color(0xFFD1D5DB),
                  backgroundColor: AppColors.bgSurfaceElevated,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PillarVectorPainter extends CustomPainter {
  const _PillarVectorPainter({
    required this.kind,
    required this.color,
  });

  final EngineeringIconKind kind;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    switch (kind) {
      case EngineeringIconKind.architecture:
        final top = Path()
          ..moveTo(w * 0.5, h * 0.12)
          ..lineTo(w * 0.88, h * 0.34)
          ..lineTo(w * 0.5, h * 0.56)
          ..lineTo(w * 0.12, h * 0.34)
          ..close();
        canvas.drawPath(top, paint);
        canvas.drawPath(
          Path()
            ..moveTo(w * 0.12, h * 0.56)
            ..lineTo(w * 0.5, h * 0.78)
            ..lineTo(w * 0.88, h * 0.56),
          paint,
        );
        canvas.drawPath(
          Path()
            ..moveTo(w * 0.12, h * 0.74)
            ..lineTo(w * 0.5, h * 0.94)
            ..lineTo(w * 0.88, h * 0.74),
          paint,
        );
      case EngineeringIconKind.security:
        final shield = Path()
          ..moveTo(w * 0.5, h * 0.1)
          ..lineTo(w * 0.86, h * 0.24)
          ..lineTo(w * 0.86, h * 0.52)
          ..quadraticBezierTo(w * 0.86, h * 0.78, w * 0.5, h * 0.92)
          ..quadraticBezierTo(w * 0.14, h * 0.78, w * 0.14, h * 0.52)
          ..lineTo(w * 0.14, h * 0.24)
          ..close();
        canvas.drawPath(shield, paint);
        canvas.drawPath(
          Path()
            ..moveTo(w * 0.35, h * 0.5)
            ..lineTo(w * 0.46, h * 0.62)
            ..lineTo(w * 0.67, h * 0.39),
          paint,
        );
      case EngineeringIconKind.geospatial:
        canvas.drawCircle(Offset(w * 0.5, h * 0.42), w * 0.16, paint);
        final pin = Path()
          ..moveTo(w * 0.5, h * 0.92)
          ..quadraticBezierTo(w * 0.18, h * 0.62, w * 0.18, h * 0.42)
          ..arcToPoint(
            Offset(w * 0.82, h * 0.42),
            radius: Radius.circular(w * 0.32),
            clockwise: true,
          )
          ..quadraticBezierTo(w * 0.82, h * 0.62, w * 0.5, h * 0.92);
        canvas.drawPath(pin, paint);
      case EngineeringIconKind.verification:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.14, h * 0.14, w * 0.72, h * 0.72),
            const Radius.circular(4.0),
          ),
          paint,
        );
        canvas.drawPath(
          Path()
            ..moveTo(w * 0.33, h * 0.51)
            ..lineTo(w * 0.45, h * 0.63)
            ..lineTo(w * 0.68, h * 0.38),
          paint,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _PillarVectorPainter oldDelegate) {
    return oldDelegate.kind != kind || oldDelegate.color != color;
  }
}

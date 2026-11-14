import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_text_styles.dart';
import 'package:portfolio/features/portfolio/domain/entities/tech_brand.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/tech_brand_icon.dart';

/// Compact chip displaying stack technology, optional brand icon, or verified test counts.
class TechStackChip extends StatelessWidget {
  const TechStackChip({
    required this.label,
    super.key,
    this.brand,
    this.iconSize = 15.0,
    this.accentColor,
    this.textColor,
    this.backgroundColor,
    this.padding,
    this.isHighlighted = false,
  });

  final String label;
  final TechBrand? brand;
  final double iconSize;
  final Color? accentColor;
  final Color? textColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? AppColors.accentEngineering;
    final resolvedTextColor =
        textColor ?? (isHighlighted ? accent : AppColors.textSecondary);

    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 11.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isHighlighted
                ? accent.withValues(alpha: 0.12)
                : AppColors.bgSurface),
        borderRadius: BorderRadius.circular(999.0),
        border: Border.all(
          color: isHighlighted
              ? accent.withValues(alpha: 0.45)
              : AppColors.borderHairline,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (brand != null) ...[
            TechBrandIcon(
              brand: brand!,
              size: iconSize,
            ),
            const SizedBox(width: 7.0),
          ],
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.labelSmall(
                color: resolvedTextColor,
                fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
                tabular: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_text_styles.dart';

/// Proportional 375x812 (9:19.5) canvas wrapper so NutriLens mini-screens scale
/// cleanly inside any iPhone bezel size without layout overflow.
class _ScaledPhoneCanvas extends StatelessWidget {
  const _ScaledPhoneCanvas({
    required this.backgroundColor,
    required this.child,
  });

  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: 375.0,
          height: 812.0,
          child: child,
        ),
      ),
    );
  }
}

/// Screen 1 (Left Tilted iPhone): Daily Calorie/Macro Ring & Pantry Meals.
class NutriLensHomeRingScreen extends StatelessWidget {
  const NutriLensHomeRingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ScaledPhoneCanvas(
      backgroundColor: AppColors.nutriScaffold,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 74.0, 20.0, 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/icons/nutrilens_icon.webp',
                    width: 30.0,
                    height: 30.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    'NutriLens AI',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.cardTitle(isMobile: true).copyWith(
                      color: AppColors.nutriTextDark,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentNutriLensDeep,
                    borderRadius: BorderRadius.circular(999.0),
                  ),
                  child: Text(
                    'EN',
                    style: AppTextStyles.labelSmall(
                      color: AppColors.accentNutriLens,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                color: AppColors.accentNutriLensDeep,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 108.0,
                        height: 108.0,
                        child: CustomPaint(
                          painter: const _CalorieRingPainter(progress: 0.84),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '1,840',
                                  style: AppTextStyles.cardTitle(
                                    isMobile: true,
                                  ).copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.0,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                                Text(
                                  '2,200 kcal',
                                  style: AppTextStyles.labelSmall(
                                    color: AppColors.accentNutriLens,
                                  ).copyWith(fontSize: 11.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _MacroBarRow(
                              label: 'Protein',
                              value: '138g',
                              progress: 0.86,
                            ),
                            SizedBox(height: 12.0),
                            _MacroBarRow(
                              label: 'Carbs',
                              value: '176g',
                              progress: 0.74,
                            ),
                            SizedBox(height: 12.0),
                            _MacroBarRow(
                              label: 'Fat',
                              value: '58g',
                              progress: 0.78,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 9.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.nutriForestSlot,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '14 Pantry Items',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.labelSmall(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          '88/100',
                          style: AppTextStyles.labelSmall(
                            color: AppColors.accentNutriLens,
                            fontWeight: FontWeight.w700,
                            tabular: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22.0),
            Text(
              'Today\'s Meals',
              style: AppTextStyles.cardTitle(isMobile: true).copyWith(
                color: AppColors.nutriTextDark,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 12.0),
            const _MealListCard(
              title: 'Grilled Chicken & Quinoa',
              subtitle: '3 pantry matches · 580 kcal',
              score: '91',
            ),
            const SizedBox(height: 10.0),
            const _MealListCard(
              title: 'Greek Yogurt & Oats',
              subtitle: 'Barcode matched · 390 kcal',
              score: '86',
            ),
            const SizedBox(height: 10.0),
            const _MealListCard(
              title: 'Salmon & Broccoli',
              subtitle: 'Home-cooked · 640 kcal',
              score: '94',
            ),
            const Spacer(),
            Container(
              height: 48.0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: AppColors.accentNutriLens,
                borderRadius: BorderRadius.circular(999.0),
              ),
              child: Center(
                child: Text(
                  'Scan Meal',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.buttonLabel(
                    color: AppColors.nutriTextDark,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Screen 2 (Right Storyboard Frame 1): Real sample_meal.jpg + Pantry Match + Score.
class NutriLensMealScanScreen extends StatelessWidget {
  const NutriLensMealScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ScaledPhoneCanvas(
      backgroundColor: AppColors.nutriScannerDark,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 74.0, 20.0, 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Vision Meal',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.cardTitle(isMobile: true).copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentNutriLens.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999.0),
                    border: Border.all(
                      color: AppColors.accentNutriLens.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    'Sample',
                    style: AppTextStyles.labelSmall(
                      color: AppColors.accentNutriLens,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(18.0),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/nutrilens_sample_meal.webp',
                    width: double.infinity,
                    height: 250.0,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    left: 12.0,
                    bottom: 12.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11.0,
                        vertical: 5.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.sidebarBg.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(999.0),
                        border: Border.all(color: AppColors.accentNutriLens),
                      ),
                      child: Text(
                        'Health Score: 88/100',
                        style: AppTextStyles.labelSmall(
                          color: AppColors.accentNutriLens,
                          fontWeight: FontWeight.w700,
                          tabular: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18.0),
            Text(
              'Pantry Cross-Match',
              style: AppTextStyles.labelSmall(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10.0),
            const Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                _IngredientPill(label: 'Chicken · Pantry ✓'),
                _IngredientPill(label: 'Quinoa · Pantry ✓'),
                _IngredientPill(label: 'Avocado · 65g'),
                _IngredientPill(label: 'Olive Oil ✓'),
              ],
            ),
            const SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                color: AppColors.accentNutriLensDeep,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '580 kcal · 44g P · 48g C · 21g F',
                    style: AppTextStyles.labelSmall(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      tabular: true,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    'Balanced protein and fiber density matched from local pantry.',
                    style: AppTextStyles.labelSmall(
                      color: AppColors.accentNutriLens,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              height: 48.0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: AppColors.accentNutriLens,
                borderRadius: BorderRadius.circular(999.0),
              ),
              child: Center(
                child: Text(
                  'Log Meal',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.buttonLabel(
                    color: AppColors.nutriTextDark,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Screen 3 (Right Storyboard Frame 2): 3-Mode Pantry Barcode & Label OCR.
class NutriLensPantryScanScreen extends StatelessWidget {
  const NutriLensPantryScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ScaledPhoneCanvas(
      backgroundColor: AppColors.nutriScaffold,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 74.0, 20.0, 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pantry 3-Mode Scanner',
              style: AppTextStyles.cardTitle(isMobile: true).copyWith(
                color: AppColors.nutriTextDark,
                fontSize: 17.0,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Open Food Facts v2 → Gemini',
              style: AppTextStyles.labelSmall(
                color: AppColors.nutriTextMuted,
              ),
            ),
            const SizedBox(height: 18.0),
            const _ScanModeTile(
              badge: 'MODE 1',
              title: 'Barcode Lookup',
              detail: 'UPC/EAN query via Open Food Facts API v2.',
              active: true,
            ),
            const SizedBox(height: 12.0),
            const _ScanModeTile(
              badge: 'MODE 2',
              title: 'Package Front Vision',
              detail: 'Resolves brand conflicts & serving weights.',
              active: false,
            ),
            const SizedBox(height: 12.0),
            const _ScanModeTile(
              badge: 'MODE 3',
              title: 'Nutrition Label OCR',
              detail: 'Extracts exact kcal, macros, and micros.',
              active: false,
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                color: AppColors.accentNutriLensDeep,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cloudflare Worker Proxy',
                    style: AppTextStyles.labelSmall(
                      color: AppColors.accentNutriLens,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Origin CORS · Allowlist · 16 MB · 30 req/min',
                    style: AppTextStyles.labelSmall(
                      color: AppColors.textPrimary,
                      tabular: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalorieRingPainter extends CustomPainter {
  const _CalorieRingPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - 6.0;
    const strokeWidth = 9.0;

    final trackPaint = Paint()
      ..color = AppColors.nutriForestSlot
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final fillPaint = Paint()
      ..color = AppColors.accentNutriLens
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CalorieRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _MacroBarRow extends StatelessWidget {
  const _MacroBarRow({
    required this.label,
    required this.value,
    required this.progress,
  });

  final String label;
  final String value;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.labelSmall(color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(width: 6.0),
            Text(
              value,
              style: AppTextStyles.labelSmall(
                color: AppColors.accentNutriLens,
                tabular: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5.0),
        ClipRRect(
          borderRadius: BorderRadius.circular(999.0),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 5.0,
            backgroundColor: AppColors.nutriForestSlot,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.accentNutriLens,
            ),
          ),
        ),
      ],
    );
  }
}

class _MealListCard extends StatelessWidget {
  const _MealListCard({
    required this.title,
    required this.subtitle,
    required this.score,
  });

  final String title;
  final String subtitle;
  final String score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 11.0),
      decoration: BoxDecoration(
        color: AppColors.nutriCard,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: const Color(0xFFE2EBE5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelSmall(
                    color: AppColors.nutriTextDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3.0),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelSmall(
                    color: AppColors.nutriTextMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: AppColors.accentNutriLens,
              borderRadius: BorderRadius.circular(999.0),
            ),
            child: Text(
              score,
              style: AppTextStyles.labelSmall(
                color: AppColors.nutriTextDark,
                fontWeight: FontWeight.w700,
                tabular: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IngredientPill extends StatelessWidget {
  const _IngredientPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: AppColors.nutriForestSlot,
        borderRadius: BorderRadius.circular(999.0),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall(color: AppColors.textPrimary),
      ),
    );
  }
}

class _ScanModeTile extends StatelessWidget {
  const _ScanModeTile({
    required this.badge,
    required this.title,
    required this.detail,
    required this.active,
  });

  final String badge;
  final String title;
  final String detail;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: AppColors.nutriCard,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: active ? AppColors.accentNutriLensDeep : const Color(0xFFE2EBE5),
          width: active ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
            decoration: BoxDecoration(
              color: active
                  ? AppColors.accentNutriLens
                  : const Color(0xFFEFF4F1),
              borderRadius: BorderRadius.circular(999.0),
            ),
            child: Text(
              badge,
              style: AppTextStyles.labelSmall(
                color: AppColors.nutriTextDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            title,
            style: AppTextStyles.cardTitle(isMobile: true).copyWith(
              color: AppColors.nutriTextDark,
              fontSize: 15.0,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            detail,
            style: AppTextStyles.labelSmall(color: AppColors.nutriTextMuted),
          ),
        ],
      ),
    );
  }
}

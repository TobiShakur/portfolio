import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';

/// Full-bleed dark titanium 9:19.5 iPhone bezel with floating Dynamic Island overlay.
class IphoneBezelFrame extends StatelessWidget {
  const IphoneBezelFrame({
    required this.width,
    required this.child,
    super.key,
    this.ambientGlowColor,
    this.showAmbientGlow = false,
  });

  final double width;
  final Widget child;
  final Color? ambientGlowColor;
  final bool showAmbientGlow;

  @override
  Widget build(BuildContext context) {
    final outerRadius = (width * 0.165).clamp(24.0, 44.0);
    final innerRadius = (outerRadius - 4.0).clamp(20.0, 40.0);
    final islandWidth = (width * 0.285).clamp(48.0, 76.0);
    final islandHeight = (width * 0.074).clamp(12.0, 20.0);
    final islandTop = (width * 0.036).clamp(8.0, 12.0);

    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bezelFrame,
          borderRadius: BorderRadius.circular(outerRadius),
          border: Border.all(
            color: AppColors.sidebarBorder,
            width: 2.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x73000000),
              blurRadius: 28.0,
              offset: Offset(0, 14),
            ),
          ],
        ),
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bgCanvas,
            borderRadius: BorderRadius.circular(innerRadius),
            border: Border.all(
              color: AppColors.bezelSpecular,
              width: 1.0,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerRadius - 1.0),
            child: AspectRatio(
              aspectRatio: AppSpacing.phoneAspectRatio,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  child,
                  Positioned(
                    top: islandTop,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: IgnorePointer(
                        child: Container(
                          width: islandWidth,
                          height: islandHeight,
                          decoration: BoxDecoration(
                            color: AppColors.sidebarBg,
                            borderRadius: BorderRadius.circular(999.0),
                            border: Border.all(
                              color: AppColors.borderHairline,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
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

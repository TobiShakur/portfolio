import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';

/// Dark titanium 9:19.5 iPhone bezel with Dynamic Island and specular inner edge.
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
    final outerRadius = (width * 0.165).clamp(28.0, 46.0);
    final innerRadius = (outerRadius - 5.0).clamp(22.0, 40.0);
    final islandWidth = (width * 0.285).clamp(54.0, 78.0);
    final islandHeight = (width * 0.077).clamp(15.0, 21.0);
    final islandTop = (width * 0.042).clamp(8.0, 13.0);

    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: AppSpacing.phoneAspectRatio,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bezelFrame,
            borderRadius: BorderRadius.circular(outerRadius),
            border: Border.all(
              color: AppColors.sidebarBorder,
              width: 2.5,
            ),
            boxShadow: [
              const BoxShadow(
                color: Color(0xAA000000),
                blurRadius: 36.0,
                offset: Offset(0, 18),
              ),
              if (showAmbientGlow && ambientGlowColor != null)
                BoxShadow(
                  color: ambientGlowColor!.withValues(alpha: 0.11),
                  blurRadius: 56.0,
                  spreadRadius: 2.0,
                ),
            ],
          ),
          padding: const EdgeInsets.all(6.0),
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
              child: Stack(
                fit: StackFit.expand,
                children: [
                  child,
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: islandTop),
                      child: IgnorePointer(
                        child: Container(
                          width: islandWidth,
                          height: islandHeight,
                          decoration: BoxDecoration(
                            color: const Color(0xFF040507),
                            borderRadius: BorderRadius.circular(999.0),
                            border: Border.all(
                              color: AppColors.borderHairline,
                              width: 0.75,
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

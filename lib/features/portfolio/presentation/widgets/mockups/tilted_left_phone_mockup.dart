import 'package:flutter/material.dart';
import 'package:portfolio/features/portfolio/domain/entities/project_showcase.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/mockups/iphone_bezel_frame.dart';

/// Left-column 3D angled iPhone mockup showing a static core app screen.
class TiltedLeftPhoneMockup extends StatefulWidget {
  const TiltedLeftPhoneMockup({
    required this.project,
    required this.width,
    super.key,
  });

  final ProjectShowcase project;
  final double width;

  @override
  State<TiltedLeftPhoneMockup> createState() => _TiltedLeftPhoneMockupState();
}

class _TiltedLeftPhoneMockupState extends State<TiltedLeftPhoneMockup> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final targetTiltY = (_isHovered && !reduceMotion) ? 0.14 : 0.24;

    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(end: targetTiltY),
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          builder: (context, tiltY, child) {
            final transform = Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..rotateY(tiltY)
              ..rotateX(-0.04);
            return Transform(
              alignment: Alignment.center,
              transform: transform,
              child: child,
            );
          },
          child: IphoneBezelFrame(
            width: widget.width,
            ambientGlowColor: widget.project.deepAccentColor,
            showAmbientGlow: true,
            child: _buildScreen(),
          ),
        ),
      ),
    );
  }

  Widget _buildScreen() {
    return Image.asset(
      widget.project.leftScreenshotAsset,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      width: double.infinity,
      height: double.infinity,
    );
  }
}

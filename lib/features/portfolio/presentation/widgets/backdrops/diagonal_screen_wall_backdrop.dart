import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/backdrops/kinetic_screen_tile.dart';

/// Concept A signature background: rotated -26deg wall of real mobile screens
/// counter-scrolling gently behind an editorial directional scrim.
class DiagonalScreenWallBackdrop extends StatefulWidget {
  const DiagonalScreenWallBackdrop({
    required this.imageAssets,
    required this.isSectionVisible,
    required this.isPaused,
    super.key,
    this.isMobile = false,
    this.preScrimOpacity,
  });

  final List<String> imageAssets;
  final bool isSectionVisible;
  final bool isPaused;
  final bool isMobile;
  final double? preScrimOpacity;

  @override
  State<DiagonalScreenWallBackdrop> createState() =>
      _DiagonalScreenWallBackdropState();
}

class _DiagonalScreenWallBackdropState extends State<DiagonalScreenWallBackdrop>
    with TickerProviderStateMixin, KineticClockMixin {
  @override
  bool get shouldRunClock =>
      widget.isSectionVisible &&
      !widget.isPaused &&
      !MediaQuery.disableAnimationsOf(context);

  @override
  void initState() {
    super.initState();
    initKineticClock();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    syncKineticClock();
  }

  @override
  void didUpdateWidget(covariant DiagonalScreenWallBackdrop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSectionVisible != widget.isSectionVisible ||
        oldWidget.isPaused != widget.isPaused) {
      syncKineticClock();
    }
  }

  @override
  void dispose() {
    disposeKineticClock();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageAssets.isEmpty) {
      return const SizedBox.shrink();
    }

    final tileWidth = widget.isMobile ? 112.0 : 156.0;
    final tileGap = widget.isMobile ? 14.0 : 18.0;
    final columnCount = widget.isMobile ? 2 : 3;
    final baseOpacity =
        widget.preScrimOpacity ?? (widget.isMobile ? 0.24 : 0.34);

    // Speeds per DESIGN_CONCEPTS.md §2.1: +14 / -16 / +12 px/s
    const columnSpeeds = <double>[14.0, -16.0, 12.0];

    return IgnorePointer(
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            RepaintBoundary(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final canvasW =
                      (constraints.maxWidth.isFinite ? constraints.maxWidth : 1280.0) *
                          1.45;
                  final canvasH =
                      (constraints.maxHeight.isFinite ? constraints.maxHeight : 820.0) *
                          1.45;

                  return OverflowBox(
                    maxWidth: canvasW,
                    maxHeight: canvasH,
                    minWidth: canvasW,
                    minHeight: canvasH,
                    child: Transform.rotate(
                      angle: -26.0 * math.pi / 180.0,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: widget.isMobile ? 12.0 : 48.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (var col = 0; col < columnCount; col++) ...[
                                if (col > 0) SizedBox(width: tileGap),
                                KineticVerticalColumn(
                                  assets: _rotatedAssets(widget.imageAssets, col),
                                  tileWidth: tileWidth,
                                  tileGap: tileGap,
                                  speedPxPerSec: columnSpeeds[col],
                                  elapsedSeconds: elapsedSeconds,
                                  trackHeight: canvasH,
                                  imageOpacity: baseOpacity,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Horizontal readability directional scrim
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.0, 0.48, 0.85, 1.0],
                  colors: [
                    Color(0xF5080A0C),
                    Color(0xEC080A0C),
                    Color(0x88080A0C),
                    Color(0xD9080A0C),
                  ],
                ),
              ),
            ),
            // Top 28px fade into section rule
            const Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 28.0,
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.bgCanvas, Color(0x00080A0C)],
                    ),
                  ),
                ),
              ),
            ),
            // Bottom 28px fade into section rule
            const Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 28.0,
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [AppColors.bgCanvas, Color(0x00080A0C)],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _rotatedAssets(List<String> source, int offset) {
    final len = source.length;
    return List<String>.generate(len, (i) => source[(i + offset) % len]);
  }
}

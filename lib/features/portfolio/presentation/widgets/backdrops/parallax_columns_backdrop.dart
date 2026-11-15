import 'package:flutter/material.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/backdrops/kinetic_screen_tile.dart';

/// Concept C background: two parallel vertical screen columns gliding in opposite
/// directions (`-14 / +14 px/s`) with organic ShaderMask melt at top and bottom.
class ParallaxColumnsBackdrop extends StatefulWidget {
  const ParallaxColumnsBackdrop({
    required this.imageAssets,
    required this.isSectionVisible,
    required this.isPaused,
    super.key,
  });

  final List<String> imageAssets;
  final bool isSectionVisible;
  final bool isPaused;

  @override
  State<ParallaxColumnsBackdrop> createState() =>
      _ParallaxColumnsBackdropState();
}

class _ParallaxColumnsBackdropState extends State<ParallaxColumnsBackdrop>
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
  void didUpdateWidget(covariant ParallaxColumnsBackdrop oldWidget) {
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

    const tileWidth = 148.0;
    const tileGap = 16.0;

    return IgnorePointer(
      child: RepaintBoundary(
        child: Opacity(
          opacity: 0.18,
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.16, 0.84, 1.0],
              colors: [
                Colors.transparent,
                Colors.white,
                Colors.white,
                Colors.transparent,
              ],
            ).createShader(bounds),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final trackH = constraints.maxHeight.isFinite
                    ? constraints.maxHeight
                    : 640.0;

                return Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      KineticVerticalColumn(
                        assets: widget.imageAssets,
                        tileWidth: tileWidth,
                        tileGap: tileGap,
                        speedPxPerSec: -14.0,
                        trackHeight: trackH,
                        elapsedSeconds: elapsedSeconds,
                      ),
                      const SizedBox(width: 24.0),
                      KineticVerticalColumn(
                        assets: widget.imageAssets.reversed.toList(),
                        tileWidth: tileWidth,
                        tileGap: tileGap,
                        speedPxPerSec: 14.0,
                        trackHeight: trackH,
                        elapsedSeconds: elapsedSeconds,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

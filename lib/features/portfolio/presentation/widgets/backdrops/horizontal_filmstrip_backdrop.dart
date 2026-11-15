import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/backdrops/kinetic_screen_tile.dart';

/// Concept B orthogonal desaturated contact-sheet filmstrip confined inside
/// the showcase stage cell (`-12 px/s` top row, `+10 px/s` bottom row).
class HorizontalFilmstripBackdrop extends StatefulWidget {
  const HorizontalFilmstripBackdrop({
    required this.imageAssets,
    required this.isSectionVisible,
    required this.isPaused,
    super.key,
  });

  final List<String> imageAssets;
  final bool isSectionVisible;
  final bool isPaused;

  @override
  State<HorizontalFilmstripBackdrop> createState() =>
      _HorizontalFilmstripBackdropState();
}

class _HorizontalFilmstripBackdropState
    extends State<HorizontalFilmstripBackdrop>
    with TickerProviderStateMixin, KineticClockMixin {
  // 25% saturation matrix (75% grayscale mix via Rec.709 luminance weights)
  static const ColorFilter _desaturate25Filter = ColorFilter.matrix(<double>[
    0.4094, 0.5364, 0.0542, 0, 0,
    0.1594, 0.7864, 0.0542, 0, 0,
    0.1594, 0.5364, 0.3042, 0, 0,
    0,      0,      0,      1, 0,
  ]);

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
  void didUpdateWidget(covariant HorizontalFilmstripBackdrop oldWidget) {
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

    const tileWidth = 124.0;
    const tileGap = 14.0;

    return IgnorePointer(
      child: ClipRect(
        child: RepaintBoundary(
          child: ColorFiltered(
            colorFilter: _desaturate25Filter,
            child: OverflowBox(
              alignment: Alignment.center,
              minHeight: 0.0,
              maxHeight: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _HorizontalStripRow(
                    assets: widget.imageAssets,
                    tileWidth: tileWidth,
                    tileGap: tileGap,
                    speedPxPerSec: -12.0,
                    elapsedSeconds: elapsedSeconds,
                  ),
                  const SizedBox(height: 16.0),
                  _HorizontalStripRow(
                    assets: widget.imageAssets.reversed.toList(),
                    tileWidth: tileWidth,
                    tileGap: tileGap,
                    speedPxPerSec: 10.0,
                    elapsedSeconds: elapsedSeconds,
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

class _HorizontalStripRow extends StatelessWidget {
  const _HorizontalStripRow({
    required this.assets,
    required this.tileWidth,
    required this.tileGap,
    required this.speedPxPerSec,
    required this.elapsedSeconds,
  });

  final List<String> assets;
  final double tileWidth;
  final double tileGap;
  final double speedPxPerSec;
  final ValueNotifier<double> elapsedSeconds;

  @override
  Widget build(BuildContext context) {
    final tileHeight = tileWidth / AppSpacing.phoneAspectRatio;
    final cycleSpan = assets.length * (tileWidth + tileGap);

    final repeatedRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var repeat = 0; repeat < 3; repeat++)
          for (final asset in assets) ...[
            KineticScreenTile(
              assetPath: asset,
              width: tileWidth,
              borderRadius: 10.0,
              borderOpacity: 0.16,
              imageOpacity: 0.15,
            ),
            SizedBox(width: tileGap),
          ],
      ],
    );

    return SizedBox(
      height: tileHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRect(
            child: OverflowBox(
              alignment: Alignment.centerLeft,
              minWidth: cycleSpan * 3,
              maxWidth: cycleSpan * 3,
              child: AnimatedBuilder(
                animation: elapsedSeconds,
                child: repeatedRow,
                builder: (context, child) {
                  final rawShift = elapsedSeconds.value * speedPxPerSec;
                  final wrapped =
                      ((rawShift % cycleSpan) + cycleSpan) % cycleSpan -
                          cycleSpan;
                  return Transform.translate(
                    offset: Offset(wrapped, 0.0),
                    child: child,
                  );
                },
              ),
            ),
          ),
          // Soft horizontal edge fade inside the Swiss Grid stage cell
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.0, 0.12, 0.88, 1.0],
                colors: [
                  AppColors.bgCanvas,
                  Color(0x00080A0C),
                  Color(0x00080A0C),
                  AppColors.bgCanvas,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

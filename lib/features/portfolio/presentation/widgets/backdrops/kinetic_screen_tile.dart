import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:portfolio/core/theme/app_spacing.dart';

/// Shared thumbnail tile for kinetic real-app screen walls & strips.
/// Decoded at `cacheWidth: 180` with `FilterQuality.low` for cheap GPU composition.
class KineticScreenTile extends StatelessWidget {
  const KineticScreenTile({
    required this.assetPath,
    required this.width,
    super.key,
    this.borderRadius = 18.0,
    this.borderOpacity = 0.10,
    this.imageOpacity = 1.0,
  });

  final String assetPath;
  final double width;
  final double borderRadius;
  final double borderOpacity;
  final double imageOpacity;

  @override
  Widget build(BuildContext context) {
    final effectiveOpacity = imageOpacity.clamp(0.0, 1.0);
    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: AppSpacing.phoneAspectRatio,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: borderOpacity * effectiveOpacity,
              ),
              width: 1.0,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius - 1.0),
            child: Image.asset(
              assetPath,
              cacheWidth: 180,
              filterQuality: FilterQuality.low,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              color: effectiveOpacity < 1.0
                  ? Colors.white.withValues(alpha: effectiveOpacity)
                  : null,
              colorBlendMode:
                  effectiveOpacity < 1.0 ? BlendMode.modulate : null,
            ),
          ),
        ),
      ),
    );
  }
}

/// Mixin providing a lifecycle-safe monotonic elapsed-seconds clock for
/// seamless marquee backdrops that automatically stops off-screen or when paused.
mixin KineticClockMixin<T extends StatefulWidget> on TickerProviderStateMixin<T> {
  late final Ticker _ticker;
  final ValueNotifier<double> elapsedSeconds = ValueNotifier<double>(0.0);
  double _accumulatedSeconds = 0.0;
  Duration? _lastTick;

  bool get shouldRunClock;

  void initKineticClock() {
    _ticker = createTicker((elapsed) {
      final previous = _lastTick;
      _lastTick = elapsed;
      if (previous != null) {
        final delta = (elapsed - previous).inMicroseconds / 1000000.0;
        if (delta > 0 && delta < 0.25) {
          _accumulatedSeconds += delta;
          elapsedSeconds.value = _accumulatedSeconds;
        }
      }
    });
  }

  void syncKineticClock() {
    if (!mounted) {
      return;
    }
    if (shouldRunClock) {
      if (!_ticker.isActive) {
        _lastTick = null;
        _ticker.start();
      }
    } else if (_ticker.isActive) {
      _ticker.stop();
      _lastTick = null;
    }
  }

  void disposeKineticClock() {
    _ticker.dispose();
    elapsedSeconds.dispose();
  }
}

/// Vertically looping image column powered by [elapsedSeconds] without rebuilding
/// child image widgets on every animation frame.
class KineticVerticalColumn extends StatelessWidget {
  const KineticVerticalColumn({
    required this.assets,
    required this.tileWidth,
    required this.tileGap,
    required this.speedPxPerSec,
    required this.trackHeight,
    required this.elapsedSeconds,
    this.imageOpacity = 1.0,
    super.key,
  });

  final List<String> assets;
  final double tileWidth;
  final double tileGap;
  final double speedPxPerSec;
  final double trackHeight;
  final ValueNotifier<double> elapsedSeconds;
  final double imageOpacity;

  @override
  Widget build(BuildContext context) {
    final tileHeight = tileWidth / AppSpacing.phoneAspectRatio;
    final cycleSpan = assets.length * (tileHeight + tileGap);

    final repeatedTrack = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var repeat = 0; repeat < 2; repeat++)
          for (final asset in assets) ...[
            KineticScreenTile(
              assetPath: asset,
              width: tileWidth,
              imageOpacity: imageOpacity,
            ),
            SizedBox(height: tileGap),
          ],
      ],
    );

    return ClipRect(
      child: SizedBox(
        width: tileWidth,
        height: trackHeight,
        child: OverflowBox(
          alignment: Alignment.topCenter,
          minHeight: cycleSpan * 2,
          maxHeight: cycleSpan * 2,
          child: AnimatedBuilder(
            animation: elapsedSeconds,
            child: repeatedTrack,
            builder: (context, child) {
              final rawShift = elapsedSeconds.value * speedPxPerSec;
              final wrapped =
                  ((rawShift % cycleSpan) + cycleSpan) % cycleSpan - cycleSpan;
              return Transform.translate(
                offset: Offset(0.0, wrapped),
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }
}

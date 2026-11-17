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

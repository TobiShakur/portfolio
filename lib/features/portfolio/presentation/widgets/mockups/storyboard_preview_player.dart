import 'dart:async';

import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/features/portfolio/domain/entities/project_showcase.dart';

/// Pure-Flutter automated crossfade storyboard preview for iPhone mockups.
class StoryboardPreviewPlayer extends StatefulWidget {
  const StoryboardPreviewPlayer({
    required this.project,
    required this.reduceMotion,
    super.key,
    this.previewAssetsOverride,
    this.controlledIndex,
    this.isPaused = false,
    this.onScreenChanged,
  });

  final ProjectShowcase project;
  final bool reduceMotion;
  final List<String>? previewAssetsOverride;
  final int? controlledIndex;
  final bool isPaused;
  final ValueChanged<int>? onScreenChanged;

  @override
  State<StoryboardPreviewPlayer> createState() =>
      _StoryboardPreviewPlayerState();
}

class _StoryboardPreviewPlayerState extends State<StoryboardPreviewPlayer> {
  Timer? _timer;
  int _internalIndex = 0;

  List<String> get _slides {
    final override = widget.previewAssetsOverride;
    if (override != null && override.isNotEmpty) {
      return override;
    }
    if (widget.project.rightPreviewImages.isNotEmpty) {
      return widget.project.rightPreviewImages;
    }
    return [widget.project.leftScreenshotAsset];
  }

  int get _activeIndex {
    final controlled = widget.controlledIndex;
    if (controlled != null) {
      return controlled.clamp(0, _slides.length - 1);
    }
    return _internalIndex.clamp(0, _slides.length - 1);
  }

  @override
  void initState() {
    super.initState();
    _syncTimer();
  }

  @override
  void didUpdateWidget(covariant StoryboardPreviewPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final projectChanged = oldWidget.project.id != widget.project.id;
    if (projectChanged) {
      _internalIndex = 0;
    }
    if (projectChanged ||
        oldWidget.reduceMotion != widget.reduceMotion ||
        oldWidget.isPaused != widget.isPaused ||
        oldWidget.previewAssetsOverride?.length !=
            widget.previewAssetsOverride?.length) {
      _syncTimer();
    }
  }

  void _syncTimer() {
    _timer?.cancel();
    if (widget.reduceMotion || widget.isPaused || _slides.length <= 1) {
      return;
    }
    _timer = Timer.periodic(const Duration(milliseconds: 2200), (_) {
      if (!mounted) {
        return;
      }
      final nextIndex = (_activeIndex + 1) % _slides.length;
      if (widget.controlledIndex == null) {
        setState(() {
          _internalIndex = nextIndex;
        });
      }
      widget.onScreenChanged?.call(nextIndex);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final index = _activeIndex;
    final slide = _buildSlide(_slides[index]);

    return RepaintBoundary(
      child: AnimatedSwitcher(
        duration: widget.reduceMotion ? Duration.zero : AppMotion.slideFade,
        switchInCurve: AppMotion.standardCurve,
        switchOutCurve: AppMotion.standardCurve,
        child: KeyedSubtree(
          key: ValueKey<String>('${widget.project.id.name}_${_slides[index]}'),
          child: slide,
        ),
      ),
    );
  }

  Widget _buildSlide(String asset) {
    return Image.asset(
      asset,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      width: double.infinity,
      height: double.infinity,
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:portfolio/features/portfolio/domain/entities/project_showcase.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/mockups/nutrilens_preview_screens.dart';

/// Pure-Flutter automated crossfade storyboard preview for iPhone mockups.
class StoryboardPreviewPlayer extends StatefulWidget {
  const StoryboardPreviewPlayer({
    required this.project,
    required this.reduceMotion,
    super.key,
  });

  final ProjectShowcase project;
  final bool reduceMotion;

  @override
  State<StoryboardPreviewPlayer> createState() =>
      _StoryboardPreviewPlayerState();
}

class _StoryboardPreviewPlayerState extends State<StoryboardPreviewPlayer> {
  Timer? _timer;
  int _activeIndex = 0;

  int get _slideCount {
    if (widget.project.previewMode ==
        ProjectPreviewMode.nutriLensInteractiveScreens) {
      return 3;
    }
    return widget.project.rightPreviewImages.isEmpty
        ? 1
        : widget.project.rightPreviewImages.length;
  }

  @override
  void initState() {
    super.initState();
    _syncTimer();
  }

  @override
  void didUpdateWidget(covariant StoryboardPreviewPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reduceMotion != widget.reduceMotion ||
        oldWidget.project.id != widget.project.id) {
      _activeIndex = 0;
      _syncTimer();
    }
  }

  void _syncTimer() {
    _timer?.cancel();
    if (widget.reduceMotion || _slideCount <= 1) {
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _activeIndex = (_activeIndex + 1) % _slideCount;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slide = _buildSlide(_activeIndex);

    return RepaintBoundary(
      child: AnimatedSwitcher(
        duration: widget.reduceMotion
            ? Duration.zero
            : const Duration(milliseconds: 1400),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: KeyedSubtree(
          key: ValueKey<String>('${widget.project.id.name}_$_activeIndex'),
          child: slide,
        ),
      ),
    );
  }

  Widget _buildSlide(int index) {
    if (widget.project.previewMode ==
        ProjectPreviewMode.nutriLensInteractiveScreens) {
      return switch (index) {
        0 => const NutriLensMealScanScreen(),
        1 => const NutriLensHomeRingScreen(),
        _ => const NutriLensPantryScanScreen(),
      };
    }

    final images = widget.project.rightPreviewImages;
    final asset =
        images.isEmpty ? widget.project.leftScreenshotAsset : images[index];
    return ColoredBox(
      color: const Color(0xFF0E1311),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 34.0, 4.0, 8.0),
        child: Image.asset(
          asset,
          fit: BoxFit.contain,
          alignment: Alignment.topCenter,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

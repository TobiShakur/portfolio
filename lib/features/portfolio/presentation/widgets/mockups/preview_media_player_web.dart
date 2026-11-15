import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/features/portfolio/domain/entities/project_showcase.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/mockups/storyboard_preview_player.dart';
import 'package:web/web.dart' as web;

/// Web implementation supporting local `.mp4` `<video>` playback via
/// `HtmlElementView` with CSS blur synchronization and automatic storyboard fallback.
class PreviewMediaPlayer extends StatefulWidget {
  const PreviewMediaPlayer({
    required this.project,
    required this.isBlurred,
    required this.reduceMotion,
    super.key,
    this.previewAssetsOverride,
    this.controlledIndex,
    this.isPaused = false,
    this.onScreenChanged,
  });

  final ProjectShowcase project;
  final bool isBlurred;
  final bool reduceMotion;
  final List<String>? previewAssetsOverride;
  final int? controlledIndex;
  final bool isPaused;
  final ValueChanged<int>? onScreenChanged;

  @override
  State<PreviewMediaPlayer> createState() => _PreviewMediaPlayerState();
}

class _PreviewMediaPlayerState extends State<PreviewMediaPlayer> {
  static final Set<String> _registeredViewTypes = <String>{};
  static Future<AssetManifest>? _manifestFuture;

  web.HTMLVideoElement? _videoElement;
  bool _videoAvailable = false;
  bool _videoReady = false;
  bool _videoErrored = false;

  @override
  void initState() {
    super.initState();
    _checkBundledVideo();
  }

  @override
  void didUpdateWidget(covariant PreviewMediaPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isBlurred != widget.isBlurred) {
      _applyVideoBlur();
    }
    if (oldWidget.project.videoAsset != widget.project.videoAsset) {
      _videoAvailable = false;
      _videoReady = false;
      _videoErrored = false;
      _videoElement = null;
      _checkBundledVideo();
    }
  }

  Future<void> _checkBundledVideo() async {
    final asset = widget.project.videoAsset;
    if (asset == null || !asset.startsWith('assets/videos/')) {
      return;
    }

    try {
      _manifestFuture ??= AssetManifest.loadFromAssetBundle(rootBundle);
      final manifest = await _manifestFuture!;
      final bundled = manifest.listAssets().contains(asset);
      if (!mounted || !bundled) {
        return;
      }
      _registerVideoFactory(asset);
      setState(() {
        _videoAvailable = true;
      });
    } catch (_) {
      // Fallback cleanly to storyboard when manifest lookup fails.
    }
  }

  String get _viewType => 'portfolio-video-${widget.project.id.name}';

  void _registerVideoFactory(String videoAsset) {
    if (_registeredViewTypes.contains(_viewType)) {
      return;
    }
    _registeredViewTypes.add(_viewType);

    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final element = web.document.createElement('video')
          as web.HTMLVideoElement
        ..src = 'assets/$videoAsset'
        ..muted = true
        ..autoplay = !widget.reduceMotion
        ..loop = true
        ..playsInline = true;

      element.style
        ..width = '100%'
        ..height = '100%'
        ..objectFit = 'cover'
        ..pointerEvents = 'none'
        ..display = 'block'
        ..transition = 'filter 220ms cubic-bezier(0.22, 1, 0.36, 1)';

      element.onCanPlay.listen((_) {
        if (mounted && !_videoReady) {
          setState(() => _videoReady = true);
        }
      });

      element.onError.listen((_) {
        if (mounted && !_videoErrored) {
          setState(() => _videoErrored = true);
        }
      });

      _videoElement = element;
      _applyVideoBlur();
      return element;
    });
  }

  void _applyVideoBlur() {
    final element = _videoElement;
    if (element == null) {
      return;
    }
    element.style.filter = widget.isBlurred ? 'blur(8px)' : 'none';
  }

  @override
  Widget build(BuildContext context) {
    final storyboard = StoryboardPreviewPlayer(
      project: widget.project,
      reduceMotion: widget.reduceMotion,
      previewAssetsOverride: widget.previewAssetsOverride,
      controlledIndex: widget.controlledIndex,
      isPaused: widget.isPaused,
      onScreenChanged: widget.onScreenChanged,
    );

    if (!_videoAvailable || _videoErrored) {
      return storyboard;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        storyboard,
        IgnorePointer(
          child: HtmlElementView(viewType: _viewType),
        ),
        if (!_videoReady)
          Align(
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(
              minHeight: 2.0,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.project.accentColor.withValues(alpha: 0.75),
              ),
            ),
          ),
        if (widget.isBlurred)
          const ColoredBox(color: AppColors.scrimHover),
      ],
    );
  }
}

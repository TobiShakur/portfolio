import 'package:flutter/material.dart';
import 'package:portfolio/features/portfolio/domain/entities/project_showcase.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/mockups/storyboard_preview_player.dart';

/// Non-web / Dart VM implementation using the crossfade storyboard preview.
class PreviewMediaPlayer extends StatelessWidget {
  const PreviewMediaPlayer({
    required this.project,
    required this.isBlurred,
    required this.reduceMotion,
    super.key,
  });

  final ProjectShowcase project;
  final bool isBlurred;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    return StoryboardPreviewPlayer(
      project: project,
      reduceMotion: reduceMotion,
    );
  }
}

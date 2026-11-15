import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_section_id.dart';

/// Scannable technical bullet item inside a project showcase.
@immutable
final class EngineeringHighlight {
  const EngineeringHighlight({
    required this.title,
    required this.detail,
  });

  final String title;
  final String detail;
}

/// Identifies how app preview screens are rendered inside the right phone mockup.
enum ProjectPreviewMode {
  assetImages,
}

/// Immutable model representing a featured mobile product in the portfolio.
@immutable
final class ProjectShowcase {
  const ProjectShowcase({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.problemStatement,
    required this.engineeringHighlights,
    required this.techStack,
    required this.testCount,
    required this.testLabel,
    required this.liveDemoUrl,
    required this.repoUrl,
    required this.logoAsset,
    required this.leftScreenshotAsset,
    required this.rightPreviewImages,
    required this.previewMode,
    required this.accentColor,
    required this.deepAccentColor,
    this.videoAsset,
  });

  final PortfolioSectionId id;
  final String title;
  final String subtitle;
  final String problemStatement;
  final List<EngineeringHighlight> engineeringHighlights;
  final List<String> techStack;
  final int testCount;
  final String testLabel;
  final String liveDemoUrl;
  final String repoUrl;
  final String logoAsset;
  final String leftScreenshotAsset;
  final List<String> rightPreviewImages;
  final ProjectPreviewMode previewMode;
  final Color accentColor;
  final Color deepAccentColor;
  final String? videoAsset;
}

import 'package:flutter/foundation.dart';
import 'package:portfolio/features/portfolio/domain/entities/tech_brand.dart';

/// Client-focused summary row displayed inside the Hero `HOW I HELP TEAMS` card.
@immutable
final class SnapshotHighlight {
  const SnapshotHighlight({
    required this.label,
    required this.value,
    this.tabular = false,
  });

  final String label;
  final String value;
  final bool tabular;
}

/// Immutable profile and hero presentation data.
@immutable
final class ProfileData {
  const ProfileData({
    required this.fullName,
    required this.roleTitle,
    required this.headlineLine1,
    required this.headlineLine2,
    required this.supportingPitch,
    required this.githubUrl,
    required this.linkedInUrl,
    required this.email,
    required this.verificationMetrics,
    required this.coreStackLogos,
    required this.snapshotHighlights,
  });

  final String fullName;
  final String roleTitle;
  final String headlineLine1;
  final String headlineLine2;
  final String supportingPitch;
  final String githubUrl;
  final String linkedInUrl;
  final String email;
  final List<String> verificationMetrics;
  final List<TechBrandChipItem> coreStackLogos;
  final List<SnapshotHighlight> snapshotHighlights;

  String get identityLine => '$fullName · $roleTitle';
  String get mailtoUrl => 'mailto:$email';
}

import 'package:portfolio/features/portfolio/domain/entities/tech_brand.dart';

/// Compact key-value row displayed in the Swiss Grid spec card.
class SnapshotHighlight {
  const SnapshotHighlight({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

/// Core portfolio identity, contact info, and verified engineering profile.
class ProfileData {
  const ProfileData({
    required this.fullName,
    required this.roleTitle,
    required this.identityLine,
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
  final String identityLine;
  final String headlineLine1;
  final String headlineLine2;
  final String supportingPitch;
  final String githubUrl;
  final String linkedInUrl;
  final String email;
  final List<String> verificationMetrics;
  final List<TechBrandChipItem> coreStackLogos;
  final List<SnapshotHighlight> snapshotHighlights;

  String get mailtoUrl => 'mailto:$email';
}

import 'package:flutter/foundation.dart';
import 'package:portfolio/features/portfolio/domain/entities/tech_brand.dart';

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

  String get identityLine => '$fullName — $roleTitle';
  String get mailtoUrl => 'mailto:$email';
}

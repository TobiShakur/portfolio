import 'package:flutter/foundation.dart';
import 'package:portfolio/features/portfolio/domain/entities/tech_brand.dart';

/// Semantic icon identifier for each engineering pillar card.
enum EngineeringIconKind {
  architecture,
  security,
  geospatial,
  verification,
}

/// Immutable capability pillar displayed in the Capabilities & Cloud Stack matrix.
@immutable
final class EngineeringPillar {
  const EngineeringPillar({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKind,
    required this.badges,
  });

  final String id;
  final String title;
  final String description;
  final EngineeringIconKind iconKind;
  final List<TechBrandChipItem> badges;
}

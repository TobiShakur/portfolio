import 'package:flutter/foundation.dart';

/// Vector brand logo identifiers rendered via [TechBrandIcon] without external requests.
enum TechBrand {
  flutter,
  dart,
  firebase,
  cloudflare,
  gemini,
  appleIos,
  android,
  figma,
  openStreetMap,
  githubActions,
}

/// Chip metadata pairing a display label with an optional embedded [TechBrand] icon.
@immutable
final class TechBrandChipItem {
  const TechBrandChipItem({
    required this.label,
    this.brand,
  });

  final String label;
  final TechBrand? brand;
}

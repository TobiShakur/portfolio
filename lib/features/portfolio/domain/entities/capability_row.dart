/// Verified client production proof banner displayed in Capabilities & Hero.
class ClientAppProof {
  const ClientAppProof({
    required this.badgeLabel,
    required this.title,
    required this.summary,
    required this.platformsLine,
    required this.stackLine,
    required this.shortName,
    required this.ratingLabel,
    required this.storeLabel,
    required this.highlights,
  });

  final String badgeLabel;
  final String title;
  final String summary;
  final String platformsLine;
  final String stackLine;
  final String shortName;
  final String ratingLabel;
  final String storeLabel;
  final List<String> highlights;
}

/// Consolidated engineering capability & stack row in the 01..04 ledger.
class CapabilityRowItem {
  const CapabilityRowItem({
    required this.indexLabel,
    required this.title,
    required this.description,
    required this.techSpecs,
  });

  final String indexLabel;
  final String title;
  final String description;
  final String techSpecs;
}

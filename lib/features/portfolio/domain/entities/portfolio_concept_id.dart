/// Visual layout & kinetic stage concept modes selectable live via the UI or URL.
enum PortfolioConceptId {
  editorialWall(
    queryCode: 'a',
    shortCode: 'A',
    menuLabel: 'A · Wall',
    fullName: 'Editorial Kinetic Wall',
    buttonRadius: 10.0,
    surfaceRadius: 12.0,
  ),
  swissGrid(
    queryCode: 'b',
    shortCode: 'B',
    menuLabel: 'B · Grid',
    fullName: 'Swiss Grid Studio',
    buttonRadius: 6.0,
    surfaceRadius: 6.0,
  ),
  kineticStage(
    queryCode: 'c',
    shortCode: 'C',
    menuLabel: 'C · Stage',
    fullName: 'Spatial Kinetic Stage',
    buttonRadius: 999.0,
    surfaceRadius: 16.0,
  );

  const PortfolioConceptId({
    required this.queryCode,
    required this.shortCode,
    required this.menuLabel,
    required this.fullName,
    required this.buttonRadius,
    required this.surfaceRadius,
  });

  final String queryCode;
  final String shortCode;
  final String menuLabel;
  final String fullName;
  final double buttonRadius;
  final double surfaceRadius;

  /// Parses `?concept=`, `?hero=`, or `?work=` query values safely.
  static PortfolioConceptId? tryParseQuery(String? raw) {
    final normalized = raw?.trim().toLowerCase();
    return switch (normalized) {
      'a' || 'wall' || 'editorial' => PortfolioConceptId.editorialWall,
      'b' || 'grid' || 'swiss' => PortfolioConceptId.swissGrid,
      'c' || 'stage' || 'kinetic' => PortfolioConceptId.kineticStage,
      _ => null,
    };
  }
}

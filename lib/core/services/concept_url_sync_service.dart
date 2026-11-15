import 'package:portfolio/features/portfolio/domain/entities/portfolio_concept_id.dart';

/// Initial URL query parameters parsed for Hero and Work concept presets.
class ConceptQuerySelection {
  const ConceptQuerySelection({
    this.heroConcept,
    this.workConcept,
  });

  final PortfolioConceptId? heroConcept;
  final PortfolioConceptId? workConcept;

  /// Parses raw query parameter map using `?concept=` plus optional `?hero=` / `?work=`.
  factory ConceptQuerySelection.fromParameters(Map<String, String> params) {
    final unified = PortfolioConceptId.tryParseQuery(params['concept']);
    final hero = PortfolioConceptId.tryParseQuery(params['hero']) ?? unified;
    final work = PortfolioConceptId.tryParseQuery(params['work']) ?? unified;
    return ConceptQuerySelection(
      heroConcept: hero,
      workConcept: work,
    );
  }
}

/// Platform service synchronizing `?concept=` / `?hero=` / `?work=` without page reload.
abstract interface class ConceptUrlSyncService {
  ConceptQuerySelection readInitialSelection();

  void syncConcepts({
    required PortfolioConceptId hero,
    required PortfolioConceptId work,
  });
}

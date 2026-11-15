import 'package:portfolio/core/services/concept_url_sync_service.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_concept_id.dart';

/// Non-web / Dart VM implementation of [ConceptUrlSyncService] for deterministic tests.
final class PlatformConceptUrlSyncService implements ConceptUrlSyncService {
  PlatformConceptUrlSyncService({this.initialQueryParameters});

  final Map<String, String>? initialQueryParameters;
  String? lastSyncedSearch;

  @override
  ConceptQuerySelection readInitialSelection() {
    final params = initialQueryParameters ?? Uri.base.queryParameters;
    return ConceptQuerySelection.fromParameters(params);
  }

  @override
  void syncConcepts({
    required PortfolioConceptId hero,
    required PortfolioConceptId work,
  }) {
    if (hero == work) {
      lastSyncedSearch = '?concept=${hero.queryCode}';
    } else {
      lastSyncedSearch =
          '?hero=${hero.queryCode}&work=${work.queryCode}';
    }
  }
}

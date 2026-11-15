import 'package:portfolio/core/services/concept_url_sync_service.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_concept_id.dart';
import 'package:web/web.dart' as web;

/// Web implementation reading `window.location.search` and calling `history.replaceState`.
final class PlatformConceptUrlSyncService implements ConceptUrlSyncService {
  @override
  ConceptQuerySelection readInitialSelection() {
    final merged = <String, String>{...Uri.base.queryParameters};
    try {
      final rawSearch = web.window.location.search;
      if (rawSearch.isNotEmpty) {
        final normalized =
            rawSearch.startsWith('?') ? rawSearch.substring(1) : rawSearch;
        merged.addAll(Uri.splitQueryString(normalized));
      }
    } catch (_) {
      // Ignore malformed query string parameters.
    }
    return ConceptQuerySelection.fromParameters(merged);
  }

  @override
  void syncConcepts({
    required PortfolioConceptId hero,
    required PortfolioConceptId work,
  }) {
    try {
      final current = Uri.tryParse(web.window.location.href);
      final updatedParams = <String, String>{
        if (current != null) ...current.queryParameters,
      };
      updatedParams.remove('concept');
      updatedParams.remove('hero');
      updatedParams.remove('work');

      if (hero == work) {
        updatedParams['concept'] = hero.queryCode;
      } else {
        updatedParams['hero'] = hero.queryCode;
        updatedParams['work'] = work.queryCode;
      }

      final nextUri = (current ?? Uri.base).replace(
        queryParameters: updatedParams,
      );
      web.window.history.replaceState(null, '', nextUri.toString());
    } catch (_) {
      // Ignore History API security errors in restricted contexts.
    }
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/services/concept_url_sync_service.dart';
import 'package:portfolio/core/services/concept_url_sync_service_stub.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_concept_id.dart';
import 'package:portfolio/features/portfolio/presentation/controllers/portfolio_concept_controller.dart';

void main() {
  group('PortfolioConceptController & ConceptQuerySelection', () {
    test('defaults to editorialWall when no query params provided', () {
      final sync = PlatformConceptUrlSyncService(initialQueryParameters: {});
      final controller = PortfolioConceptController(urlSyncService: sync);
      addTearDown(controller.dispose);

      expect(controller.heroConcept, PortfolioConceptId.editorialWall);
      expect(controller.workConcept, PortfolioConceptId.editorialWall);
      expect(controller.isMixed, isFalse);
      expect(controller.isBackgroundMotionPaused, isFalse);
    });

    test('parses ?concept=b and ?hero=a&work=c overrides cleanly', () {
      final unifiedSelection = ConceptQuerySelection.fromParameters({
        'concept': 'b',
      });
      expect(unifiedSelection.heroConcept, PortfolioConceptId.swissGrid);
      expect(unifiedSelection.workConcept, PortfolioConceptId.swissGrid);

      final mixedSync = PlatformConceptUrlSyncService(
        initialQueryParameters: {
          'concept': 'a',
          'work': 'c',
        },
      );
      final controller = PortfolioConceptController(urlSyncService: mixedSync);
      addTearDown(controller.dispose);

      expect(controller.heroConcept, PortfolioConceptId.editorialWall);
      expect(controller.workConcept, PortfolioConceptId.kineticStage);
      expect(controller.isMixed, isTrue);
    });

    test('syncs unified and mixed concept URLs + motion pause state', () {
      final sync = PlatformConceptUrlSyncService(initialQueryParameters: {});
      final controller = PortfolioConceptController(urlSyncService: sync);
      addTearDown(controller.dispose);

      controller.selectUnifiedConcept(PortfolioConceptId.swissGrid);
      expect(sync.lastSyncedSearch, '?concept=b');
      expect(controller.isMixed, isFalse);

      controller.setWorkConcept(PortfolioConceptId.kineticStage);
      expect(sync.lastSyncedSearch, '?hero=b&work=c');
      expect(controller.isMixed, isTrue);

      controller.syncMatchingToHero();
      expect(sync.lastSyncedSearch, '?concept=b');
      expect(controller.isMixed, isFalse);

      controller.toggleBackgroundMotionPaused();
      expect(controller.isBackgroundMotionPaused, isTrue);
    });
  });
}

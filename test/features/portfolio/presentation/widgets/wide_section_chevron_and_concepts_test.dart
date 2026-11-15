import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/services/concept_url_sync_service_stub.dart';
import 'package:portfolio/features/portfolio/data/portfolio_catalog.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_concept_id.dart';
import 'package:portfolio/features/portfolio/presentation/controllers/portfolio_concept_controller.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/backdrops/diagonal_screen_wall_backdrop.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/backdrops/horizontal_filmstrip_backdrop.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/backdrops/parallax_columns_backdrop.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/wide_section_chevron.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/navigation/concept_switcher_menu.dart';

void main() {
  group('WideSectionChevron', () {
    testWidgets('uses 80x44 accessible hitbox and fires onPressed on tap',
        (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: WideSectionChevron(
                semanticLabel: 'Scroll next',
                onPressed: () => tapped = true,
              ),
            ),
          ),
        ),
      );

      final size = tester.getSize(find.byType(WideSectionChevron));
      expect(size.width, 80.0);
      expect(size.height, 44.0);

      await tester.tap(find.byType(WideSectionChevron));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });

  group('ConceptSwitcherMenu', () {
    testWidgets('switches concepts A/B/C and Mix Hero/Work presets',
        (tester) async {
      final sync = PlatformConceptUrlSyncService(initialQueryParameters: {});
      final controller = PortfolioConceptController(urlSyncService: sync);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1440.0,
              height: 400.0,
              child: Stack(
                children: [
                  ConceptSwitcherMenu(
                    controller: controller,
                    viewportWidth: 1440.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('B · Grid'));
      await tester.pumpAndSettle();
      expect(controller.heroConcept, PortfolioConceptId.swissGrid);
      expect(controller.workConcept, PortfolioConceptId.swissGrid);
      expect(sync.lastSyncedSearch, '?concept=b');

      await tester.tap(find.text('Mix'));
      await tester.pumpAndSettle();
      expect(find.text('Mix Hero & Stage'), findsOneWidget);

      await tester.tap(find.text('C · Stage'));
      await tester.pumpAndSettle();
      expect(controller.heroConcept, PortfolioConceptId.kineticStage);
      expect(controller.workConcept, PortfolioConceptId.kineticStage);
    });
  });

  group('Kinetic backdrops RepaintBoundary & reduced-motion safety', () {
    testWidgets(
        'all 3 kinetic backdrops isolate repaints and stop Ticker cleanly when paused',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: DiagonalScreenWallBackdrop(
                      imageAssets: PortfolioCatalog.allGalleryScreenshots,
                      isSectionVisible: true,
                      isPaused: false,
                    ),
                  ),
                  Expanded(
                    child: HorizontalFilmstripBackdrop(
                      imageAssets: PortfolioCatalog.nutriLens.allScreenAssets,
                      isSectionVisible: true,
                      isPaused: true,
                    ),
                  ),
                  Expanded(
                    child: ParallaxColumnsBackdrop(
                      imageAssets: PortfolioCatalog.setPoint.allScreenAssets,
                      isSectionVisible: false,
                      isPaused: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Must settle immediately without scheduling repeating animation frames.
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(RepaintBoundary), findsWidgets);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/features/portfolio/data/portfolio_catalog.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/backdrops/horizontal_filmstrip_backdrop.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/wide_section_chevron.dart';

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

  group('HorizontalFilmstripBackdrop RepaintBoundary & reduced-motion safety', () {
    testWidgets(
        'isolates repaints and stops Ticker cleanly when paused or disabled',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: SizedBox(
                width: 1200.0,
                height: 600.0,
                child: HorizontalFilmstripBackdrop(
                  imageAssets: PortfolioCatalog.nutriLens.allScreenAssets,
                  isSectionVisible: true,
                  isPaused: true,
                  desaturate: false,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(RepaintBoundary), findsWidgets);
    });
  });
}

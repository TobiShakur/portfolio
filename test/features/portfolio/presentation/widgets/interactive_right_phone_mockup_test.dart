import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/features/portfolio/data/portfolio_catalog.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/mockups/interactive_right_phone_mockup.dart';

void main() {

  group('InteractiveRightPhoneMockup', () {
    testWidgets('reveals CTA on mouse hover and triggers onOpenLiveDemo',
        (tester) async {
      var opened = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: InteractiveRightPhoneMockup(
                project: PortfolioCatalog.nutriLens,
                width: 260.0,
                onOpenLiveDemo: () => opened = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text(InteractiveRightPhoneMockup.ctaLabel), findsNothing);

      final mockupFinder = find.byType(InteractiveRightPhoneMockup);
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(mockupFinder));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 260));

      expect(find.text(InteractiveRightPhoneMockup.ctaLabel), findsOneWidget);

      await tester.tap(mockupFinder);
      await tester.pump();
      expect(opened, isTrue);
    });

    testWidgets('reveals CTA on keyboard focus without requiring hover',
        (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: InteractiveRightPhoneMockup(
                project: PortfolioCatalog.setPoint,
                width: 260.0,
                focusNode: focusNode,
                onOpenLiveDemo: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text(InteractiveRightPhoneMockup.ctaLabel), findsNothing);

      focusNode.requestFocus();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 260));

      expect(find.text(InteractiveRightPhoneMockup.ctaLabel), findsOneWidget);
    });
  });
}

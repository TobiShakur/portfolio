import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_section_id.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/navigation/floating_pill_sidebar.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/navigation/sidebar_nav_item.dart';

void main() {
  group('FloatingPillSidebar', () {
    testWidgets('uses intrinsic MainAxisSize.min height and 44x44 hit targets',
        (tester) async {
      PortfolioSectionId? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1440.0,
              height: 900.0,
              child: Stack(
                children: [
                  FloatingPillSidebar(
                    activeSection: PortfolioSectionId.overview,
                    isWideDesktop: true,
                    onSelectSection: (section) => selected = section,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final column = tester.widget<Column>(
        find.descendant(
          of: find.byType(FloatingPillSidebar),
          matching: find.byType(Column),
        ),
      );
      expect(column.mainAxisSize, MainAxisSize.min);

      final pillBox = tester.getSize(
        find
            .descendant(
              of: find.byType(FloatingPillSidebar),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(pillBox.height, lessThanOrEqualTo(280.0));
      expect(pillBox.width, AppSpacing.sidebarWidth);

      final navItems = find.byType(SidebarNavItem);
      expect(navItems, findsNWidgets(5));
      for (var i = 0; i < 5; i++) {
        final size = tester.getSize(navItems.at(i));
        expect(size.width, greaterThanOrEqualTo(44.0));
        expect(size.height, greaterThanOrEqualTo(44.0));
      }

      // Real Image.asset icons for NutriLens AI and SetPoint
      expect(find.byType(Image), findsNWidgets(2));

      await tester.tap(navItems.at(1));
      await tester.pump();
      expect(selected, PortfolioSectionId.nutrilens);

      await tester.tap(navItems.at(2));
      await tester.pump();
      expect(selected, PortfolioSectionId.setpoint);

      await tester.tap(navItems.at(3));
      await tester.pump();
      expect(selected, PortfolioSectionId.capabilities);

      await tester.tap(navItems.at(4));
      await tester.pump();
      expect(selected, PortfolioSectionId.contact);
    });

    testWidgets('hover reveals floating label tooltip', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1440.0,
              height: 900.0,
              child: Stack(
                children: [
                  FloatingPillSidebar(
                    activeSection: PortfolioSectionId.overview,
                    isWideDesktop: true,
                    onSelectSection: (_) {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final nutrilensItem = find.byType(SidebarNavItem).at(1);
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(nutrilensItem));
      await tester.pumpAndSettle();

      final tooltipOpacity = tester.widget<AnimatedOpacity>(
        find
            .descendant(
              of: nutrilensItem,
              matching: find.byType(AnimatedOpacity),
            )
            .first,
      );
      expect(tooltipOpacity.opacity, 1.0);
      expect(find.text('NutriLens AI'), findsOneWidget);
    });
  });
}

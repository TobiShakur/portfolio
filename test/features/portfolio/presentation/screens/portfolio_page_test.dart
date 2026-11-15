import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/app.dart';
import 'package:portfolio/features/portfolio/data/portfolio_catalog.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_section_id.dart';
import 'package:portfolio/features/portfolio/presentation/controllers/portfolio_navigation_controller.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/navigation/floating_pill_sidebar.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/navigation/mobile_bottom_pill_dock.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/navigation/sidebar_nav_item.dart';

import '../../../../fakes/fake_clipboard_service.dart';
import '../../../../fakes/fake_external_link_launcher.dart';

void main() {

  Future<void> pumpPortfolioAtSize(
    WidgetTester tester, {
    required Size size,
    required FakeExternalLinkLauncher linkLauncher,
    required FakeClipboardService clipboardService,
    PortfolioNavigationController? controller,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      PortfolioApp(
        linkLauncher: linkLauncher,
        clipboardService: clipboardService,
        controller: controller,
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
  }

  group('PortfolioPage responsive & interactive verification', () {
    testWidgets('renders at 1440x900 with zero overflows and working nav/actions',
        (tester) async {
      final linkLauncher = FakeExternalLinkLauncher();
      final clipboardService = FakeClipboardService();
      final controller = PortfolioNavigationController(
        linkLauncher: linkLauncher,
        clipboardService: clipboardService,
      );
      addTearDown(controller.dispose);

      await pumpPortfolioAtSize(
        tester,
        size: const Size(1440, 900),
        linkLauncher: linkLauncher,
        clipboardService: clipboardService,
        controller: controller,
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(FloatingPillSidebar), findsOneWidget);
      expect(find.byType(MobileBottomPillDock), findsNothing);

      expect(
        find.text('TOBÍAS GUTIÉRREZ · MOBILE SOFTWARE ENGINEER · GMT-3'),
        findsOneWidget,
      );
      expect(find.text('HOW I HELP TEAMS'), findsOneWidget);
      expect(find.text('Capabilities & Cloud Stack'), findsOneWidget);
      expect(find.text('ENGAGEMENT MODES'), findsOneWidget);
      expect(find.text('Hover to launch live demo ↗'), findsNWidgets(2));
      expect(find.text('NutriLens AI'), findsWidgets);
      expect(find.text('SetPoint'), findsWidgets);

      // Copy email button feedback
      await tester.tap(find.text('Copy'));
      await tester.pump();
      expect(clipboardService.copiedTexts, [PortfolioCatalog.profile.email]);
      expect(find.text('Copied ✓'), findsOneWidget);

      // GitHub & LinkedIn external links
      await tester.tap(find.text('GitHub ↗'));
      await tester.pump();
      await tester.tap(find.text('LinkedIn ↗'));
      await tester.pump();
      expect(linkLauncher.openedUrls, [
        PortfolioCatalog.profile.githubUrl,
        PortfolioCatalog.profile.linkedInUrl,
      ]);

      // Sidebar navigation scrolls to exact section offsets
      final sidebarItems = find.descendant(
        of: find.byType(FloatingPillSidebar),
        matching: find.byType(SidebarNavItem),
      );
      await tester.tap(sidebarItems.at(2));
      await tester.pumpAndSettle();
      expect(controller.activeSection, PortfolioSectionId.nutrilens);
      expect(controller.scrollController.offset, closeTo(1800.0, 1.0));

      await tester.tap(sidebarItems.at(3));
      await tester.pumpAndSettle();
      expect(controller.activeSection, PortfolioSectionId.setpoint);
      expect(controller.scrollController.offset, closeTo(2700.0, 1.0));

      // Project repo & live demo buttons pass exact URLs
      await tester.ensureVisible(find.text('View Source on GitHub ↗').last);
      await tester.tap(find.text('View Source on GitHub ↗').last);
      await tester.pump();
      expect(linkLauncher.openedUrls.last, PortfolioCatalog.setPoint.repoUrl);

      // Advance past email copy reset timer so no pending timers remain.
      await tester.pump(const Duration(milliseconds: 2300));
    });

    testWidgets('renders at 1024x768 Compact Desktop with zero overflows',
        (tester) async {
      final linkLauncher = FakeExternalLinkLauncher();
      final clipboardService = FakeClipboardService();

      await pumpPortfolioAtSize(
        tester,
        size: const Size(1024, 768),
        linkLauncher: linkLauncher,
        clipboardService: clipboardService,
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(FloatingPillSidebar), findsOneWidget);
      expect(find.text('HOW I HELP TEAMS'), findsOneWidget);
      expect(find.text('Capabilities & Cloud Stack'), findsOneWidget);
      expect(find.text('ENGAGEMENT MODES'), findsOneWidget);
      expect(find.text('NutriLens AI'), findsWidgets);
      expect(find.text('SetPoint'), findsWidgets);
    });

    testWidgets('renders at 390x844 Mobile with bottom dock and persistent CTAs',
        (tester) async {
      final linkLauncher = FakeExternalLinkLauncher();
      final clipboardService = FakeClipboardService();

      await pumpPortfolioAtSize(
        tester,
        size: const Size(390, 844),
        linkLauncher: linkLauncher,
        clipboardService: clipboardService,
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(FloatingPillSidebar), findsNothing);
      expect(find.byType(MobileBottomPillDock), findsOneWidget);
      expect(find.text('Try Live Interactive App ↗'), findsNWidgets(2));
    });
  });
}

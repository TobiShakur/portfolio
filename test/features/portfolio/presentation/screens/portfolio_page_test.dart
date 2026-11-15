import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/app.dart';
import 'package:portfolio/core/services/concept_url_sync_service_stub.dart';
import 'package:portfolio/features/portfolio/data/portfolio_catalog.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_concept_id.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_section_id.dart';
import 'package:portfolio/features/portfolio/presentation/controllers/portfolio_concept_controller.dart';
import 'package:portfolio/features/portfolio/presentation/controllers/portfolio_navigation_controller.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/portfolio_action_button.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/wide_section_chevron.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/navigation/concept_switcher_menu.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/navigation/floating_pill_sidebar.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/navigation/mobile_top_app_bar.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/navigation/sidebar_nav_item.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/sections/portfolio_footer_strip.dart';

import '../../../../fakes/fake_clipboard_service.dart';
import '../../../../fakes/fake_external_link_launcher.dart';

void main() {
  Future<void> pumpPortfolioAtSize(
    WidgetTester tester, {
    required Size size,
    required FakeExternalLinkLauncher linkLauncher,
    required FakeClipboardService clipboardService,
    PortfolioNavigationController? controller,
    PortfolioConceptController? conceptController,
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
        conceptController: conceptController,
      ),
    );
    await tester.pump(const Duration(milliseconds: 120));
  }

  group('PortfolioPage r8 responsive & 3-concept verification', () {
    testWidgets('renders 1440x900 Desktop, switches A->B->C cleanly, and navigates 5 stops',
        (tester) async {
      final linkLauncher = FakeExternalLinkLauncher();
      final clipboardService = FakeClipboardService();
      final controller = PortfolioNavigationController(
        linkLauncher: linkLauncher,
        clipboardService: clipboardService,
      );
      final conceptController = PortfolioConceptController(
        urlSyncService: PlatformConceptUrlSyncService(initialQueryParameters: {}),
      );
      addTearDown(() {
        controller.dispose();
        conceptController.dispose();
      });

      await pumpPortfolioAtSize(
        tester,
        size: const Size(1440, 900),
        linkLauncher: linkLauncher,
        clipboardService: clipboardService,
        controller: controller,
        conceptController: conceptController,
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(FloatingPillSidebar), findsOneWidget);
      expect(find.byType(ConceptSwitcherMenu), findsOneWidget);
      expect(find.byType(MobileTopAppBar), findsNothing);
      expect(find.byType(WideSectionChevron), findsNWidgets(5));

      expect(find.text(PortfolioCatalog.profile.identityLine), findsOneWidget);
      expect(find.text(PortfolioCatalog.capabilitiesSectionTitle), findsOneWidget);
      expect(find.text(PortfolioCatalog.matchUpProof.title), findsOneWidget);
      expect(find.text('NutriLens AI'), findsWidgets);
      expect(find.text('SetPoint'), findsWidgets);

      // Copy email button feedback
      await tester.tap(find.text('Copy'));
      await tester.pump();
      expect(clipboardService.copiedTexts, [PortfolioCatalog.profile.email]);
      expect(find.text('Copied ✓'), findsOneWidget);

      // GitHub & LinkedIn external links in Hero
      await tester.tap(find.text('GitHub ↗').first);
      await tester.pump();
      await tester.tap(find.text('LinkedIn ↗').first);
      await tester.pump();
      expect(linkLauncher.openedUrls, [
        PortfolioCatalog.profile.githubUrl,
        PortfolioCatalog.profile.linkedInUrl,
      ]);

      // Switch Concepts A -> B -> C live with zero overflow
      await tester.tap(find.text('B · Grid'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull);
      expect(conceptController.heroConcept, PortfolioConceptId.swissGrid);
      expect(find.text('ENG-PORTFOLIO // BUENOS AIRES (GMT-3)'), findsOneWidget);

      await tester.tap(find.text('C · Stage'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull);
      expect(conceptController.heroConcept, PortfolioConceptId.kineticStage);

      // Sidebar navigation across the 5 stops
      final sidebarItems = find.descendant(
        of: find.byType(FloatingPillSidebar),
        matching: find.byType(SidebarNavItem),
      );
      expect(sidebarItems, findsNWidgets(5));

      await tester.tap(sidebarItems.at(1));
      await tester.pump(const Duration(milliseconds: 700));
      expect(controller.activeSection, PortfolioSectionId.nutrilens);

      await tester.tap(sidebarItems.at(3));
      await tester.pump(const Duration(milliseconds: 700));
      expect(controller.activeSection, PortfolioSectionId.capabilities);

      await tester.tap(sidebarItems.at(4));
      await tester.pump(const Duration(milliseconds: 700));
      expect(controller.activeSection, PortfolioSectionId.contact);

      // Accessible footer links >= 44x44 and compact (not stretched 100% width)
      final footerLinks = find.byType(PortfolioFooterLink);
      expect(footerLinks, findsWidgets);
      for (var i = 0; i < footerLinks.evaluate().length; i++) {
        final sz = tester.getSize(footerLinks.at(i));
        expect(sz.width, greaterThanOrEqualTo(44.0));
        expect(sz.width, lessThan(200.0));
        expect(sz.height, greaterThanOrEqualTo(44.0));
      }
      final pauseButtons = find.bySemanticsLabel('Pause background motion');
      expect(pauseButtons, findsWidgets);
      for (var i = 0; i < pauseButtons.evaluate().length; i++) {
        final sz = tester.getSize(pauseButtons.at(i));
        expect(sz.width, greaterThanOrEqualTo(44.0));
        expect(sz.width, lessThan(140.0));
      }
      final githubRect = tester.getRect(footerLinks.at(0));
      final linkedInRect = tester.getRect(footerLinks.at(1));
      expect(githubRect.center.dy, closeTo(linkedInRect.center.dy, 1.0));

      // Advance past email reset timer
      await tester.pump(const Duration(milliseconds: 2300));
    });

    testWidgets('renders all 3 concepts at 1280x720 laptop desktop with zero clipping',
        (tester) async {
      for (final concept in PortfolioConceptId.values) {
        final linkLauncher = FakeExternalLinkLauncher();
        final clipboardService = FakeClipboardService();
        final controller = PortfolioNavigationController(
          linkLauncher: linkLauncher,
          clipboardService: clipboardService,
        );
        final conceptController = PortfolioConceptController(
          initialHeroConcept: concept,
          initialWorkConcept: concept,
          urlSyncService: PlatformConceptUrlSyncService(initialQueryParameters: {}),
        );

        await pumpPortfolioAtSize(
          tester,
          size: const Size(1280, 720),
          linkLauncher: linkLauncher,
          clipboardService: clipboardService,
          controller: controller,
          conceptController: conceptController,
        );
        expect(tester.takeException(), isNull, reason: 'Failed overview for $concept');

        // Verify SetPoint CTAs stay strictly visible inside 1280x720 section
        await controller.scrollToSection(
          PortfolioSectionId.setpoint,
          reduceMotion: true,
        );
        await tester.pump(const Duration(milliseconds: 50));
        expect(tester.takeException(), isNull, reason: 'Failed setpoint for $concept');

        final demoBtnRect = tester.getRect(
          find
              .ancestor(
                of: find.text('Open Live Demo ↗').last,
                matching: find.byType(PortfolioActionButton),
              )
              .first,
        );
        expect(demoBtnRect.bottom, lessThanOrEqualTo(720.0));

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
        controller.dispose();
        conceptController.dispose();
      }
    });

    testWidgets('renders at 768x1024 Tablet with non-overlapping MobileTopAppBar',
        (tester) async {
      final linkLauncher = FakeExternalLinkLauncher();
      final clipboardService = FakeClipboardService();

      await pumpPortfolioAtSize(
        tester,
        size: const Size(768, 1024),
        linkLauncher: linkLauncher,
        clipboardService: clipboardService,
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(FloatingPillSidebar), findsNothing);
      expect(find.byType(MobileTopAppBar), findsOneWidget);

      final barRect = tester.getRect(find.byType(MobileTopAppBar));
      final scrollRect = tester.getRect(find.byType(SingleChildScrollView).last);
      expect(scrollRect.width, closeTo(768.0, 1.0));
      expect(scrollRect.height, greaterThan(900.0));
      final identityRect =
          tester.getRect(find.text(PortfolioCatalog.profile.identityLine));
      expect(identityRect.top, greaterThanOrEqualTo(barRect.bottom));
    });

    testWidgets('renders at 390x844 Mobile with zero top-bar collisions & Pause stops motion',
        (tester) async {
      final linkLauncher = FakeExternalLinkLauncher();
      final clipboardService = FakeClipboardService();
      final conceptController = PortfolioConceptController(
        urlSyncService: PlatformConceptUrlSyncService(initialQueryParameters: {}),
      );
      addTearDown(conceptController.dispose);

      await pumpPortfolioAtSize(
        tester,
        size: const Size(390, 844),
        linkLauncher: linkLauncher,
        clipboardService: clipboardService,
        conceptController: conceptController,
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(FloatingPillSidebar), findsNothing);
      expect(find.byType(MobileTopAppBar), findsOneWidget);

      // MobileTopAppBar is in Column strictly above Hero headline & canvas expands cleanly
      final barRect = tester.getRect(find.byType(MobileTopAppBar));
      final scrollRect = tester.getRect(find.byType(SingleChildScrollView).last);
      expect(scrollRect.width, closeTo(390.0, 1.0));
      expect(scrollRect.height, greaterThan(700.0));
      final heroHeadlineRect = tester.getRect(
        find.text(
          '${PortfolioCatalog.heroHeadlineFor(PortfolioConceptId.editorialWall).$1}\n'
          '${PortfolioCatalog.heroHeadlineFor(PortfolioConceptId.editorialWall).$2}',
        ),
      );
      expect(heroHeadlineRect.top, greaterThanOrEqualTo(barRect.bottom));

      // Pausing background motion settles Ticker completely
      conceptController.toggleBackgroundMotionPaused();
      await tester.pumpAndSettle();
      expect(conceptController.isBackgroundMotionPaused, isTrue);
    });
  });
}

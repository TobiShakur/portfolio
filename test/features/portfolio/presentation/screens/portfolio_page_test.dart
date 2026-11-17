import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/app.dart';
import 'package:portfolio/features/portfolio/data/portfolio_catalog.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_section_id.dart';
import 'package:portfolio/features/portfolio/presentation/controllers/portfolio_navigation_controller.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/portfolio_action_button.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/wide_section_chevron.dart';
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
    await tester.pump(const Duration(milliseconds: 120));
  }

  group('PortfolioPage r12 fixed production layout verification', () {
    testWidgets('renders 1440x900 Desktop without concept switcher and navigates 5 stops',
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
      expect(find.byType(MobileTopAppBar), findsNothing);
      expect(find.text('A · Wall'), findsNothing);
      expect(find.text('B · Grid'), findsNothing);
      expect(find.text('C · Stage'), findsNothing);
      expect(find.byType(WideSectionChevron), findsNWidgets(3));

      expect(find.text(PortfolioCatalog.profile.identityLine), findsOneWidget);
      expect(find.text(PortfolioCatalog.capabilitiesSectionTitle), findsOneWidget);
      expect(find.text('Core platforms & tooling'), findsOneWidget);
      expect(find.text('Figma'), findsOneWidget);
      expect(find.text('OpenStreetMap'), findsOneWidget);
      expect(find.text(PortfolioCatalog.matchUpProof.title), findsOneWidget);
      expect(find.text('NutriLens AI'), findsWidgets);
      expect(find.text('SetPoint'), findsWidgets);

      // Copy email feedback & Hero 2-CTA wrap check
      final exploreBtnRect = tester.getRect(find.text('Explore work'));
      final copyChipRect = tester.getRect(find.text('Copy'));
      expect(
        copyChipRect.center.dy - exploreBtnRect.center.dy,
        lessThanOrEqualTo(68.0),
      );

      await tester.tap(find.text('Copy'));
      await tester.pump();
      expect(clipboardService.copiedTexts, [PortfolioCatalog.profile.email]);
      expect(find.text('Copied'), findsOneWidget);

      // GitHub & LinkedIn external links in Hero
      await tester.tap(find.text('GitHub').first);
      await tester.pump();
      await tester.tap(find.text('LinkedIn').first);
      await tester.pump();
      expect(linkLauncher.openedUrls, [
        PortfolioCatalog.profile.githubUrl,
        PortfolioCatalog.profile.linkedInUrl,
      ]);

      // Hero switcher switches proof tabs cleanly
      await tester.tap(find.text('SetPoint').first);
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('MatchUp').first);
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull);

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

      // Accessible footer links >= 44x44 and compact
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

    testWidgets('renders 1280x720 laptop desktop with zero clipping',
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
        size: const Size(1280, 720),
        linkLauncher: linkLauncher,
        clipboardService: clipboardService,
        controller: controller,
      );
      expect(tester.takeException(), isNull);

      await controller.scrollToSection(
        PortfolioSectionId.setpoint,
        reduceMotion: true,
      );
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.takeException(), isNull);

      final demoBtnRect = tester.getRect(
        find
            .ancestor(
              of: find.text('Open live demo').last,
              matching: find.byType(PortfolioActionButton),
            )
            .first,
      );
      expect(demoBtnRect.bottom, lessThanOrEqualTo(720.0));
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
      expect(find.text('Mix'), findsNothing);

      final barRect = tester.getRect(find.byType(MobileTopAppBar));
      final scrollRect = tester.getRect(find.byType(SingleChildScrollView).last);
      expect(scrollRect.width, closeTo(768.0, 1.0));
      expect(scrollRect.height, greaterThan(900.0));
      final identityRect =
          tester.getRect(find.text(PortfolioCatalog.profile.identityLine));
      expect(identityRect.top, greaterThanOrEqualTo(barRect.bottom));
    });

    testWidgets('renders at 390x844 Mobile cleanly and Pause stops motion',
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
        size: const Size(390, 844),
        linkLauncher: linkLauncher,
        clipboardService: clipboardService,
        controller: controller,
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(FloatingPillSidebar), findsNothing);
      expect(find.byType(MobileTopAppBar), findsOneWidget);

      final barRect = tester.getRect(find.byType(MobileTopAppBar));
      final scrollRect = tester.getRect(find.byType(SingleChildScrollView).last);
      expect(scrollRect.width, closeTo(390.0, 1.0));
      expect(scrollRect.height, greaterThan(700.0));
      final heroHeadlineRect = tester.getRect(
        find.text(
          '${PortfolioCatalog.profile.headlineLine1}\n'
          '${PortfolioCatalog.profile.headlineLine2}',
        ),
      );
      expect(heroHeadlineRect.top, greaterThanOrEqualTo(barRect.bottom));

      // Pausing background motion settles Ticker completely
      controller.toggleBackgroundMotionPaused();
      await tester.pumpAndSettle();
      expect(controller.isBackgroundMotionPaused, isTrue);
    });
  });
}

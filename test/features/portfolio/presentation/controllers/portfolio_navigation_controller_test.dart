import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/services/external_link_launcher.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_section_id.dart';
import 'package:portfolio/features/portfolio/presentation/controllers/portfolio_navigation_controller.dart';

import '../../../../fakes/fake_clipboard_service.dart';
import '../../../../fakes/fake_external_link_launcher.dart';

void main() {
  group('PortfolioNavigationController', () {
    late FakeExternalLinkLauncher linkLauncher;
    late FakeClipboardService clipboardService;
    late ScrollController scrollController;
    late PortfolioNavigationController controller;

    setUp(() {
      linkLauncher = FakeExternalLinkLauncher();
      clipboardService = FakeClipboardService();
      scrollController = ScrollController();
      controller = PortfolioNavigationController(
        linkLauncher: linkLauncher,
        clipboardService: clipboardService,
        scrollController: scrollController,
      );
    });

    tearDown(() {
      controller.dispose();
      scrollController.dispose();
    });

    testWidgets('updates activeSection on desktop scroll and scrollToSection',
        (tester) async {
      const vh = 900.0;
      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            height: vh,
            child: SingleChildScrollView(
              controller: scrollController,
              child: const Column(
                children: [
                  SizedBox(height: vh),
                  SizedBox(height: vh),
                  SizedBox(height: vh),
                  SizedBox(height: vh),
                  SizedBox(height: vh),
                ],
              ),
            ),
          ),
        ),
      );

      controller.updateViewportMetrics(viewportHeight: vh, isDesktop: true);
      expect(controller.activeSection, PortfolioSectionId.overview);

      scrollController.jumpTo(1 * vh);
      await tester.pump();
      expect(controller.activeSection, PortfolioSectionId.nutrilens);

      scrollController.jumpTo(2 * vh);
      await tester.pump();
      expect(controller.activeSection, PortfolioSectionId.setpoint);

      scrollController.jumpTo(3 * vh);
      await tester.pump();
      expect(controller.activeSection, PortfolioSectionId.capabilities);

      scrollController.jumpTo(4 * vh);
      await tester.pump();
      expect(controller.activeSection, PortfolioSectionId.contact);

      await controller.scrollToSection(
        PortfolioSectionId.nutrilens,
        reduceMotion: true,
      );
      await tester.pump();
      expect(scrollController.offset, 1 * vh);
      expect(controller.activeSection, PortfolioSectionId.nutrilens);

      await controller.stepSection(1, reduceMotion: true);
      await tester.pump();
      expect(controller.activeSection, PortfolioSectionId.setpoint);
    });

    testWidgets(
        'handleDesktopWheelScroll snaps bounded section and yields inside tall section',
        (tester) async {
      const vh = 700.0;
      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            height: vh,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  SizedBox(
                    key: controller.sectionKeys[PortfolioSectionId.overview],
                    height: 1100.0,
                  ),
                  SizedBox(
                    key: controller.sectionKeys[PortfolioSectionId.nutrilens],
                    height: vh,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      controller.updateViewportMetrics(viewportHeight: vh, isDesktop: true);

      // Inside tall Overview section (bottom at 1100 > vh=700): must NOT hijack scroll.
      expect(
        controller.handleDesktopWheelScroll(deltaY: 40.0, reduceMotion: false),
        isFalse,
      );

      // Tiny trackpad jitter < 18px: ignored.
      expect(
        controller.handleDesktopWheelScroll(deltaY: 10.0, reduceMotion: false),
        isFalse,
      );

      // Jump to bottom edge of Overview so bottom fits viewport -> snaps cleanly!
      scrollController.jumpTo(450.0);
      await tester.pump();
      expect(
        controller.handleDesktopWheelScroll(deltaY: 48.0, reduceMotion: false),
        isTrue,
      );
      await tester.pump(const Duration(milliseconds: 700));
      expect(controller.activeSection, PortfolioSectionId.nutrilens);
    });

    testWidgets('copyEmail sets CopyEmailCopied then resets after 2.2s',
        (tester) async {
      await controller.copyEmail('tobigutierrez26@gmail.com');

      expect(clipboardService.copiedTexts, ['tobigutierrez26@gmail.com']);
      expect(controller.copyEmailState, isA<CopyEmailCopied>());

      await tester.pump(const Duration(milliseconds: 2300));
      expect(controller.copyEmailState, isA<CopyEmailIdle>());
    });

    testWidgets('openExternalUrl falls back to clipboard + safe toast on error',
        (tester) async {
      const validUrl = 'https://github.com/TobiShakur';
      linkLauncher.nextResult = const LinkLaunchFailure();

      await controller.openExternalUrl(validUrl);

      expect(linkLauncher.openedUrls, [validUrl]);
      expect(clipboardService.copiedTexts, [validUrl]);
      expect(
        controller.toastMessage,
        'Could not open link — URL copied to clipboard',
      );

      await tester.pump(const Duration(seconds: 3));
      expect(controller.toastMessage, isNull);
    });

    test('openExternalUrl rejects invalid URL without copying to clipboard',
        () async {
      linkLauncher.nextResult = const LinkLaunchRejected();

      await controller.openExternalUrl('javascript:alert(1)');

      expect(clipboardService.copiedTexts, isEmpty);
      expect(controller.toastMessage, 'Blocked invalid external URL');
    });
  });
}

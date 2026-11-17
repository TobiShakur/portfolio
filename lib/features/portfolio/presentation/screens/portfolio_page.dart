import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/core/services/perf_telemetry_service.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/features/portfolio/data/portfolio_catalog.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_section_id.dart';
import 'package:portfolio/features/portfolio/presentation/controllers/portfolio_navigation_controller.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/feedback_toast.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/debug/perf_debug_overlay.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/navigation/floating_pill_sidebar.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/navigation/mobile_top_app_bar.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/sections/capabilities_section.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/sections/closing_contact_section.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/sections/overview_hero_section.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/sections/project_showcase_section.dart';

class _StepSectionIntent extends Intent {
  const _StepSectionIntent(this.delta);

  final int delta;
}

/// Top-level single-page 4-act / 5-stop portfolio scaffold with anti-hijack
/// section snapping on desktop and opaque top nav bar below 960px.
class PortfolioPage extends StatelessWidget {
  const PortfolioPage({
    required this.controller,
    super.key,
    this.perfTelemetryService,
  });

  final PortfolioNavigationController controller;
  final PerfTelemetryService? perfTelemetryService;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Shortcuts(
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.pageDown): _StepSectionIntent(1),
          SingleActivator(LogicalKeyboardKey.pageUp): _StepSectionIntent(-1),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            _StepSectionIntent: CallbackAction<_StepSectionIntent>(
              onInvoke: (intent) {
                controller.stepSection(
                  intent.delta,
                  reduceMotion: reduceMotion,
                );
                return null;
              },
            ),
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              final isWideDesktop = width >= AppSpacing.wideDesktop;
              final isDesktop = width >= AppSpacing.desktop;
              final isTablet =
                  width >= AppSpacing.tablet && width < AppSpacing.desktop;

              final scrollViewportHeight = isDesktop
                  ? height
                  : (height - AppSpacing.mobileTopBarHeight)
                      .clamp(240.0, height);
              final sectionHeight =
                  PortfolioNavigationController.effectiveSectionHeight(
                scrollViewportHeight,
              );

              controller.updateViewportMetrics(
                viewportHeight: scrollViewportHeight,
                isDesktop: isDesktop,
              );

              final scrollContent = ListenableBuilder(
                listenable: controller,
                builder: (context, _) {
                  final isMotionPaused = controller.isBackgroundMotionPaused;
                  final activeIndex = controller.activeSection.index;

                  final isNutriLensNear = activeIndex <= 2;
                  final isSetPointNear = activeIndex >= 1 && activeIndex <= 3;

                  final scrollChild = SingleChildScrollView(
                    controller: controller.scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        KeyedSubtree(
                          key: controller.sectionKeys[PortfolioSectionId.overview],
                          child: OverviewHeroSection(
                            controller: controller,
                            isDesktop: isDesktop,
                            isWideDesktop: isWideDesktop,
                            sectionHeight: sectionHeight,
                            onChevronNext: () => controller.scrollToSection(
                              PortfolioSectionId.nutrilens,
                              reduceMotion: reduceMotion,
                            ),
                          ),
                        ),
                        KeyedSubtree(
                          key:
                              controller.sectionKeys[PortfolioSectionId.nutrilens],
                          child: ProjectShowcaseSection(
                            project: PortfolioCatalog.nutriLens,
                            projectIndex: 0,
                            isDesktop: isDesktop,
                            isWideDesktop: isWideDesktop,
                            sectionHeight: sectionHeight,
                            isSectionVisible: isNutriLensNear,
                            isMotionPaused: isMotionPaused,
                            onToggleMotionPaused:
                                controller.toggleBackgroundMotionPaused,
                            onOpenUrl: controller.openExternalUrl,
                            onChevronNext: () => controller.scrollToSection(
                              PortfolioSectionId.setpoint,
                              reduceMotion: reduceMotion,
                            ),
                          ),
                        ),
                        KeyedSubtree(
                          key: controller.sectionKeys[PortfolioSectionId.setpoint],
                          child: ProjectShowcaseSection(
                            project: PortfolioCatalog.setPoint,
                            projectIndex: 1,
                            isDesktop: isDesktop,
                            isWideDesktop: isWideDesktop,
                            sectionHeight: sectionHeight,
                            isSectionVisible: isSetPointNear,
                            isMotionPaused: isMotionPaused,
                            onToggleMotionPaused:
                                controller.toggleBackgroundMotionPaused,
                            onOpenUrl: controller.openExternalUrl,
                            onChevronNext: () => controller.scrollToSection(
                              PortfolioSectionId.capabilities,
                              reduceMotion: reduceMotion,
                            ),
                          ),
                        ),
                        KeyedSubtree(
                          key: controller
                              .sectionKeys[PortfolioSectionId.capabilities],
                          child: CapabilitiesSection(
                            isDesktop: isDesktop,
                            isWideDesktop: isWideDesktop,
                            sectionHeight: sectionHeight,
                          ),
                        ),
                        KeyedSubtree(
                          key: controller.sectionKeys[PortfolioSectionId.contact],
                          child: ClosingContactSection(
                            controller: controller,
                            isDesktop: isDesktop,
                            isWideDesktop: isWideDesktop,
                            onBackToTop: () => controller.scrollToSection(
                              PortfolioSectionId.overview,
                              reduceMotion: reduceMotion,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (!isDesktop) {
                    return scrollChild;
                  }

                  return Listener(
                    onPointerSignal: (signal) {
                      if (signal is PointerScrollEvent) {
                        controller.handleDesktopWheelScroll(
                          deltaY: signal.scrollDelta.dy,
                          reduceMotion: reduceMotion,
                        );
                      }
                    },
                    child: scrollChild,
                  );
                },
              );

              final Widget mainCanvasStack = Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(child: scrollContent),
                  if (isDesktop)
                    RepaintBoundary(
                      child: ListenableBuilder(
                        listenable: controller,
                        builder: (context, _) => FloatingPillSidebar(
                          activeSection: controller.activeSection,
                          isWideDesktop: isWideDesktop,
                          onHoverSection: controller.setHoveredSidebarSection,
                          onSelectSection: (section) =>
                              controller.scrollToSection(
                            section,
                            reduceMotion: reduceMotion,
                          ),
                        ),
                      ),
                    ),
                  ListenableBuilder(
                    listenable: controller,
                    builder: (context, _) {
                      if (controller.toastMessage == null) {
                        return const SizedBox.shrink();
                      }
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 24.0,
                            left: 20.0,
                            right: 20.0,
                          ),
                          child: FeedbackToast(
                            message: controller.toastMessage!,
                            onDismiss: controller.dismissToast,
                          ),
                        ),
                      );
                    },
                  ),
                  PerfDebugOverlay(telemetryService: perfTelemetryService),
                ],
              );

              if (isDesktop) {
                return mainCanvasStack;
              }

              return SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    ListenableBuilder(
                      listenable: controller,
                      builder: (context, _) => MobileTopAppBar(
                        activeSection: controller.activeSection,
                        onSelectSection: (section) => controller.scrollToSection(
                          section,
                          reduceMotion: reduceMotion,
                        ),
                        isTablet: isTablet,
                      ),
                    ),
                    Expanded(child: mainCanvasStack),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

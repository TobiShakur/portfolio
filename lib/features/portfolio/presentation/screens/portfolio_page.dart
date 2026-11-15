import 'package:flutter/material.dart';
import 'package:portfolio/core/services/perf_telemetry_service.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/features/portfolio/data/portfolio_catalog.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_section_id.dart';
import 'package:portfolio/features/portfolio/presentation/controllers/portfolio_navigation_controller.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/feedback_toast.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/debug/perf_debug_overlay.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/navigation/floating_pill_sidebar.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/navigation/mobile_bottom_pill_dock.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/sections/engineering_approach_section.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/sections/how_i_help_section.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/sections/overview_hero_section.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/sections/project_showcase_section.dart';

/// Root single-page portfolio screen with responsive desktop 100vh cadence
/// and floating pill navigation.
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final isWideDesktop = width >= AppSpacing.wideDesktop;
          final isDesktop = width >= AppSpacing.desktop;
          final isTablet = width >= AppSpacing.tablet && !isDesktop;
          final isMobile = width < AppSpacing.tablet;
          final sectionHeight =
              PortfolioNavigationController.effectiveSectionHeight(height);

          controller.updateViewportMetrics(
            viewportHeight: height,
            isDesktop: isDesktop,
          );

          return Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: RepaintBoundary(
                    child: ListenableBuilder(
                      listenable: controller,
                      builder: (context, _) => _AmbientCanvasGlow(
                        activeSection: controller.activeSection,
                      ),
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                controller: controller.scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    KeyedSubtree(
                      key: controller.sectionKeys[PortfolioSectionId.overview],
                      child: ListenableBuilder(
                        listenable: controller,
                        builder: (context, _) => OverviewHeroSection(
                          profile: PortfolioCatalog.profile,
                          copyEmailState: controller.copyEmailState,
                          isDesktop: isDesktop,
                          isMobile: isMobile,
                          sectionHeight: isDesktop ? sectionHeight : null,
                          onExploreProjects: () => controller.scrollToSection(
                            PortfolioSectionId.nutrilens,
                            reduceMotion: reduceMotion,
                          ),
                          onOpenUrl: controller.openExternalUrl,
                          onCopyEmail: () => controller.copyEmail(
                            PortfolioCatalog.profile.email,
                          ),
                        ),
                      ),
                    ),
                    KeyedSubtree(
                      key: controller.sectionKeys[PortfolioSectionId.howIHelp],
                      child: HowIHelpSection(
                        steps: PortfolioCatalog.profile.snapshotHighlights,
                        isDesktop: isDesktop,
                        isMobile: isMobile,
                        sectionHeight: isDesktop ? sectionHeight : null,
                      ),
                    ),
                    KeyedSubtree(
                      key:
                          controller.sectionKeys[PortfolioSectionId.engineering],
                      child: EngineeringApproachSection(
                        pillars: PortfolioCatalog.engineeringPillars,
                        isDesktop: isDesktop,
                        isWideDesktop: isWideDesktop,
                        isMobile: isMobile,
                        sectionHeight: isDesktop ? sectionHeight : null,
                      ),
                    ),
                    KeyedSubtree(
                      key: controller.sectionKeys[PortfolioSectionId.nutrilens],
                      child: ProjectShowcaseSection(
                        project: PortfolioCatalog.nutriLens,
                        isDesktop: isDesktop,
                        isWideDesktop: isWideDesktop,
                        isTablet: isTablet,
                        isMobile: isMobile,
                        sectionHeight: isDesktop ? sectionHeight : null,
                        onOpenUrl: controller.openExternalUrl,
                      ),
                    ),
                    KeyedSubtree(
                      key: controller.sectionKeys[PortfolioSectionId.setpoint],
                      child: ProjectShowcaseSection(
                        project: PortfolioCatalog.setPoint,
                        isDesktop: isDesktop,
                        isWideDesktop: isWideDesktop,
                        isTablet: isTablet,
                        isMobile: isMobile,
                        sectionHeight: isDesktop ? sectionHeight : null,
                        footerProfile: PortfolioCatalog.profile,
                        onOpenUrl: controller.openExternalUrl,
                      ),
                    ),
                  ],
                ),
              ),
              if (isDesktop)
                RepaintBoundary(
                  child: ListenableBuilder(
                    listenable: controller,
                    builder: (context, _) => FloatingPillSidebar(
                      activeSection: controller.activeSection,
                      isWideDesktop: isWideDesktop,
                      onHoverSection: controller.setHoveredSidebarSection,
                      onSelectSection: (section) => controller.scrollToSection(
                        section,
                        reduceMotion: reduceMotion,
                      ),
                    ),
                  ),
                )
              else
                RepaintBoundary(
                  child: ListenableBuilder(
                    listenable: controller,
                    builder: (context, _) => MobileBottomPillDock(
                      activeSection: controller.activeSection,
                      onSelectSection: (section) => controller.scrollToSection(
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
                      padding: EdgeInsets.only(
                        bottom: isDesktop ? 24.0 : 92.0,
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
        },
      ),
    );
  }
}

class _AmbientCanvasGlow extends StatelessWidget {
  const _AmbientCanvasGlow({required this.activeSection});

  final PortfolioSectionId activeSection;

  @override
  Widget build(BuildContext context) {
    final tint = switch (activeSection) {
      PortfolioSectionId.overview ||
      PortfolioSectionId.howIHelp ||
      PortfolioSectionId.engineering =>
        AppColors.accentEngineering,
      PortfolioSectionId.nutrilens => AppColors.accentNutriLensDeep,
      PortfolioSectionId.setpoint => AppColors.accentSetPointDeep,
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.65, -0.35),
          radius: 1.15,
          colors: [
            tint.withValues(alpha: 0.07),
            AppColors.bgCanvas.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}

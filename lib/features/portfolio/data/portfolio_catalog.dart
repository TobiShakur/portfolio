import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/features/portfolio/domain/entities/engineering_pillar.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_section_id.dart';
import 'package:portfolio/features/portfolio/domain/entities/profile_data.dart';
import 'package:portfolio/features/portfolio/domain/entities/project_showcase.dart';
import 'package:portfolio/features/portfolio/domain/entities/tech_brand.dart';

/// Verified English copy deck and project catalog for the portfolio.
abstract final class PortfolioCatalog {
  static const ProfileData profile = ProfileData(
    fullName: 'Tobías Gutiérrez',
    roleTitle: 'Mobile Software Engineer · GMT-3',
    headlineLine1: 'Flutter & native apps,',
    headlineLine2: 'from Figma to the stores.',
    supportingPitch:
        'I build production iOS, Android, and Web apps with Firebase backends, '
        'secure AI pipelines, and automated tests.',
    githubUrl: 'https://github.com/TobiShakur',
    linkedInUrl: 'https://linkedin.com/in/tobias-gutierrez',
    email: 'tobigutierrez26@gmail.com',
    verificationMetrics: [
      'Flutter & Dart 3',
      'Firebase & Cloud',
      'Cloudflare Workers',
      '177 Automated Tests Shipped',
    ],
    coreStackLogos: [
      TechBrandChipItem(label: 'Flutter', brand: TechBrand.flutter),
      TechBrandChipItem(label: 'Dart 3', brand: TechBrand.dart),
      TechBrandChipItem(label: 'BLoC / Riverpod'),
      TechBrandChipItem(label: 'Firebase', brand: TechBrand.firebase),
      TechBrandChipItem(label: 'REST & AI APIs', brand: TechBrand.gemini),
      TechBrandChipItem(label: 'iOS & Android', brand: TechBrand.android),
      TechBrandChipItem(label: 'Figma', brand: TechBrand.figma),
      TechBrandChipItem(
        label: 'GitHub Actions',
        brand: TechBrand.githubActions,
      ),
    ],
    snapshotHighlights: [
      SnapshotHighlight(
        label: 'End-to-End Mobile Delivery',
        value:
            'Full iOS, Android & Flutter Web apps from Figma specs to App Store & Play Store release.',
      ),
      SnapshotHighlight(
        label: 'Backend & AI Included for MVPs',
        value:
            'No separate backend hire needed: Firebase (Auth, Firestore, Functions, Push) and Cloudflare AI proxies.',
      ),
      SnapshotHighlight(
        label: 'Clean Architecture & Automated QA',
        value:
            'BLoC, Provider & Riverpod state machines, testable web builds every sprint, and 177 automated tests.',
        tabular: true,
      ),
      SnapshotHighlight(
        label: 'Direct Overlap & Bilingual Communication',
        value:
            'Available for freelance builds and remote roles in GMT-3 (full US East & EU overlap), English & Spanish.',
      ),
    ],
  );

  static const String howIHelpSectionTitle = 'How I Help Teams';
  static const String howIHelpSectionSubtitle =
      'Clear scope, direct communication, and full ownership from architecture '
      'to store release.';

  static const String engineeringSectionTitle = 'Core Stack & Deliverables';
  static const String engineeringSectionSubtitle =
      'Production-proven technologies behind every mobile app, backend, and '
      'automated release.';

  static const List<EngineeringPillar> engineeringPillars = [
    EngineeringPillar(
      id: 'mobile-delivery',
      title: 'Cross-Platform UI & Native',
      description:
          'Pixel-accurate Flutter apps for iOS, Android, and Web built from '
          'Figma specs at 60fps.',
      iconKind: EngineeringIconKind.architecture,
      badges: [
        TechBrandChipItem(label: 'Flutter', brand: TechBrand.flutter),
        TechBrandChipItem(label: 'Dart 3', brand: TechBrand.dart),
        TechBrandChipItem(label: 'iOS', brand: TechBrand.appleIos),
        TechBrandChipItem(label: 'Android', brand: TechBrand.android),
        TechBrandChipItem(label: 'Figma', brand: TechBrand.figma),
      ],
    ),
    EngineeringPillar(
      id: 'firebase-cloud',
      title: 'Firebase & Cloud Backends',
      description:
          'Production auth, real-time Firestore streams, Cloud Functions, and '
          'FCM / APNs push delivery.',
      iconKind: EngineeringIconKind.security,
      badges: [
        TechBrandChipItem(label: 'Firebase', brand: TechBrand.firebase),
        TechBrandChipItem(label: 'Firestore', brand: TechBrand.firebase),
        TechBrandChipItem(label: 'Cloud Functions'),
        TechBrandChipItem(label: 'FCM / APNs'),
      ],
    ),
    EngineeringPillar(
      id: 'ai-edge',
      title: 'AI & Serverless Edge APIs',
      description:
          'Cloudflare Worker proxies keeping LLM API keys off client bundles '
          'with CORS and rate limits.',
      iconKind: EngineeringIconKind.geospatial,
      badges: [
        TechBrandChipItem(label: 'Gemini AI', brand: TechBrand.gemini),
        TechBrandChipItem(label: 'Cloudflare', brand: TechBrand.cloudflare),
        TechBrandChipItem(label: 'REST APIs'),
      ],
    ),
    EngineeringPillar(
      id: 'maps-qa',
      title: 'Maps, State & Automated QA',
      description:
          'Clustered OpenStreetMap viewports, local persistence fallbacks, '
          'CI/CD, and automated tests.',
      iconKind: EngineeringIconKind.verification,
      badges: [
        TechBrandChipItem(
          label: 'OpenStreetMap',
          brand: TechBrand.openStreetMap,
        ),
        TechBrandChipItem(
          label: 'GitHub Actions',
          brand: TechBrand.githubActions,
        ),
        TechBrandChipItem(label: '177 Tests'),
      ],
    ),
  ];

  static const ProjectShowcase nutriLens = ProjectShowcase(
    id: PortfolioSectionId.nutrilens,
    title: 'NutriLens AI',
    subtitle: 'Pantry-First Meal & Macro Tracker',
    problemStatement:
        'Calorie trackers fail on home-cooked meals—forcing manual weighing '
        'instead of using the actual ingredients in your kitchen.',
    scopeSummary: 'Solo End-to-End · 153 Tests',
    quickDemoHint:
        'Try in 10s: Open Live Demo → Camera → tap "Sample" to run AI Vision',
    engineeringHighlights: [
      EngineeringHighlight(
        title: '3-Mode Pantry Scanning:',
        detail:
            'Register ingredients via barcode (Open Food Facts v2 + Gemini '
            'fallback), package photo, or nutrition label OCR.',
      ),
      EngineeringHighlight(
        title: 'Home-Cooked Match & AI Health Score:',
        detail:
            'Gemini Vision matches plated dishes to your pantry and scores '
            '0–100 macro balance with written rationale.',
      ),
      EngineeringHighlight(
        title: 'Edge Security Proxy:',
        detail:
            'Cloudflare Worker keeps Gemini keys off clients with Origin CORS, '
            'model allowlists, 16 MB caps, and 30 req/min rate limits.',
      ),
    ],
    techStack: [
      'Dart & Flutter',
      'Clean Architecture',
      'MVVM + Provider',
      'Gemini Vision',
      'Cloudflare Workers',
    ],
    testCount: 153,
    testLabel: '153 Unit & Widget Tests',
    liveDemoUrl: 'https://tobishakur.github.io/nutrilens-ai-tracker/',
    repoUrl: 'https://github.com/TobiShakur/nutrilens-ai-tracker',
    logoAsset: 'assets/icons/nutrilens_icon.webp',
    leftScreenshotAsset: 'assets/images/nutrilens_dashboard.webp',
    rightPreviewImages: [
      'assets/images/nutrilens_scan.webp',
      'assets/images/nutrilens_analysis.webp',
      'assets/images/nutrilens_pantry.webp',
    ],
    previewMode: ProjectPreviewMode.assetImages,
    videoAsset: 'assets/videos/nutrilens_demo.mp4',
    accentColor: AppColors.accentNutriLens,
    deepAccentColor: AppColors.accentNutriLensDeep,
  );

  static const ProjectShowcase setPoint = ProjectShowcase(
    id: PortfolioSectionId.setpoint,
    title: 'SetPoint',
    subtitle: 'Mobile Tennis Matchmaking Platform',
    problemStatement:
        'Group chats break down for tennis—mismatched skill levels, unclear '
        'court surfaces, and manual headcounts waste hours.',
    scopeSummary: 'Solo End-to-End · 24 Tests',
    quickDemoHint:
        'Try in 10s: Open Live Demo → switch List / Map & filter by surface or radius',
    engineeringHighlights: [
      EngineeringHighlight(
        title: 'Dual Feed & OpenStreetMap Clustering:',
        detail:
            'Switch between match feed and interactive OpenStreetMap pins with '
            '5–20 km radius filtering.',
      ),
      EngineeringHighlight(
        title: 'Live Filtering & Court Tactics:',
        detail:
            'Filter matches by format (Singles / Doubles), court surface, and '
            '5-tier skill with 1v1 / 2v2 court views.',
      ),
      EngineeringHighlight(
        title: 'UGC Moderation & Offline BLoC:',
        detail:
            'Participant chat with App Store report/block moderation, Clean '
            'Architecture + BLoC 8.1, and sealed errors.',
      ),
    ],
    techStack: [
      'Dart 3 & Flutter',
      'Clean Architecture',
      'BLoC 8.1',
      'OpenStreetMap',
    ],
    testCount: 24,
    testLabel: '24 Unit & BLoC Tests',
    liveDemoUrl: 'https://tobishakur.github.io/flutter-tennis-matchmaking/',
    repoUrl: 'https://github.com/TobiShakur/flutter-tennis-matchmaking',
    logoAsset: 'assets/icons/setpoint_icon.webp',
    leftScreenshotAsset: 'assets/images/setpoint_map.webp',
    rightPreviewImages: [
      'assets/images/setpoint_feed.webp',
      'assets/images/setpoint_filters.webp',
      'assets/images/setpoint_match_doubles.webp',
    ],
    previewMode: ProjectPreviewMode.assetImages,
    videoAsset: 'assets/videos/setpoint_demo.mp4',
    accentColor: AppColors.accentSetPoint,
    deepAccentColor: AppColors.accentSetPointDeep,
  );

  static const List<ProjectShowcase> projects = [nutriLens, setPoint];
}

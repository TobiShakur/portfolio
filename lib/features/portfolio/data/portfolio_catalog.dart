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
        'I help startups and product teams ship iOS, Android, and Web '
        'apps—complete with Firebase backends, secure AI pipelines, and '
        'automated test coverage.',
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
      TechBrandChipItem(label: 'Dart', brand: TechBrand.dart),
      TechBrandChipItem(label: 'Firebase', brand: TechBrand.firebase),
      TechBrandChipItem(label: 'Cloudflare', brand: TechBrand.cloudflare),
      TechBrandChipItem(label: 'Gemini AI', brand: TechBrand.gemini),
      TechBrandChipItem(label: 'iOS', brand: TechBrand.appleIos),
      TechBrandChipItem(label: 'Android', brand: TechBrand.android),
    ],
    snapshotHighlights: [
      SnapshotHighlight(
        label: 'End-to-End Delivery',
        value:
            'iOS, Android & Flutter Web — from Figma specs to App Store & Play Store releases.',
      ),
      SnapshotHighlight(
        label: 'Backend & AI Included',
        value:
            'No separate backend hire needed for MVPs: Firebase (Auth, Firestore, Functions, Push) & Cloudflare AI proxies.',
      ),
      SnapshotHighlight(
        label: 'Verified Quality',
        value:
            'Clean Architecture (BLoC / Provider), weekly testable web builds & 177 automated tests.',
        tabular: true,
      ),
      SnapshotHighlight(
        label: 'Availability & Overlap',
        value:
            'Freelance MVPs & Remote Roles · GMT-3 (Full US East & EU overlap) · EN / ES',
      ),
    ],
  );

  static const String engineeringSectionTitle = 'Capabilities & Cloud Stack';
  static const String engineeringSectionSubtitle =
      'End-to-end mobile delivery for startups and product teams—from Figma '
      'specs to cloud-backed App Store & Play Store releases.';

  static const List<EngineeringPillar> engineeringPillars = [
    EngineeringPillar(
      id: 'mobile-delivery',
      title: 'Figma-to-Production Mobile Apps',
      description:
          'Pixel-accurate iOS, Android, and Web apps built in Flutter with '
          'native bridges and responsive, 60fps UI.',
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
      title: 'Firebase Cloud & Real-Time Data',
      description:
          'Production authentication, real-time Firestore streams, Cloud '
          'Functions, Storage rules, and FCM / APNs push delivery.',
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
      title: 'Secure AI & Edge Proxies',
      description:
          'Serverless Cloudflare Worker proxies keeping LLM API keys off '
          'client bundles with CORS, allowlists, and rate limits.',
      iconKind: EngineeringIconKind.geospatial,
      badges: [
        TechBrandChipItem(label: 'Gemini AI', brand: TechBrand.gemini),
        TechBrandChipItem(label: 'Cloudflare', brand: TechBrand.cloudflare),
        TechBrandChipItem(label: 'REST APIs'),
      ],
    ),
    EngineeringPillar(
      id: 'maps-qa',
      title: 'Maps, Offline Resilience & QA',
      description:
          'Clustered OpenStreetMap viewports, local persistence fallbacks, '
          'CI/CD release pipelines, and automated test suites.',
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

  static const List<EngagementMode> engagementModes = [
    EngagementMode(
      title: '0→1 MVP Development',
      summary:
          'Full iOS, Android & Web app + Firebase/Cloud backend ready for launch.',
    ),
    EngagementMode(
      title: 'AI & Cloud Integrations',
      summary:
          'Secure LLM/Vision pipelines, real-time Firestore, maps & auth.',
    ),
    EngagementMode(
      title: 'Remote Product Engineering',
      summary:
          'Clean Architecture, feature delivery, performance & automated QA.',
    ),
  ];

  static const ProjectShowcase nutriLens = ProjectShowcase(
    id: PortfolioSectionId.nutrilens,
    title: 'NutriLens AI',
    subtitle: 'Pantry-First Meal & Macro Tracker',
    problemStatement:
        'Calorie trackers fail on home-cooked meals—forcing manual weighing '
        'or inaccurate generic averages instead of using the real brands in '
        'your kitchen.',
    scopeSummary:
        'Solo End-to-End · UI · MVVM + Provider · Cloudflare Proxy · 153 Tests',
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
        title: 'Home-Cooked Meal Matching:',
        detail:
            'Snap a prepared dish and Gemini Vision matches ingredients '
            'against your personal pantry for accurate macros.',
      ),
      EngineeringHighlight(
        title: 'On-Demand AI Health Score:',
        detail:
            'Scores 0–100 macro and micronutrient balance with written rationale '
            'and stale-edit recalculation.',
      ),
      EngineeringHighlight(
        title: 'Edge Security & Live Demo:',
        detail:
            'Cloudflare Worker proxy enforces Origin CORS, model allowlists, '
            '16 MB caps, and 30 req/min rate limits.',
      ),
    ],
    techStack: [
      'Dart & Flutter',
      'Clean Architecture',
      'MVVM + Provider',
      'Gemini Vision',
      'Open Food Facts v2',
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
        'Organizing tennis matches over group chats breaks down fast—mismatched '
        'skill levels, unclear court surfaces, and manual headcounts waste hours.',
    scopeSummary:
        'Solo End-to-End · UI · BLoC 8.1 · Map Clustering · 24 Tests',
    quickDemoHint:
        'Try in 10s: Open Live Demo → switch List / Map & filter by surface or radius',
    engineeringHighlights: [
      EngineeringHighlight(
        title: 'Dual Feed & Map Clustering:',
        detail:
            'Switch between match feed and interactive OpenStreetMap clustering '
            'with 5–20 km radius filtering.',
      ),
      EngineeringHighlight(
        title: 'Live Multi-Criteria Filtering:',
        detail:
            'Filter matches in real time by format (Singles / Doubles), court '
            'surface (Clay, Hard, Grass), and 5-tier skill.',
      ),
      EngineeringHighlight(
        title: 'Tactical Court & Match Chat:',
        detail:
            'Surface-themed 1v1 / 2v2 formations with participant chat and '
            'App Store-ready UGC moderation (report & block).',
      ),
      EngineeringHighlight(
        title: 'Offline-Resilient BLoC:',
        detail:
            'Clean Architecture + BLoC 8.1 with Dart 3 sealed domain errors and '
            'deterministic offline mock repositories.',
      ),
    ],
    techStack: [
      'Dart 3 & Flutter',
      'Clean Architecture',
      'BLoC 8.1',
      'OpenStreetMap + Clustering',
      'Dark Glassmorphism',
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

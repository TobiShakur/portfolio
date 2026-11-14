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
    roleTitle: 'Mobile Software Engineer',
    headlineLine1: 'Production mobile apps,',
    headlineLine2: 'architected end to end.',
    supportingPitch:
        'I build Flutter, iOS, and Android software backed by Firebase cloud '
        'backends, serverless AI proxies, and automated test suites.',
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
  );

  static const String engineeringSectionTitle = 'Capabilities & Cloud Stack';
  static const String engineeringSectionSubtitle =
      'What I ship for startups and product teams—from Figma prototypes to '
      'cloud-backed stores.';

  static const List<EngineeringPillar> engineeringPillars = [
    EngineeringPillar(
      id: 'mobile-delivery',
      title: 'End-to-End Mobile Apps',
      description:
          'Pixel-accurate Flutter apps for iOS and Android built from Figma '
          'specs with responsive, 60fps UI.',
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
          'Production auth, real-time Firestore streams, Cloud Functions, '
          'Storage rules, and FCM / APNs push delivery.',
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
      title: 'Secure AI & Edge APIs',
      description:
          'Serverless Cloudflare Worker proxies keeping LLM keys off client '
          'bundles with CORS, allowlists, and rate limits.',
      iconKind: EngineeringIconKind.geospatial,
      badges: [
        TechBrandChipItem(label: 'Gemini AI', brand: TechBrand.gemini),
        TechBrandChipItem(label: 'Cloudflare', brand: TechBrand.cloudflare),
        TechBrandChipItem(label: 'REST APIs'),
      ],
    ),
    EngineeringPillar(
      id: 'maps-qa',
      title: 'Offline-First, Maps & QA',
      description:
          'Clustered OpenStreetMap viewports, local persistence fallbacks, '
          'automated tests, and CI/CD store delivery.',
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

  static const List<TechBrandChipItem> coreEcosystem = [
    TechBrandChipItem(label: 'Flutter', brand: TechBrand.flutter),
    TechBrandChipItem(label: 'Dart', brand: TechBrand.dart),
    TechBrandChipItem(label: 'Firebase', brand: TechBrand.firebase),
    TechBrandChipItem(label: 'Cloudflare', brand: TechBrand.cloudflare),
    TechBrandChipItem(label: 'Gemini AI', brand: TechBrand.gemini),
    TechBrandChipItem(label: 'iOS', brand: TechBrand.appleIos),
    TechBrandChipItem(label: 'Android', brand: TechBrand.android),
    TechBrandChipItem(label: 'Figma', brand: TechBrand.figma),
    TechBrandChipItem(label: 'OpenStreetMap', brand: TechBrand.openStreetMap),
    TechBrandChipItem(
      label: 'GitHub Actions',
      brand: TechBrand.githubActions,
    ),
  ];

  static const ProjectShowcase nutriLens = ProjectShowcase(
    id: PortfolioSectionId.nutrilens,
    title: 'NutriLens AI',
    subtitle: 'Pantry-First Meal & Macro Tracker',
    problemStatement:
        'Most calorie trackers fail on home-cooked meals—forcing tedious '
        'manual weighing or falling back to generic database averages that '
        'ignore the actual brands in your kitchen.',
    engineeringHighlights: [
      EngineeringHighlight(
        title: '3-Mode Pantry Scanning:',
        detail:
            'Register ingredients once via barcode (Open Food Facts API v2 '
            'with Gemini fallback), package front photo, or nutrition label '
            'OCR, with brand-conflict resolution.',
      ),
      EngineeringHighlight(
        title: 'Home-Cooked Meal Matching:',
        detail:
            'Snap a prepared dish and Gemini Vision cross-references detected '
            'ingredients against your personal pantry for accurate macros.',
      ),
      EngineeringHighlight(
        title: 'On-Demand AI Health Score (0–100):',
        detail:
            'Evaluates macro balance and micronutrient density with written '
            'rationale (?/100 on manual meals) and stale-edit recalculation.',
      ),
      EngineeringHighlight(
        title: 'Instant Web Demo & Serverless Proxy:',
        detail:
            'Includes built-in Sample meal testing, live EN / ES switching, '
            'and a Cloudflare Worker proxy (Origin CORS, model allowlist, '
            '16 MB cap, 30 req/min IP limit).',
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
    leftScreenshotAsset: 'assets/images/nutrilens_sample_meal.webp',
    rightPreviewImages: ['assets/images/nutrilens_sample_meal.webp'],
    previewMode: ProjectPreviewMode.nutriLensInteractiveScreens,
    videoAsset: 'assets/videos/nutrilens_demo.mp4',
    accentColor: AppColors.accentNutriLens,
    deepAccentColor: AppColors.accentNutriLensDeep,
  );

  static const ProjectShowcase setPoint = ProjectShowcase(
    id: PortfolioSectionId.setpoint,
    title: 'SetPoint',
    subtitle: 'Mobile Tennis Matchmaking Platform',
    problemStatement:
        'Organizing tennis matches over group chats breaks down '
        'quickly—mismatched skill levels, unclear court surfaces, and manual '
        'headcounts waste hours every week.',
    engineeringHighlights: [
      EngineeringHighlight(
        title: 'Dual Feed & Map Clustering:',
        detail:
            'Switch directly between a match feed and an interactive '
            'OpenStreetMap viewport with proximity clustering and 5–20 km '
            'radius filtering.',
      ),
      EngineeringHighlight(
        title: 'Real-Time Multi-Criteria Filtering:',
        detail:
            'Filter live by game mode (Singles / Doubles), court surface '
            '(Clay, Hard, Grass), and 5-tier player skill level.',
      ),
      EngineeringHighlight(
        title: 'Tactical Court & Match Chat:',
        detail:
            'Dynamic surface-themed 1v1 / 2v2 court formations plus '
            'participant-only chat with App Store-compliant UGC moderation '
            '(report & block).',
      ),
      EngineeringHighlight(
        title: 'Offline-Resilient BLoC Architecture:',
        detail:
            'Strict Clean Architecture + BLoC 8.1 with Dart 3 sealed domain '
            'errors and deterministic offline mock repositories.',
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
    leftScreenshotAsset: 'assets/images/setpoint_map_zoom.webp',
    rightPreviewImages: [
      'assets/images/setpoint_feed.webp',
      'assets/images/setpoint_map_zoom.webp',
      'assets/images/setpoint_match_doubles.webp',
      'assets/images/setpoint_filters.webp',
    ],
    previewMode: ProjectPreviewMode.assetImages,
    videoAsset: 'assets/videos/setpoint_demo.mp4',
    accentColor: AppColors.accentSetPoint,
    deepAccentColor: AppColors.accentSetPointDeep,
  );

  static const List<ProjectShowcase> projects = [nutriLens, setPoint];
}

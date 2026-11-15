import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/features/portfolio/domain/entities/capability_row.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_concept_id.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_section_id.dart';
import 'package:portfolio/features/portfolio/domain/entities/profile_data.dart';
import 'package:portfolio/features/portfolio/domain/entities/project_showcase.dart';
import 'package:portfolio/features/portfolio/domain/entities/tech_brand.dart';

/// Immutable verified catalog powering all 3 portfolio design concepts.
abstract final class PortfolioCatalog {
  static const String capabilitiesSectionTitle = 'Capabilities & Stack';
  static const String capabilitiesSectionSubtitle =
      'Full product ownership from architecture to store release—no separate backend hire required.';

  static const String closingHeading =
      'Need a mobile engineer who owns the whole stack?';
  static const String closingSubcopy =
      'Available for Upwork MVPs, Figma-to-Flutter builds, and remote product teams (GMT-3 · EN/ES).';

  static const ProfileData profile = ProfileData(
    fullName: 'Tobías Gutiérrez',
    roleTitle: 'Mobile Software Engineer',
    identityLine: 'Tobías Gutiérrez — Mobile Software Engineer · GMT-3',
    headlineLine1: 'Production Flutter apps,',
    headlineLine2: 'with backend & AI built in.',
    supportingPitch:
        'I build iOS, Android, and Web products solo—combining 60fps Flutter UI, Firebase backends, serverless AI proxies, and automated test suites.',
    githubUrl: 'https://github.com/TobiShakur',
    linkedInUrl: 'https://linkedin.com/in/tobias-gutierrez',
    email: 'tobigutierrez26@gmail.com',
    verificationMetrics: [
      'App Store Shipped (5.0★)',
      '177 Automated Tests',
      'US East & EU Overlap',
    ],
    coreStackLogos: [
      TechBrandChipItem(label: 'Flutter', brand: TechBrand.flutter),
      TechBrandChipItem(label: 'Dart 3', brand: TechBrand.dart),
      TechBrandChipItem(label: 'Firebase', brand: TechBrand.firebase),
      TechBrandChipItem(label: 'Cloudflare', brand: TechBrand.cloudflare),
      TechBrandChipItem(label: 'Gemini AI', brand: TechBrand.gemini),
      TechBrandChipItem(label: 'iOS', brand: TechBrand.appleIos),
      TechBrandChipItem(label: 'Android', brand: TechBrand.android),
      TechBrandChipItem(label: 'GitHub Actions', brand: TechBrand.githubActions),
    ],
    snapshotHighlights: [
      SnapshotHighlight(
        label: 'PLATFORMS',
        value: 'iOS · Android · Web',
      ),
      SnapshotHighlight(
        label: 'CLOUD',
        value: 'Firebase · Workers',
      ),
      SnapshotHighlight(
        label: 'QA',
        value: '177 Tests',
      ),
      SnapshotHighlight(
        label: 'OVERLAP',
        value: 'GMT-3 · EN / ES',
      ),
    ],
  );

  /// Returns concept-tailored Hero H1 line pair per DESIGN_CONCEPTS.md §5.
  static (String, String) heroHeadlineFor(PortfolioConceptId concept) {
    return switch (concept) {
      PortfolioConceptId.editorialWall => (
          'Production Flutter apps,',
          'with backend & AI built in.',
        ),
      PortfolioConceptId.swissGrid => (
          'Flutter systems',
          'shipped end to end.',
        ),
      PortfolioConceptId.kineticStage => (
          'Flutter & cloud apps,',
          'shipped to real users.',
        ),
    };
  }

  /// Verified commercial production proof (MatchUp on Apple App Store 5.0★).
  static const ClientAppProof matchUpProof = ClientAppProof(
    badgeLabel: 'CLIENT PRODUCTION DELIVERY · APPLE APP STORE (5.0★)',
    title: 'MatchUp — Cross-Platform Social Sports App (iOS & Android)',
    summary:
        'Built solo from Figma specs: Google & Phone OTP Auth, real-time Firestore chat, Google Maps custom markers, FCM & APNs push notifications, Cloud Functions, deep linking, and AdMob monetization.',
    platformsLine: 'Platforms: iOS (App Store 5.0★) · Android',
    stackLine: 'Stack: Flutter · Provider · Firebase · Google Maps · AdMob',
    shortName: 'MatchUp',
    ratingLabel: '5.0★',
    storeLabel: 'Apple App Store',
    highlights: [
      'Figma-to-Flutter UI + custom animations',
      'Google & Phone OTP Auth + Firestore RT Chat',
      'Google Maps custom markers + FCM / APNs push',
    ],
  );

  /// Consolidated 4 indexed rows replacing repetitive How I Help + Core Stack cards.
  static const List<CapabilityRowItem> capabilityRows = [
    CapabilityRowItem(
      indexLabel: '01',
      title: 'Cross-Platform UI & Native',
      description:
          'Pixel-accurate Flutter apps for iOS, Android, and Web built from Figma specs at 60fps.',
      techSpecs: 'Flutter · Dart 3 · Swift/Kotlin · Figma',
    ),
    CapabilityRowItem(
      indexLabel: '02',
      title: 'Firebase & Cloud Backends',
      description:
          'Production auth, real-time Firestore streams, Cloud Functions, Storage rules, and FCM / APNs push delivery.',
      techSpecs: 'Firebase · Firestore · Functions · FCM/APNs',
    ),
    CapabilityRowItem(
      indexLabel: '03',
      title: 'AI & Serverless Edge APIs',
      description:
          'Cloudflare Worker proxies keeping LLM API keys off client bundles with Origin CORS, allowlists, and rate limits.',
      techSpecs: 'Gemini Vision · Cloudflare Workers · REST',
    ),
    CapabilityRowItem(
      indexLabel: '04',
      title: 'Architecture, QA & Overlap',
      description:
          'Clean Architecture (BLoC / Riverpod / MVVM), CI/CD pipelines, 177 automated tests, and direct GMT-3 overlap (EN/ES).',
      techSpecs: 'BLoC / Riverpod · GitHub Actions · 177 Tests',
    ),
  ];

  static const ProjectShowcase nutriLens = ProjectShowcase(
    id: PortfolioSectionId.nutrilens,
    projectIndexLabel: '01',
    categoryTag: 'MOBILE VISION & SERVERLESS EDGE',
    architectureTag: 'MVVM + PROVIDER',
    title: 'NutriLens AI',
    subtitle: 'Pantry-First Meal & Macro Tracker',
    problemStatement:
        'Calorie trackers fail on home-cooked meals—forcing manual weighing instead of matching the actual brands in your kitchen.',
    scopeSummary: 'Solo End-to-End · MVVM + Provider · 153 Automated Tests',
    quickDemoHint: 'Launch Live Demo ↗',
    engineeringHighlights: [
      EngineeringHighlight(
        title: '3-Mode Pantry Scanning',
        detail:
            'Barcode lookup (Open Food Facts v2 + Gemini), package photo recognition, and nutrition-label OCR.',
      ),
      EngineeringHighlight(
        title: 'Pantry-Matched Vision & Score',
        detail:
            'Gemini Vision cross-references your saved pantry brands and scores every meal 0–100 with transparent feedback.',
      ),
      EngineeringHighlight(
        title: 'Zero-Key Edge Proxy',
        detail:
            'Cloudflare Worker backend with strict Origin CORS, host allowlists, 16 MB caps, and 30 req/min rate limits.',
      ),
    ],
    techStack: [
      'Flutter',
      'Dart 3',
      'Cloudflare Worker',
      'Gemini 2.5',
      'Open Food Facts',
      'Provider',
    ],
    testCount: 153,
    testLabel: '153 Automated Tests',
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
    accentColor: AppColors.accentNutriLens,
    deepAccentColor: AppColors.accentNutriLensDeep,
  );

  static const ProjectShowcase setPoint = ProjectShowcase(
    id: PortfolioSectionId.setpoint,
    projectIndexLabel: '02',
    categoryTag: 'REALTIME GEOLOCATION & CLEAN ARCH',
    architectureTag: 'CLEAN ARCH + BLoC',
    title: 'SetPoint',
    subtitle: 'Amateur Racket-Sports Matchmaking App',
    problemStatement:
        'Organizing local matches breaks down across chaotic group chats without real skill balancing, radius discovery, or open slot tracking.',
    scopeSummary: 'Solo End-to-End · Clean Architecture + BLoC · 24 Automated Tests',
    quickDemoHint: 'Launch Live Demo ↗',
    engineeringHighlights: [
      EngineeringHighlight(
        title: 'Clean Architecture + BLoC',
        detail:
            'Domain use cases and reactive BLoC state decoupled behind explicit typed Failure boundaries.',
      ),
      EngineeringHighlight(
        title: 'Geospatial Match Radar',
        detail:
            'Haversine court distance filtering across Tennis and Padel with live surface, category, and radius queries.',
      ),
      EngineeringHighlight(
        title: 'Real-Time Slot Integrity',
        detail:
            'Double-booking prevention and synchronized roster counts via hydrated local state streams.',
      ),
    ],
    techStack: [
      'Flutter',
      'Dart 3',
      'BLoC',
      'Clean Architecture',
      'Geospatial',
      'Web',
    ],
    testCount: 24,
    testLabel: '24 Automated Tests',
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
    accentColor: AppColors.accentSetPoint,
    deepAccentColor: AppColors.accentSetPointDeep,
  );

  static const List<ProjectShowcase> projects = [nutriLens, setPoint];

  /// All 8 bundled mobile screenshots curated for kinetic screen walls.
  static const List<String> allGalleryScreenshots = [
    'assets/images/nutrilens_dashboard.webp',
    'assets/images/setpoint_map.webp',
    'assets/images/nutrilens_scan.webp',
    'assets/images/setpoint_feed.webp',
    'assets/images/nutrilens_analysis.webp',
    'assets/images/setpoint_filters.webp',
    'assets/images/nutrilens_pantry.webp',
    'assets/images/setpoint_match_doubles.webp',
  ];
}

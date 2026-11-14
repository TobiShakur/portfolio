import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/features/portfolio/data/portfolio_catalog.dart';

void main() {
  group('PortfolioCatalog integrity', () {
    final allText = <String>[
      PortfolioCatalog.profile.fullName,
      PortfolioCatalog.profile.roleTitle,
      PortfolioCatalog.profile.headlineLine1,
      PortfolioCatalog.profile.headlineLine2,
      PortfolioCatalog.profile.supportingPitch,
      ...PortfolioCatalog.profile.verificationMetrics,
      for (final item in PortfolioCatalog.profile.coreStackLogos) item.label,
      PortfolioCatalog.engineeringSectionTitle,
      PortfolioCatalog.engineeringSectionSubtitle,
      for (final item in PortfolioCatalog.coreEcosystem) item.label,
      for (final pillar in PortfolioCatalog.engineeringPillars) ...[
        pillar.title,
        pillar.description,
        for (final badge in pillar.badges) badge.label,
      ],
      for (final project in PortfolioCatalog.projects) ...[
        project.title,
        project.subtitle,
        project.problemStatement,
        project.testLabel,
        ...project.techStack,
        for (final h in project.engineeringHighlights) ...[
          h.title,
          h.detail,
        ],
      ],
    ].join('\n').toLowerCase();

    test('contains zero forbidden profile or AI-slop terms', () {
      const forbidden = [
        'fiuba',
        'student',
        'universidad',
        'university',
        'unlock',
        'supercharge',
        'seamless',
        'elevate',
        'effortless',
        'cutting-edge',
        'passionate developer',
      ];

      for (final term in forbidden) {
        expect(
          allText.contains(term),
          isFalse,
          reason: 'Catalog must not contain forbidden term "$term"',
        );
      }
    });

    test('matches official URLs and verified test counts', () {
      expect(
        PortfolioCatalog.profile.githubUrl,
        'https://github.com/TobiShakur',
      );
      expect(
        PortfolioCatalog.profile.linkedInUrl,
        'https://linkedin.com/in/tobias-gutierrez',
      );
      expect(PortfolioCatalog.profile.email, 'tobigutierrez26@gmail.com');

      expect(PortfolioCatalog.nutriLens.testCount, 153);
      expect(
        PortfolioCatalog.nutriLens.liveDemoUrl,
        'https://tobishakur.github.io/nutrilens-ai-tracker/',
      );
      expect(
        PortfolioCatalog.nutriLens.repoUrl,
        'https://github.com/TobiShakur/nutrilens-ai-tracker',
      );

      expect(PortfolioCatalog.setPoint.testCount, 24);
      expect(
        PortfolioCatalog.setPoint.liveDemoUrl,
        'https://tobishakur.github.io/flutter-tennis-matchmaking/',
      );
      expect(
        PortfolioCatalog.setPoint.repoUrl,
        'https://github.com/TobiShakur/flutter-tennis-matchmaking',
      );
    });
  });
}

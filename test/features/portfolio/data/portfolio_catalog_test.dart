import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/features/portfolio/data/portfolio_catalog.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_concept_id.dart';

void main() {
  group('PortfolioCatalog integrity', () {
    final allText = <String>[
      PortfolioCatalog.profile.fullName,
      PortfolioCatalog.profile.roleTitle,
      PortfolioCatalog.profile.identityLine,
      PortfolioCatalog.profile.headlineLine1,
      PortfolioCatalog.profile.headlineLine2,
      PortfolioCatalog.profile.supportingPitch,
      for (final concept in PortfolioConceptId.values) ...[
        PortfolioCatalog.heroHeadlineFor(concept).$1,
        PortfolioCatalog.heroHeadlineFor(concept).$2,
      ],
      ...PortfolioCatalog.profile.verificationMetrics,
      for (final item in PortfolioCatalog.profile.coreStackLogos) item.label,
      for (final row in PortfolioCatalog.profile.snapshotHighlights) ...[
        row.label,
        row.value,
      ],
      PortfolioCatalog.capabilitiesSectionTitle,
      PortfolioCatalog.capabilitiesSectionSubtitle,
      PortfolioCatalog.closingHeading,
      PortfolioCatalog.closingSubcopy,
      PortfolioCatalog.matchUpProof.badgeLabel,
      PortfolioCatalog.matchUpProof.title,
      PortfolioCatalog.matchUpProof.summary,
      PortfolioCatalog.matchUpProof.platformsLine,
      PortfolioCatalog.matchUpProof.stackLine,
      ...PortfolioCatalog.matchUpProof.highlights,
      for (final row in PortfolioCatalog.capabilityRows) ...[
        row.indexLabel,
        row.title,
        row.description,
        row.techSpecs,
      ],
      for (final project in PortfolioCatalog.projects) ...[
        project.title,
        project.subtitle,
        project.problemStatement,
        project.scopeSummary,
        project.quickDemoHint,
        project.categoryTag,
        project.architectureTag,
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

    test('matches official URLs and verified test & App Store metrics', () {
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

      expect(PortfolioCatalog.matchUpProof.ratingLabel, '5.0★');
      expect(PortfolioCatalog.matchUpProof.storeLabel, 'Apple App Store');
      expect(PortfolioCatalog.capabilityRows.length, 4);
    });

    test('keeps right preview carousel distinct from left static screen', () {
      for (final project in PortfolioCatalog.projects) {
        expect(project.rightPreviewImages, isNotEmpty);
        expect(
          project.rightPreviewImages.contains(project.leftScreenshotAsset),
          isFalse,
          reason:
              '${project.title} right carousel must not repeat leftScreenshotAsset',
        );
        expect(project.allScreenAssets.length, 4);
      }
    });
  });
}

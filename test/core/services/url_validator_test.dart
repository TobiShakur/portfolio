import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/services/url_validator.dart';

void main() {
  group('UrlValidator.parseAllowedUri', () {
    test('accepts official HTTPS URLs and official mailto address', () {
      expect(
        UrlValidator.parseAllowedUri('https://github.com/TobiShakur'),
        Uri.parse('https://github.com/TobiShakur'),
      );
      expect(
        UrlValidator.parseAllowedUri(
          'https://linkedin.com/in/tobias-gutierrez',
        ),
        Uri.parse('https://linkedin.com/in/tobias-gutierrez'),
      );
      expect(
        UrlValidator.parseAllowedUri(
          'https://tobishakur.github.io/nutrilens-ai-tracker/',
        ),
        Uri.parse('https://tobishakur.github.io/nutrilens-ai-tracker/'),
      );
      expect(
        UrlValidator.parseAllowedUri(
          'https://tobishakur.github.io/flutter-tennis-matchmaking/',
        ),
        Uri.parse('https://tobishakur.github.io/flutter-tennis-matchmaking/'),
      );
      expect(
        UrlValidator.parseAllowedUri('mailto:tobigutierrez26@gmail.com'),
        Uri.parse('mailto:tobigutierrez26@gmail.com'),
      );
    });

    test('rejects insecure schemes, untrusted hosts, and malformed input', () {
      const rejectedInputs = [
        '',
        '   ',
        'http://github.com/TobiShakur',
        'javascript:alert(1)',
        'data:text/html,<script>alert(1)</script>',
        'file:///etc/passwd',
        'https://evil.com/phish',
        'https://user:pass@github.com/TobiShakur',
        'mailto:other@example.com',
        'mailto://github.com',
        'not a url',
      ];

      for (final raw in rejectedInputs) {
        expect(
          UrlValidator.parseAllowedUri(raw),
          isNull,
          reason: 'Expected "$raw" to be rejected',
        );
      }
    });
  });
}

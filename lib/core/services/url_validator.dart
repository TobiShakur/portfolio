/// Pure Dart URL allowlist validator enforcing strict scheme and host rules.
abstract final class UrlValidator {
  static const Set<String> allowedHttpsHosts = {
    'github.com',
    'linkedin.com',
    'tobishakur.github.io',
  };

  static const String allowedMailtoEmail = 'tobigutierrez26@gmail.com';

  /// Parses [rawUrl] and returns a validated [Uri] if it matches the strict
  /// HTTPS host allowlist or the official `mailto:` address; otherwise `null`.
  static Uri? parseAllowedUri(String rawUrl) {
    final trimmed = rawUrl.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(trimmed);
    if (uri == null) {
      return null;
    }

    final scheme = uri.scheme.toLowerCase();
    if (scheme == 'https') {
      if (!uri.hasAuthority ||
          uri.host.isEmpty ||
          uri.userInfo.isNotEmpty ||
          !allowedHttpsHosts.contains(uri.host.toLowerCase())) {
        return null;
      }
      return uri;
    }

    if (scheme == 'mailto') {
      if (uri.hasAuthority ||
          uri.hasQuery ||
          uri.hasFragment ||
          uri.path.toLowerCase() != allowedMailtoEmail) {
        return null;
      }
      return uri;
    }

    return null;
  }
}

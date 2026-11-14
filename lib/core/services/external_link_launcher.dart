import 'package:flutter/foundation.dart';
import 'package:portfolio/core/services/url_validator.dart';
import 'package:url_launcher/url_launcher.dart';

/// Outcome of attempting to open an external URL.
@immutable
sealed class LinkLaunchResult {
  const LinkLaunchResult();
}

final class LinkLaunchSuccess extends LinkLaunchResult {
  const LinkLaunchSuccess();
}

final class LinkLaunchRejected extends LinkLaunchResult {
  const LinkLaunchRejected();
}

final class LinkLaunchFailure extends LinkLaunchResult {
  const LinkLaunchFailure();
}

/// Abstract service for safely opening external links.
abstract interface class ExternalLinkLauncher {
  Future<LinkLaunchResult> openExternal(String url);
}

/// Production implementation backed by `url_launcher` with strict allowlist checks.
final class UrlLauncherExternalLinkLauncher implements ExternalLinkLauncher {
  const UrlLauncherExternalLinkLauncher();

  @override
  Future<LinkLaunchResult> openExternal(String rawUrl) async {
    final uri = UrlValidator.parseAllowedUri(rawUrl);
    if (uri == null) {
      return const LinkLaunchRejected();
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
      return launched ? const LinkLaunchSuccess() : const LinkLaunchFailure();
    } catch (_) {
      return const LinkLaunchFailure();
    }
  }
}

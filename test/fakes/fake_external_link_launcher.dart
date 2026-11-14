import 'package:portfolio/core/services/external_link_launcher.dart';

final class FakeExternalLinkLauncher implements ExternalLinkLauncher {
  FakeExternalLinkLauncher({
    this.nextResult = const LinkLaunchSuccess(),
  });

  final List<String> openedUrls = <String>[];
  LinkLaunchResult nextResult;

  @override
  Future<LinkLaunchResult> openExternal(String url) async {
    openedUrls.add(url);
    return nextResult;
  }
}

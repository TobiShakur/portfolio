import 'package:portfolio/core/services/clipboard_service.dart';

final class FakeClipboardService implements ClipboardService {
  FakeClipboardService({
    this.nextResult = const ClipboardSuccess(),
  });

  final List<String> copiedTexts = <String>[];
  ClipboardResult nextResult;

  @override
  Future<ClipboardResult> copyText(String text) async {
    copiedTexts.add(text);
    return nextResult;
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Outcome of writing text to the system clipboard.
@immutable
sealed class ClipboardResult {
  const ClipboardResult();
}

final class ClipboardSuccess extends ClipboardResult {
  const ClipboardSuccess();
}

final class ClipboardFailure extends ClipboardResult {
  const ClipboardFailure();
}

/// Abstract service for copying text to the clipboard.
abstract interface class ClipboardService {
  Future<ClipboardResult> copyText(String text);
}

/// Production implementation backed by Flutter's [Clipboard].
final class FlutterClipboardService implements ClipboardService {
  const FlutterClipboardService();

  @override
  Future<ClipboardResult> copyText(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      return const ClipboardSuccess();
    } catch (_) {
      return const ClipboardFailure();
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Whether [details] reports a layout overflow (e.g. RenderFlex).
///
/// Flutter often marks these as `silent`, so they print in debug but do not
/// fail `flutter test` unless the suite asserts them explicitly.
bool isLayoutOverflowError(FlutterErrorDetails details) {
  final exceptionText = details.exceptionAsString();
  final fullText = details.toString();
  return exceptionText.contains('A RenderFlex overflowed') ||
      exceptionText.contains('overflowed by') ||
      fullText.contains('A RenderFlex overflowed') ||
      fullText.contains('overflowed by');
}

/// Runs [action] and fails if any layout overflow was reported meanwhile.
///
/// Prefer this after pumping pages, sheets, dialogs, and shared cards under a
/// compact [TestFlutterView.physicalSize] with long copy.
Future<void> expectNoLayoutOverflow(Future<void> Function() action) async {
  final overflows = <FlutterErrorDetails>[];
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    if (isLayoutOverflowError(details)) {
      overflows.add(details);
    }
    previous?.call(details);
  };
  try {
    await action();
  } finally {
    FlutterError.onError = previous;
  }
  expect(
    overflows,
    isEmpty,
    reason: overflows.isEmpty
        ? null
        : 'Layout overflow(s):\n'
              '${overflows.map((e) => e.exceptionAsString()).join('\n')}',
  );
}

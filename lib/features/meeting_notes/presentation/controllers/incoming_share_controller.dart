import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/platform/share_intent.dart';

part 'incoming_share_controller.g.dart';

/// Holds one pending Android share until the user saves or discards it.
///
/// Sharing never extracts or syncs; [CaptureController] persists locally.
@Riverpod(keepAlive: true)
class IncomingShareController extends _$IncomingShareController {
  @override
  IncomingSharePayload? build() => null;

  /// Returns true when [payload] should be shown (new id, non-empty text).
  bool offer(IncomingSharePayload payload) {
    final text = sanitizeSharedPlainText(payload.text);
    if (text == null) return false;
    if (state?.id == payload.id) return false;
    state = IncomingSharePayload(
      id: payload.id,
      text: text,
      kind: payload.kind,
    );
    return true;
  }

  void discard() {
    state = null;
  }
}

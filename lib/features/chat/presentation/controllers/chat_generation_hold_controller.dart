import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_generation_hold_controller.g.dart';

/// True while Chat holds the shared Android dataSync foreground service.
///
/// Extraction resume must not cancel that shade while a reply is still
/// generating. Kept in its own provider so Review can read it without
/// importing [ChatSessionController].
@Riverpod(keepAlive: true)
class ChatGenerationHoldController extends _$ChatGenerationHoldController {
  @override
  bool build() => false;

  void setActive(bool active) {
    if (state == active) return;
    state = active;
  }
}

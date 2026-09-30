import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/source_conversation_providers.dart';
import '../../domain/entities/source_conversation.dart';

part 'capture_controller.g.dart';

@riverpod
class CaptureController extends _$CaptureController {
  @override
  AsyncValue<SourceConversation?> build() => const AsyncData(null);

  /// Persists the conversation locally. Extraction is a Review action, not
  /// part of save: loading a GGUF spawns an isolate and can stall the UI.
  Future<void> capture(String content) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(sourceConversationRepositoryProvider).capture(content),
    );
  }
}

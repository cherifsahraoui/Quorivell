import 'package:a2ui_core/a2ui_core.dart' as core;
import 'package:firebase_ai/firebase_ai.dart' as firebase_ai;
import 'package:genui/genui.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/error/failures.dart';

/// Remote assistant transport. **Not wired into the app.**
///
/// Sending a source conversation to a hosted model would move private content
/// off the device, so construction is deliberately gated: the build must opt
/// in, App Check must be enforced, a model id must be supplied by
/// [AppConfig.remoteAssistant] rather than a literal, and the caller must pass
/// recorded user consent. Any missing gate throws a [RemoteFailure] instead of
/// silently opening a network path.
///
/// [systemInstruction] must come from l10n (`assistantRemoteSystemInstruction`),
/// never a hardcoded English literal.
class FirebaseAiAssistantTransport implements Transport {
  FirebaseAiAssistantTransport._(this._chat);

  factory FirebaseAiAssistantTransport({
    required String systemInstruction,
    required bool hasUserConsent,
    RemoteAssistantConfig config = AppConfig.remoteAssistant,
  }) {
    if (!config.enabled) {
      throw const RemoteFailure.disabled();
    }
    if (!config.appCheckEnforced) {
      throw const RemoteFailure.attestationRequired();
    }
    if (!config.isConfigured) {
      throw const RemoteFailure.notConfigured();
    }
    if (!hasUserConsent) {
      throw const RemoteFailure.consentRequired();
    }

    final model = firebase_ai.FirebaseAI.googleAI().generativeModel(
      model: config.modelId,
      systemInstruction: firebase_ai.Content.system(systemInstruction),
      generationConfig: firebase_ai.GenerationConfig(
        maxOutputTokens: 512,
        temperature: 0.2,
      ),
    );
    return FirebaseAiAssistantTransport._(model.startChat());
  }

  final A2uiTransportAdapter _adapter = A2uiTransportAdapter();
  final firebase_ai.ChatSession _chat;

  @override
  Stream<core.A2uiMessage> get incomingMessages => _adapter.incomingMessages;

  @override
  Stream<String> get incomingText => _adapter.incomingText;

  @override
  Future<void> sendRequest(ChatMessage message) async {
    final text = message.parts
        .whereType<TextPart>()
        .map((part) => part.text)
        .join('\n')
        .trim();
    if (text.isEmpty) return;

    await for (final response in _chat.sendMessageStream(
      firebase_ai.Content.text(text),
    )) {
      final chunk = response.text;
      if (chunk != null && chunk.isNotEmpty) {
        _adapter.addChunk(chunk);
      }
    }
  }

  @override
  void dispose() => _adapter.dispose();
}

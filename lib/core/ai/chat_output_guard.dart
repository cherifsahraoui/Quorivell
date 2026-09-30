import 'chatml_sanitizer.dart';

/// Markers that end a ChatML / instruct turn. Small local models often emit
/// these as text instead of EOS and then start a fake next turn.
const chatGenerationStopMarkers = <String>[
  '<|im_end|>',
  '<|im_start|>',
  '<|endoftext|>',
  '</s>',
];

/// Caps a single on-device chat reply so a missing EOS cannot fill context
/// with the same paragraph.
const chatGenerationMaxVisibleCharacters = 4000;

/// Caps raw llama.cpp output (chat or extraction) before the isolate stops.
const chatGenerationMaxRawCharacters = 8000;

/// Smallest consecutive block treated as a stalled repeat loop.
const chatGenerationMinRepeatBlockCharacters = 48;

/// Stops local generation when the model loops, emits ChatML, or runs away.
///
/// [add] is fed raw token fragments. [visibleText] is safe to persist or show.
class ChatOutputGuard {
  ChatOutputGuard({
    this.maxVisibleCharacters = chatGenerationMaxVisibleCharacters,
    this.minRepeatBlockCharacters = chatGenerationMinRepeatBlockCharacters,
  });

  final int maxVisibleCharacters;
  final int minRepeatBlockCharacters;

  final StringBuffer _raw = StringBuffer();
  var _stopped = false;

  bool get shouldStop => _stopped;

  String get rawText => _raw.toString();

  String get visibleText {
    final clipped = clipGeneratedChatText(
      _raw.toString(),
      maxVisibleCharacters: maxVisibleCharacters,
      minRepeatBlockCharacters: minRepeatBlockCharacters,
    );
    return stripChatMLTokens(clipped);
  }

  /// Records [chunk] and returns whether generation should halt.
  bool add(String chunk) {
    if (_stopped || chunk.isEmpty) return _stopped;
    _raw.write(chunk);
    _stopped = chatGenerationShouldHalt(
      _raw.toString(),
      maxVisibleCharacters: maxVisibleCharacters,
      minRepeatBlockCharacters: minRepeatBlockCharacters,
    );
    return _stopped;
  }
}

/// True when accumulated llama.cpp text should stop being sampled.
bool chatGenerationShouldHalt(
  String accumulated, {
  int maxRawCharacters = chatGenerationMaxRawCharacters,
  int maxVisibleCharacters = chatGenerationMaxVisibleCharacters,
  int minRepeatBlockCharacters = chatGenerationMinRepeatBlockCharacters,
}) {
  if (accumulated.length >= maxRawCharacters) return true;
  if (firstChatStopMarkerIndex(accumulated) >= 0) return true;
  final visible = stripChatMLTokens(accumulated, trimResult: false);
  if (visible.length >= maxVisibleCharacters) return true;
  if (hasImmediateRepeatedBlock(visible, minLen: minRepeatBlockCharacters)) {
    return true;
  }
  return hasRepeatedTrailingLines(visible);
}

/// Index of the earliest stop marker, or `-1`.
int firstChatStopMarkerIndex(String text) {
  var cut = -1;
  for (final marker in chatGenerationStopMarkers) {
    final index = text.indexOf(marker);
    if (index < 0) continue;
    if (cut < 0 || index < cut) cut = index;
  }
  return cut;
}

/// Drops a trailing ChatML turn and a consecutive repeated tail.
String clipGeneratedChatText(
  String raw, {
  int maxVisibleCharacters = chatGenerationMaxVisibleCharacters,
  int minRepeatBlockCharacters = chatGenerationMinRepeatBlockCharacters,
}) {
  var text = raw;
  final markerAt = firstChatStopMarkerIndex(text);
  if (markerAt >= 0) {
    text = text.substring(0, markerAt);
  }
  var visible = stripChatMLTokens(text, trimResult: false);
  visible = clipImmediateRepeatedTail(
    visible,
    minLen: minRepeatBlockCharacters,
  );
  visible = clipRepeatedTrailingLines(visible);
  if (visible.length > maxVisibleCharacters) {
    return visible.substring(0, maxVisibleCharacters);
  }
  return visible;
}

/// True when [text] ends with a block that already appeared immediately before.
bool hasImmediateRepeatedBlock(String text, {int minLen = 48}) {
  return clipImmediateRepeatedTail(text, minLen: minLen).length < text.length;
}

String clipImmediateRepeatedTail(String text, {int minLen = 48}) {
  var current = text;
  while (true) {
    final length = current.length;
    if (length < minLen * 2) return current;
    final maxLen = _minInt(length ~/ 2, 800);
    var clipped = current;
    for (var block = maxLen; block >= minLen; block--) {
      final start = length - 2 * block;
      final first = current.substring(start, start + block);
      final second = current.substring(start + block);
      if (first == second) {
        clipped = current.substring(0, start + block);
        break;
      }
    }
    if (clipped.length == current.length) return current;
    current = clipped;
  }
}

/// True when the last four substantial lines are identical.
bool hasRepeatedTrailingLines(
  String text, {
  int times = 4,
  int minLineLength = 12,
}) {
  return clipRepeatedTrailingLines(
        text,
        times: times,
        minLineLength: minLineLength,
      ).length <
      text.length;
}

String clipRepeatedTrailingLines(
  String text, {
  int times = 4,
  int minLineLength = 12,
}) {
  final lines = text.split('\n');
  final substantial = <int>[];
  for (var i = 0; i < lines.length; i++) {
    if (lines[i].trim().length >= minLineLength) {
      substantial.add(i);
    }
  }
  if (substantial.length < times) return text;
  final tailIndexes = substantial.sublist(substantial.length - times);
  final sample = lines[tailIndexes.first];
  for (final index in tailIndexes) {
    if (lines[index] != sample) return text;
  }
  final keepThrough = tailIndexes.first;
  return lines.sublist(0, keepThrough + 1).join('\n');
}

int _minInt(int a, int b) => a < b ? a : b;

import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/core/ai/local_model_spec.dart';

void main() {
  test('catalog lists Qwen as recommended and includes Llama 3', () {
    expect(LocalModelSpec.catalog, contains(LocalModelSpec.production));
    expect(LocalModelSpec.production.recommended, isTrue);
    expect(LocalModelSpec.production.sha256, isNotNull);
    expect(
      LocalModelSpec.catalog.map((model) => model.modelId),
      containsAll([
        LocalModelSpec.qwen15InstructUncensoredQ4.modelId,
        LocalModelSpec.dolphin30Qwen15Q4.modelId,
        LocalModelSpec.llama32InstructQ4.modelId,
        LocalModelSpec.llama32InstructUncensoredQ4.modelId,
        LocalModelSpec.llama3InstructQ4.modelId,
      ]),
    );
    expect(LocalModelSpec.qwen15InstructUncensoredQ4.uncensored, isTrue);
    expect(LocalModelSpec.dolphin30Qwen15Q4.uncensored, isTrue);
    expect(LocalModelSpec.llama32InstructUncensoredQ4.uncensored, isTrue);
    expect(LocalModelSpec.production.uncensored, isFalse);
    expect(LocalModelSpec.llama32InstructQ4.uncensored, isFalse);
    expect(LocalModelSpec.qwen15InstructUncensoredQ4.needsMoreRam, isFalse);
    expect(LocalModelSpec.qwen15InstructUncensoredQ4.recommended, isFalse);
    expect(LocalModelSpec.dolphin30Qwen15Q4.needsMoreRam, isFalse);
    expect(LocalModelSpec.dolphin30Qwen15Q4.recommended, isFalse);
    expect(LocalModelSpec.llama3InstructQ4.needsMoreRam, isTrue);
    expect(LocalModelSpec.llama32InstructQ4.needsMoreRam, isTrue);
    expect(LocalModelSpec.llama32InstructUncensoredQ4.needsMoreRam, isTrue);
    expect(LocalModelSpec.llama3InstructQ4.sha256, isNull);
    expect(LocalModelSpec.qwen15InstructUncensoredQ4.sha256, isNull);
    expect(LocalModelSpec.dolphin30Qwen15Q4.sha256, isNull);
    expect(LocalModelSpec.llama32InstructUncensoredQ4.sha256, isNull);
  });

  test('huggingFacePageUri drops the resolve path', () {
    expect(
      LocalModelSpec.production.huggingFacePageUri.toString(),
      'https://huggingface.co/Qwen/Qwen2.5-1.5B-Instruct-GGUF',
    );
    expect(
      LocalModelSpec.llama3InstructQ4.huggingFacePageUri.toString(),
      'https://huggingface.co/bartowski/Meta-Llama-3-8B-Instruct-GGUF',
    );
    expect(
      LocalModelSpec.llama32InstructUncensoredQ4.huggingFacePageUri.toString(),
      'https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-uncensored-GGUF',
    );
    expect(
      LocalModelSpec.qwen15InstructUncensoredQ4.huggingFacePageUri.toString(),
      'https://huggingface.co/mradermacher/Qwen2.5-1.5B-Instruct-uncensored-GGUF',
    );
    expect(
      LocalModelSpec.dolphin30Qwen15Q4.huggingFacePageUri.toString(),
      'https://huggingface.co/mradermacher/Dolphin3.0-Qwen2.5-1.5B-GGUF',
    );
  });
}

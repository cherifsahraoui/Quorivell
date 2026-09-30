import 'package:flutter_test/flutter_test.dart';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';

import 'package:quorivell/core/ai/llama_isolate_host.dart';

void main() {
  test('model load timeout exceeds stock LlamaParent 60s limit', () {
    expect(llamaModelLoadTimeout.inSeconds, greaterThan(60));
  });

  test('Quorivell llama child is a LlamaChild for typed_isolate spawn', () {
    expect(QuorivellLlamaChild(), isA<LlamaChild>());
  });

  test('token coalescer flushes at the character cap', () {
    final flushed = <String>[];
    final coalescer = LlamaTokenCoalescer(
      onFlush: flushed.add,
      interval: const Duration(days: 1),
      maxChars: 4,
    );

    coalescer.add('ab');
    expect(flushed, isEmpty);
    coalescer.add('cd');
    expect(flushed, ['abcd']);
    coalescer.dispose();
  });

  test('token coalescer flush sends leftover tokens', () {
    final flushed = <String>[];
    final coalescer = LlamaTokenCoalescer(
      onFlush: flushed.add,
      interval: const Duration(days: 1),
    );

    coalescer.add('hi');
    expect(flushed, isEmpty);
    coalescer.flush();
    expect(flushed, ['hi']);
    coalescer.flush();
    expect(flushed, ['hi']);
    coalescer.dispose();
  });

  test('token coalescer ignores empty fragments', () {
    final flushed = <String>[];
    final coalescer = LlamaTokenCoalescer(onFlush: flushed.add);
    coalescer.add('');
    coalescer.flush();
    expect(flushed, isEmpty);
    coalescer.dispose();
  });
}

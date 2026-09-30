import 'package:flutter_test/flutter_test.dart';
import 'package:quorivell/core/ai/local_model_spec.dart';
import 'package:quorivell/core/device/device_capability_service.dart';

void main() {
  group('DeviceCapability.canFitModel', () {
    test('uses installed memory minus system reserve, not free memory', () {
      const capability = DeviceCapability(
        totalRamBytes: 12 * 1024 * 1024 * 1024,
        availableRamBytes: 3 * 1024 * 1024 * 1024,
        processorAbi: 'arm64-v8a',
      );

      expect(
        capability.canFitModel(
          LocalModelSpec.llama3InstructQ4.approximateBytes!,
        ),
        isTrue,
      );
    });

    test('warns when installed memory is too small after reserve', () {
      const capability = DeviceCapability(
        totalRamBytes: 8 * 1024 * 1024 * 1024,
        availableRamBytes: 5 * 1024 * 1024 * 1024,
        processorAbi: 'arm64-v8a',
      );

      expect(
        capability.canFitModel(
          LocalModelSpec.llama3InstructQ4.approximateBytes!,
        ),
        isFalse,
      );
    });

    test('requiredRamGBForModel applies 1.5x file size estimate', () {
      const capability = DeviceCapability(
        totalRamBytes: 8 * 1024 * 1024 * 1024,
        availableRamBytes: 4 * 1024 * 1024 * 1024,
        processorAbi: 'arm64-v8a',
      );

      final required = capability.requiredRamGBForModel(
        LocalModelSpec.llama3InstructQ4.approximateBytes!,
      );

      expect(required, closeTo(6.87, 0.05));
    });
  });
}

import 'dart:io';

import 'package:flutter/services.dart';

class DeviceCapability {
  const DeviceCapability({
    required this.totalRamBytes,
    required this.availableRamBytes,
    required this.processorAbi,
  });

  /// Headroom reserved for Android, Flutter, and background apps.
  static const int systemReserveBytes = 2 * 1024 * 1024 * 1024;

  final int totalRamBytes;
  final int availableRamBytes;
  final String processorAbi;

  double get totalRamGB => totalRamBytes / (1024 * 1024 * 1024);
  double get availableRamGB => availableRamBytes / (1024 * 1024 * 1024);

  int get usableRamBytes =>
      (totalRamBytes - systemReserveBytes).clamp(0, totalRamBytes);

  double get usableRamGB => usableRamBytes / (1024 * 1024 * 1024);

  int requiredBytesForModel(int approximateModelBytes) {
    // Conservative estimate: model needs 1.5x its size in RAM for loading + inference.
    return (approximateModelBytes * 1.5).toInt();
  }

  double requiredRamGBForModel(int approximateModelBytes) {
    return requiredBytesForModel(approximateModelBytes) / (1024 * 1024 * 1024);
  }

  bool canFitModel(int approximateModelBytes) {
    return usableRamBytes >= requiredBytesForModel(approximateModelBytes);
  }
}

abstract interface class DeviceCapabilityService {
  Future<DeviceCapability> getCapability();
}

class AndroidDeviceCapabilityService implements DeviceCapabilityService {
  AndroidDeviceCapabilityService({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('com.quorivell.app/device');

  final MethodChannel _channel;

  @override
  Future<DeviceCapability> getCapability() async {
    try {
      final result = await _channel.invokeMethod<Map>('getDeviceCapability');
      if (result == null) {
        return _fallbackCapability();
      }

      final totalRam = result['totalRamBytes'] as int? ?? 0;
      final availableRam = result['availableRamBytes'] as int? ?? totalRam;
      final abi = result['processorAbi'] as String? ?? 'unknown';

      return DeviceCapability(
        totalRamBytes: totalRam,
        availableRamBytes: availableRam,
        processorAbi: abi,
      );
    } on PlatformException catch (_) {
      return _fallbackCapability();
    }
  }

  DeviceCapability _fallbackCapability() {
    // Conservative fallback: assume 4GB total, 2GB available
    return const DeviceCapability(
      totalRamBytes: 4 * 1024 * 1024 * 1024,
      availableRamBytes: 2 * 1024 * 1024 * 1024,
      processorAbi: 'unknown',
    );
  }
}

class StubDeviceCapabilityService implements DeviceCapabilityService {
  @override
  Future<DeviceCapability> getCapability() async {
    // Desktop/iOS stub: generous capability
    return const DeviceCapability(
      totalRamBytes: 8 * 1024 * 1024 * 1024,
      availableRamBytes: 6 * 1024 * 1024 * 1024,
      processorAbi: 'stub',
    );
  }
}

DeviceCapabilityService createDeviceCapabilityService() {
  if (Platform.isAndroid) {
    return AndroidDeviceCapabilityService();
  }
  return StubDeviceCapabilityService();
}

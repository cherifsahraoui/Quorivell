import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'device_capability_service.dart';

part 'device_capability_providers.g.dart';

@riverpod
DeviceCapabilityService deviceCapabilityService(Ref ref) {
  return createDeviceCapabilityService();
}

@riverpod
Future<DeviceCapability> deviceCapability(Ref ref) async {
  final service = ref.watch(deviceCapabilityServiceProvider);
  return service.getCapability();
}

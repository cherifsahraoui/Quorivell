import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../platform/model_transfer_platform_service.dart';
import 'local_model_downloader.dart';
import 'local_model_spec.dart';
import 'local_model_store.dart';

part 'local_model_providers.g.dart';

@Riverpod(keepAlive: true)
LocalModelSpec localModelSpec(Ref ref) => LocalModelSpec.production;

@Riverpod(keepAlive: true)
LocalModelStore localModelStore(Ref ref) {
  return LocalModelStore(
    resolveDocumentsDirectory: getApplicationDocumentsDirectory,
    spec: ref.watch(localModelSpecProvider),
  );
}

@Riverpod(keepAlive: true)
LocalModelDownloader localModelDownloader(Ref ref) {
  final downloader = LocalModelDownloader(
    store: ref.watch(localModelStoreProvider),
    transfer: ref.watch(modelTransferPlatformServiceProvider),
  );
  ref.onDispose(downloader.cancel);
  return downloader;
}

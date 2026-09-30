// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_user_scope_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localUserScopeLocalDataSource)
final localUserScopeLocalDataSourceProvider =
    LocalUserScopeLocalDataSourceProvider._();

final class LocalUserScopeLocalDataSourceProvider
    extends
        $FunctionalProvider<
          LocalUserScopeLocalDataSource,
          LocalUserScopeLocalDataSource,
          LocalUserScopeLocalDataSource
        >
    with $Provider<LocalUserScopeLocalDataSource> {
  LocalUserScopeLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localUserScopeLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localUserScopeLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<LocalUserScopeLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalUserScopeLocalDataSource create(Ref ref) {
    return localUserScopeLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalUserScopeLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalUserScopeLocalDataSource>(
        value,
      ),
    );
  }
}

String _$localUserScopeLocalDataSourceHash() =>
    r'f0741b8ff0bf6e78b3836533704b8e3052b5b195';

@ProviderFor(localUserScopeRepository)
final localUserScopeRepositoryProvider = LocalUserScopeRepositoryProvider._();

final class LocalUserScopeRepositoryProvider
    extends
        $FunctionalProvider<
          LocalUserScopeRepository,
          LocalUserScopeRepository,
          LocalUserScopeRepository
        >
    with $Provider<LocalUserScopeRepository> {
  LocalUserScopeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localUserScopeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localUserScopeRepositoryHash();

  @$internal
  @override
  $ProviderElement<LocalUserScopeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalUserScopeRepository create(Ref ref) {
    return localUserScopeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalUserScopeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalUserScopeRepository>(value),
    );
  }
}

String _$localUserScopeRepositoryHash() =>
    r'b73b2a606008be407c3952178b8c0c6f05fdc6b8';

@ProviderFor(localUserScope)
final localUserScopeProvider = LocalUserScopeProvider._();

final class LocalUserScopeProvider
    extends
        $FunctionalProvider<
          AsyncValue<LocalUserScope>,
          LocalUserScope,
          FutureOr<LocalUserScope>
        >
    with $FutureModifier<LocalUserScope>, $FutureProvider<LocalUserScope> {
  LocalUserScopeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localUserScopeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localUserScopeHash();

  @$internal
  @override
  $FutureProviderElement<LocalUserScope> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LocalUserScope> create(Ref ref) {
    return localUserScope(ref);
  }
}

String _$localUserScopeHash() => r'3b014ecc97724d97822330987b97cdf721bb0be9';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preference_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userPreferenceLocalDataSource)
final userPreferenceLocalDataSourceProvider =
    UserPreferenceLocalDataSourceProvider._();

final class UserPreferenceLocalDataSourceProvider
    extends
        $FunctionalProvider<
          UserPreferenceLocalDataSource,
          UserPreferenceLocalDataSource,
          UserPreferenceLocalDataSource
        >
    with $Provider<UserPreferenceLocalDataSource> {
  UserPreferenceLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userPreferenceLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userPreferenceLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<UserPreferenceLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UserPreferenceLocalDataSource create(Ref ref) {
    return userPreferenceLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserPreferenceLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserPreferenceLocalDataSource>(
        value,
      ),
    );
  }
}

String _$userPreferenceLocalDataSourceHash() =>
    r'f0ffd6d99b740eef3dc4f3e6e77a16bc7d4e11e0';

@ProviderFor(userPreferenceRepository)
final userPreferenceRepositoryProvider = UserPreferenceRepositoryProvider._();

final class UserPreferenceRepositoryProvider
    extends
        $FunctionalProvider<
          UserPreferenceRepository,
          UserPreferenceRepository,
          UserPreferenceRepository
        >
    with $Provider<UserPreferenceRepository> {
  UserPreferenceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userPreferenceRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userPreferenceRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserPreferenceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UserPreferenceRepository create(Ref ref) {
    return userPreferenceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserPreferenceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserPreferenceRepository>(value),
    );
  }
}

String _$userPreferenceRepositoryHash() =>
    r'8e3733616316c6817c7ee2b5a6cf42073c460bfa';

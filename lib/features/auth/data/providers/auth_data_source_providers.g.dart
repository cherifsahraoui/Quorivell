// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_data_source_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The only place that constructs `FirebaseAuth`.
///
/// Keeping the SDK instance behind a data-layer provider lets tests override
/// the data source and keeps `FirebaseAuth.instance` out of repositories,
/// controllers, and pages. The provider is lazy, so a local-only run that never
/// signs in never touches Firebase.

@ProviderFor(authRemoteDataSource)
final authRemoteDataSourceProvider = AuthRemoteDataSourceProvider._();

/// The only place that constructs `FirebaseAuth`.
///
/// Keeping the SDK instance behind a data-layer provider lets tests override
/// the data source and keeps `FirebaseAuth.instance` out of repositories,
/// controllers, and pages. The provider is lazy, so a local-only run that never
/// signs in never touches Firebase.

final class AuthRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AuthRemoteDataSource,
          AuthRemoteDataSource,
          AuthRemoteDataSource
        >
    with $Provider<AuthRemoteDataSource> {
  /// The only place that constructs `FirebaseAuth`.
  ///
  /// Keeping the SDK instance behind a data-layer provider lets tests override
  /// the data source and keeps `FirebaseAuth.instance` out of repositories,
  /// controllers, and pages. The provider is lazy, so a local-only run that never
  /// signs in never touches Firebase.
  AuthRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AuthRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthRemoteDataSource create(Ref ref) {
    return authRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRemoteDataSource>(value),
    );
  }
}

String _$authRemoteDataSourceHash() =>
    r'5daf878502b90124df4651b31aea5b9545385bdf';

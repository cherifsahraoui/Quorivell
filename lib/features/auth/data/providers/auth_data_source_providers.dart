import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../datasources/auth_remote_data_source.dart';
import '../datasources/firebase_auth_remote_data_source.dart';

part 'auth_data_source_providers.g.dart';

/// The only place that constructs `FirebaseAuth`.
///
/// Keeping the SDK instance behind a data-layer provider lets tests override
/// the data source and keeps `FirebaseAuth.instance` out of repositories,
/// controllers, and pages. The provider is lazy, so a local-only run that never
/// signs in never touches Firebase.
@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) =>
    FirebaseAuthRemoteDataSource(FirebaseAuth.instance);

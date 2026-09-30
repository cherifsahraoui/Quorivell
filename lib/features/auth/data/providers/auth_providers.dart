import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/auth_repository.dart';
import '../repositories/auth_repository_impl.dart';
import 'auth_data_source_providers.dart';

part 'auth_providers.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) =>
    AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));

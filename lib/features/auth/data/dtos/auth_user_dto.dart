import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/auth_user.dart';

part 'auth_user_dto.freezed.dart';
part 'auth_user_dto.g.dart';

/// Data-layer representation of a signed-in account.
///
/// The auth data-source interface speaks this type so that no `User` or
/// `UserCredential` from the Firebase SDK crosses into the repository, domain,
/// or presentation layers.
@freezed
abstract class AuthUserDto with _$AuthUserDto {
  const AuthUserDto._();

  const factory AuthUserDto({
    required String id,
    String? email,
    String? displayName,
  }) = _AuthUserDto;

  factory AuthUserDto.fromJson(Map<String, dynamic> json) =>
      _$AuthUserDtoFromJson(json);

  AuthUser toDomain() =>
      AuthUser(id: id, email: email, displayName: displayName);
}

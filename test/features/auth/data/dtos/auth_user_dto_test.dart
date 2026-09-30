import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/features/auth/data/dtos/auth_user_dto.dart';
import 'package:quorivell/features/auth/domain/entities/auth_user.dart';

void main() {
  const dto = AuthUserDto(
    id: 'uid-1',
    email: 'reviewer@example.test',
    displayName: 'Reviewer',
  );

  test('maps to the domain entity', () {
    expect(
      dto.toDomain(),
      const AuthUser(
        id: 'uid-1',
        email: 'reviewer@example.test',
        displayName: 'Reviewer',
      ),
    );
  });

  test('round-trips through json', () {
    expect(AuthUserDto.fromJson(dto.toJson()), dto);
  });

  test('keeps optional account fields nullable', () {
    const minimal = AuthUserDto(id: 'uid-2');

    expect(minimal.toDomain().email, isNull);
    expect(minimal.toDomain().displayName, isNull);
  });
}

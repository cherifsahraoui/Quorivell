import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/features/auth/domain/entities/local_user_scope.dart';

LocalUserScope _scope() => LocalUserScope(
  id: 'scope-1',
  createdAt: DateTime.utc(2026, 9, 7),
  updatedAt: DateTime.utc(2026, 9, 7),
);

void main() {
  test('compares by value', () {
    expect(_scope(), _scope());
  });

  test('round-trips through json', () {
    expect(LocalUserScope.fromJson(_scope().toJson()), _scope());
  });

  test('copyWith updates only the touched timestamp', () {
    final touched = _scope().copyWith(updatedAt: DateTime.utc(2026, 9, 8));

    expect(touched.updatedAt, DateTime.utc(2026, 9, 8));
    expect(touched.createdAt, DateTime.utc(2026, 9, 7));
    expect(touched.id, 'scope-1');
  });
}

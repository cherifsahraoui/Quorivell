import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_user_scope.freezed.dart';
part 'local_user_scope.g.dart';

@freezed
abstract class LocalUserScope with _$LocalUserScope {
  const factory LocalUserScope({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _LocalUserScope;

  factory LocalUserScope.fromJson(Map<String, dynamic> json) =>
      _$LocalUserScopeFromJson(json);
}

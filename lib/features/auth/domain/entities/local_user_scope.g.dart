// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_user_scope.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LocalUserScope _$LocalUserScopeFromJson(Map<String, dynamic> json) =>
    _LocalUserScope(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$LocalUserScopeToJson(_LocalUserScope instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

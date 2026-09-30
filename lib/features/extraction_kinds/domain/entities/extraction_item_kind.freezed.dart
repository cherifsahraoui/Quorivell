// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extraction_item_kind.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExtractionTeachingExample {

 String get sourceExcerpt; String get quoteSnippet; String get statement;
/// Create a copy of ExtractionTeachingExample
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtractionTeachingExampleCopyWith<ExtractionTeachingExample> get copyWith => _$ExtractionTeachingExampleCopyWithImpl<ExtractionTeachingExample>(this as ExtractionTeachingExample, _$identity);

  /// Serializes this ExtractionTeachingExample to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExtractionTeachingExample;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtractionTeachingExample&&(identical(other.sourceExcerpt, _this.sourceExcerpt) || other.sourceExcerpt == _this.sourceExcerpt)&&(identical(other.quoteSnippet, _this.quoteSnippet) || other.quoteSnippet == _this.quoteSnippet)&&(identical(other.statement, _this.statement) || other.statement == _this.statement));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExtractionTeachingExample;
  return Object.hash(runtimeType,_this.sourceExcerpt,_this.quoteSnippet,_this.statement);
}

@override
String toString() {
  final _this = this as ExtractionTeachingExample;
  return 'ExtractionTeachingExample(sourceExcerpt: ${_this.sourceExcerpt}, quoteSnippet: ${_this.quoteSnippet}, statement: ${_this.statement})';
}


}

/// @nodoc
abstract mixin class $ExtractionTeachingExampleCopyWith<$Res>  {
  factory $ExtractionTeachingExampleCopyWith(ExtractionTeachingExample value, $Res Function(ExtractionTeachingExample) _then) = _$ExtractionTeachingExampleCopyWithImpl;
@useResult
$Res call({
 String sourceExcerpt, String quoteSnippet, String statement
});




}
/// @nodoc
class _$ExtractionTeachingExampleCopyWithImpl<$Res>
    implements $ExtractionTeachingExampleCopyWith<$Res> {
  _$ExtractionTeachingExampleCopyWithImpl(this._self, this._then);

  final ExtractionTeachingExample _self;
  final $Res Function(ExtractionTeachingExample) _then;

/// Create a copy of ExtractionTeachingExample
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceExcerpt = null,Object? quoteSnippet = null,Object? statement = null,}) {
  return _then(ExtractionTeachingExample(
sourceExcerpt: null == sourceExcerpt ? _self.sourceExcerpt : sourceExcerpt // ignore: cast_nullable_to_non_nullable
as String,quoteSnippet: null == quoteSnippet ? _self.quoteSnippet : quoteSnippet // ignore: cast_nullable_to_non_nullable
as String,statement: null == statement ? _self.statement : statement // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ExtractionTeachingExample].
extension ExtractionTeachingExamplePatterns on ExtractionTeachingExample {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExtractionTeachingExample value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExtractionTeachingExample() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExtractionTeachingExample value)  $default,){
final _that = this;
switch (_that) {
case _ExtractionTeachingExample():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExtractionTeachingExample value)?  $default,){
final _that = this;
switch (_that) {
case _ExtractionTeachingExample() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sourceExcerpt,  String quoteSnippet,  String statement)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExtractionTeachingExample() when $default != null:
return $default(_that.sourceExcerpt,_that.quoteSnippet,_that.statement);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sourceExcerpt,  String quoteSnippet,  String statement)  $default,) {final _that = this;
switch (_that) {
case _ExtractionTeachingExample():
return $default(_that.sourceExcerpt,_that.quoteSnippet,_that.statement);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sourceExcerpt,  String quoteSnippet,  String statement)?  $default,) {final _that = this;
switch (_that) {
case _ExtractionTeachingExample() when $default != null:
return $default(_that.sourceExcerpt,_that.quoteSnippet,_that.statement);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExtractionTeachingExample implements ExtractionTeachingExample {
  const _ExtractionTeachingExample({required this.sourceExcerpt, required this.quoteSnippet, required this.statement});
  factory _ExtractionTeachingExample.fromJson(Map<String, dynamic> json) => _$ExtractionTeachingExampleFromJson(json);

@override final  String sourceExcerpt;
@override final  String quoteSnippet;
@override final  String statement;

/// Create a copy of ExtractionTeachingExample
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtractionTeachingExampleCopyWith<_ExtractionTeachingExample> get copyWith => __$ExtractionTeachingExampleCopyWithImpl<_ExtractionTeachingExample>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExtractionTeachingExampleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtractionTeachingExample&&(identical(other.sourceExcerpt, sourceExcerpt) || other.sourceExcerpt == sourceExcerpt)&&(identical(other.quoteSnippet, quoteSnippet) || other.quoteSnippet == quoteSnippet)&&(identical(other.statement, statement) || other.statement == statement));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,sourceExcerpt,quoteSnippet,statement);
}

@override
String toString() {
    return 'ExtractionTeachingExample(sourceExcerpt: $sourceExcerpt, quoteSnippet: $quoteSnippet, statement: $statement)';
}


}

/// @nodoc
abstract mixin class _$ExtractionTeachingExampleCopyWith<$Res> implements $ExtractionTeachingExampleCopyWith<$Res> {
  factory _$ExtractionTeachingExampleCopyWith(_ExtractionTeachingExample value, $Res Function(_ExtractionTeachingExample) _then) = __$ExtractionTeachingExampleCopyWithImpl;
@override @useResult
$Res call({
 String sourceExcerpt, String quoteSnippet, String statement
});




}
/// @nodoc
class __$ExtractionTeachingExampleCopyWithImpl<$Res>
    implements _$ExtractionTeachingExampleCopyWith<$Res> {
  __$ExtractionTeachingExampleCopyWithImpl(this._self, this._then);

  final _ExtractionTeachingExample _self;
  final $Res Function(_ExtractionTeachingExample) _then;

/// Create a copy of ExtractionTeachingExample
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceExcerpt = null,Object? quoteSnippet = null,Object? statement = null,}) {
  return _then(_ExtractionTeachingExample(
sourceExcerpt: null == sourceExcerpt ? _self.sourceExcerpt : sourceExcerpt // ignore: cast_nullable_to_non_nullable
as String,quoteSnippet: null == quoteSnippet ? _self.quoteSnippet : quoteSnippet // ignore: cast_nullable_to_non_nullable
as String,statement: null == statement ? _self.statement : statement // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ExtractionItemKind {

 String get id; String get userId; String get slug; String get displayName; String? get extractionHint; ExtractionKindBehavior get behavior; ExtractionKindFieldPolicy get datePolicy; ExtractionKindFieldPolicy get notePolicy; ExtractionKindFieldPolicy get ownerPolicy; bool get enabledForExtraction; bool get isBuiltIn; int get sortOrder; List<ExtractionTeachingExample> get teachingExamples; DateTime get createdAt; DateTime get updatedAt; bool get isDeleted;
/// Create a copy of ExtractionItemKind
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtractionItemKindCopyWith<ExtractionItemKind> get copyWith => _$ExtractionItemKindCopyWithImpl<ExtractionItemKind>(this as ExtractionItemKind, _$identity);

  /// Serializes this ExtractionItemKind to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExtractionItemKind;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtractionItemKind&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.extractionHint, _this.extractionHint) || other.extractionHint == _this.extractionHint)&&(identical(other.behavior, _this.behavior) || other.behavior == _this.behavior)&&(identical(other.datePolicy, _this.datePolicy) || other.datePolicy == _this.datePolicy)&&(identical(other.notePolicy, _this.notePolicy) || other.notePolicy == _this.notePolicy)&&(identical(other.ownerPolicy, _this.ownerPolicy) || other.ownerPolicy == _this.ownerPolicy)&&(identical(other.enabledForExtraction, _this.enabledForExtraction) || other.enabledForExtraction == _this.enabledForExtraction)&&(identical(other.isBuiltIn, _this.isBuiltIn) || other.isBuiltIn == _this.isBuiltIn)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder)&&const DeepCollectionEquality().equals(other.teachingExamples, _this.teachingExamples)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.isDeleted, _this.isDeleted) || other.isDeleted == _this.isDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExtractionItemKind;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.slug,_this.displayName,_this.extractionHint,_this.behavior,_this.datePolicy,_this.notePolicy,_this.ownerPolicy,_this.enabledForExtraction,_this.isBuiltIn,_this.sortOrder,const DeepCollectionEquality().hash(_this.teachingExamples),_this.createdAt,_this.updatedAt,_this.isDeleted);
}

@override
String toString() {
  final _this = this as ExtractionItemKind;
  return 'ExtractionItemKind(id: ${_this.id}, userId: ${_this.userId}, slug: ${_this.slug}, displayName: ${_this.displayName}, extractionHint: ${_this.extractionHint}, behavior: ${_this.behavior}, datePolicy: ${_this.datePolicy}, notePolicy: ${_this.notePolicy}, ownerPolicy: ${_this.ownerPolicy}, enabledForExtraction: ${_this.enabledForExtraction}, isBuiltIn: ${_this.isBuiltIn}, sortOrder: ${_this.sortOrder}, teachingExamples: ${_this.teachingExamples}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, isDeleted: ${_this.isDeleted})';
}


}

/// @nodoc
abstract mixin class $ExtractionItemKindCopyWith<$Res>  {
  factory $ExtractionItemKindCopyWith(ExtractionItemKind value, $Res Function(ExtractionItemKind) _then) = _$ExtractionItemKindCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String slug, String displayName, String? extractionHint, ExtractionKindBehavior behavior, ExtractionKindFieldPolicy datePolicy, ExtractionKindFieldPolicy notePolicy, ExtractionKindFieldPolicy ownerPolicy, bool enabledForExtraction, bool isBuiltIn, int sortOrder, List<ExtractionTeachingExample> teachingExamples, DateTime createdAt, DateTime updatedAt, bool isDeleted
});




}
/// @nodoc
class _$ExtractionItemKindCopyWithImpl<$Res>
    implements $ExtractionItemKindCopyWith<$Res> {
  _$ExtractionItemKindCopyWithImpl(this._self, this._then);

  final ExtractionItemKind _self;
  final $Res Function(ExtractionItemKind) _then;

/// Create a copy of ExtractionItemKind
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? slug = null,Object? displayName = null,Object? extractionHint = freezed,Object? behavior = null,Object? datePolicy = null,Object? notePolicy = null,Object? ownerPolicy = null,Object? enabledForExtraction = null,Object? isBuiltIn = null,Object? sortOrder = null,Object? teachingExamples = null,Object? createdAt = null,Object? updatedAt = null,Object? isDeleted = null,}) {
  return _then(ExtractionItemKind(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,extractionHint: freezed == extractionHint ? _self.extractionHint : extractionHint // ignore: cast_nullable_to_non_nullable
as String?,behavior: null == behavior ? _self.behavior : behavior // ignore: cast_nullable_to_non_nullable
as ExtractionKindBehavior,datePolicy: null == datePolicy ? _self.datePolicy : datePolicy // ignore: cast_nullable_to_non_nullable
as ExtractionKindFieldPolicy,notePolicy: null == notePolicy ? _self.notePolicy : notePolicy // ignore: cast_nullable_to_non_nullable
as ExtractionKindFieldPolicy,ownerPolicy: null == ownerPolicy ? _self.ownerPolicy : ownerPolicy // ignore: cast_nullable_to_non_nullable
as ExtractionKindFieldPolicy,enabledForExtraction: null == enabledForExtraction ? _self.enabledForExtraction : enabledForExtraction // ignore: cast_nullable_to_non_nullable
as bool,isBuiltIn: null == isBuiltIn ? _self.isBuiltIn : isBuiltIn // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,teachingExamples: null == teachingExamples ? _self.teachingExamples : teachingExamples // ignore: cast_nullable_to_non_nullable
as List<ExtractionTeachingExample>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ExtractionItemKind].
extension ExtractionItemKindPatterns on ExtractionItemKind {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExtractionItemKind value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExtractionItemKind() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExtractionItemKind value)  $default,){
final _that = this;
switch (_that) {
case _ExtractionItemKind():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExtractionItemKind value)?  $default,){
final _that = this;
switch (_that) {
case _ExtractionItemKind() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String slug,  String displayName,  String? extractionHint,  ExtractionKindBehavior behavior,  ExtractionKindFieldPolicy datePolicy,  ExtractionKindFieldPolicy notePolicy,  ExtractionKindFieldPolicy ownerPolicy,  bool enabledForExtraction,  bool isBuiltIn,  int sortOrder,  List<ExtractionTeachingExample> teachingExamples,  DateTime createdAt,  DateTime updatedAt,  bool isDeleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExtractionItemKind() when $default != null:
return $default(_that.id,_that.userId,_that.slug,_that.displayName,_that.extractionHint,_that.behavior,_that.datePolicy,_that.notePolicy,_that.ownerPolicy,_that.enabledForExtraction,_that.isBuiltIn,_that.sortOrder,_that.teachingExamples,_that.createdAt,_that.updatedAt,_that.isDeleted);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String slug,  String displayName,  String? extractionHint,  ExtractionKindBehavior behavior,  ExtractionKindFieldPolicy datePolicy,  ExtractionKindFieldPolicy notePolicy,  ExtractionKindFieldPolicy ownerPolicy,  bool enabledForExtraction,  bool isBuiltIn,  int sortOrder,  List<ExtractionTeachingExample> teachingExamples,  DateTime createdAt,  DateTime updatedAt,  bool isDeleted)  $default,) {final _that = this;
switch (_that) {
case _ExtractionItemKind():
return $default(_that.id,_that.userId,_that.slug,_that.displayName,_that.extractionHint,_that.behavior,_that.datePolicy,_that.notePolicy,_that.ownerPolicy,_that.enabledForExtraction,_that.isBuiltIn,_that.sortOrder,_that.teachingExamples,_that.createdAt,_that.updatedAt,_that.isDeleted);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String slug,  String displayName,  String? extractionHint,  ExtractionKindBehavior behavior,  ExtractionKindFieldPolicy datePolicy,  ExtractionKindFieldPolicy notePolicy,  ExtractionKindFieldPolicy ownerPolicy,  bool enabledForExtraction,  bool isBuiltIn,  int sortOrder,  List<ExtractionTeachingExample> teachingExamples,  DateTime createdAt,  DateTime updatedAt,  bool isDeleted)?  $default,) {final _that = this;
switch (_that) {
case _ExtractionItemKind() when $default != null:
return $default(_that.id,_that.userId,_that.slug,_that.displayName,_that.extractionHint,_that.behavior,_that.datePolicy,_that.notePolicy,_that.ownerPolicy,_that.enabledForExtraction,_that.isBuiltIn,_that.sortOrder,_that.teachingExamples,_that.createdAt,_that.updatedAt,_that.isDeleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExtractionItemKind implements ExtractionItemKind {
  const _ExtractionItemKind({required this.id, required this.userId, required this.slug, required this.displayName, this.extractionHint, required this.behavior, required this.datePolicy, required this.notePolicy, required this.ownerPolicy, required this.enabledForExtraction, required this.isBuiltIn, required this.sortOrder,  List<ExtractionTeachingExample> teachingExamples = const [], required this.createdAt, required this.updatedAt, this.isDeleted = false}): _teachingExamples = teachingExamples;
  factory _ExtractionItemKind.fromJson(Map<String, dynamic> json) => _$ExtractionItemKindFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String slug;
@override final  String displayName;
@override final  String? extractionHint;
@override final  ExtractionKindBehavior behavior;
@override final  ExtractionKindFieldPolicy datePolicy;
@override final  ExtractionKindFieldPolicy notePolicy;
@override final  ExtractionKindFieldPolicy ownerPolicy;
@override final  bool enabledForExtraction;
@override final  bool isBuiltIn;
@override final  int sortOrder;
 final  List<ExtractionTeachingExample> _teachingExamples;
@override@JsonKey() List<ExtractionTeachingExample> get teachingExamples {
  if (_teachingExamples is EqualUnmodifiableListView) return _teachingExamples;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_teachingExamples);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  bool isDeleted;

/// Create a copy of ExtractionItemKind
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtractionItemKindCopyWith<_ExtractionItemKind> get copyWith => __$ExtractionItemKindCopyWithImpl<_ExtractionItemKind>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExtractionItemKindToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtractionItemKind&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.extractionHint, extractionHint) || other.extractionHint == extractionHint)&&(identical(other.behavior, behavior) || other.behavior == behavior)&&(identical(other.datePolicy, datePolicy) || other.datePolicy == datePolicy)&&(identical(other.notePolicy, notePolicy) || other.notePolicy == notePolicy)&&(identical(other.ownerPolicy, ownerPolicy) || other.ownerPolicy == ownerPolicy)&&(identical(other.enabledForExtraction, enabledForExtraction) || other.enabledForExtraction == enabledForExtraction)&&(identical(other.isBuiltIn, isBuiltIn) || other.isBuiltIn == isBuiltIn)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&const DeepCollectionEquality().equals(other.teachingExamples, _teachingExamples)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,slug,displayName,extractionHint,behavior,datePolicy,notePolicy,ownerPolicy,enabledForExtraction,isBuiltIn,sortOrder,const DeepCollectionEquality().hash(_teachingExamples),createdAt,updatedAt,isDeleted);
}

@override
String toString() {
    return 'ExtractionItemKind(id: $id, userId: $userId, slug: $slug, displayName: $displayName, extractionHint: $extractionHint, behavior: $behavior, datePolicy: $datePolicy, notePolicy: $notePolicy, ownerPolicy: $ownerPolicy, enabledForExtraction: $enabledForExtraction, isBuiltIn: $isBuiltIn, sortOrder: $sortOrder, teachingExamples: $teachingExamples, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class _$ExtractionItemKindCopyWith<$Res> implements $ExtractionItemKindCopyWith<$Res> {
  factory _$ExtractionItemKindCopyWith(_ExtractionItemKind value, $Res Function(_ExtractionItemKind) _then) = __$ExtractionItemKindCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String slug, String displayName, String? extractionHint, ExtractionKindBehavior behavior, ExtractionKindFieldPolicy datePolicy, ExtractionKindFieldPolicy notePolicy, ExtractionKindFieldPolicy ownerPolicy, bool enabledForExtraction, bool isBuiltIn, int sortOrder, List<ExtractionTeachingExample> teachingExamples, DateTime createdAt, DateTime updatedAt, bool isDeleted
});




}
/// @nodoc
class __$ExtractionItemKindCopyWithImpl<$Res>
    implements _$ExtractionItemKindCopyWith<$Res> {
  __$ExtractionItemKindCopyWithImpl(this._self, this._then);

  final _ExtractionItemKind _self;
  final $Res Function(_ExtractionItemKind) _then;

/// Create a copy of ExtractionItemKind
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? slug = null,Object? displayName = null,Object? extractionHint = freezed,Object? behavior = null,Object? datePolicy = null,Object? notePolicy = null,Object? ownerPolicy = null,Object? enabledForExtraction = null,Object? isBuiltIn = null,Object? sortOrder = null,Object? teachingExamples = null,Object? createdAt = null,Object? updatedAt = null,Object? isDeleted = null,}) {
  return _then(_ExtractionItemKind(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,extractionHint: freezed == extractionHint ? _self.extractionHint : extractionHint // ignore: cast_nullable_to_non_nullable
as String?,behavior: null == behavior ? _self.behavior : behavior // ignore: cast_nullable_to_non_nullable
as ExtractionKindBehavior,datePolicy: null == datePolicy ? _self.datePolicy : datePolicy // ignore: cast_nullable_to_non_nullable
as ExtractionKindFieldPolicy,notePolicy: null == notePolicy ? _self.notePolicy : notePolicy // ignore: cast_nullable_to_non_nullable
as ExtractionKindFieldPolicy,ownerPolicy: null == ownerPolicy ? _self.ownerPolicy : ownerPolicy // ignore: cast_nullable_to_non_nullable
as ExtractionKindFieldPolicy,enabledForExtraction: null == enabledForExtraction ? _self.enabledForExtraction : enabledForExtraction // ignore: cast_nullable_to_non_nullable
as bool,isBuiltIn: null == isBuiltIn ? _self.isBuiltIn : isBuiltIn // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,teachingExamples: null == teachingExamples ? _self._teachingExamples : teachingExamples // ignore: cast_nullable_to_non_nullable
as List<ExtractionTeachingExample>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

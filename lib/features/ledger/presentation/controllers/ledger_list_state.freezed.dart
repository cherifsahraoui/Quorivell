// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ledger_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LedgerListState {

 String get query; LedgerKindFilter get kindFilter; LedgerStatusFilter get statusFilter; List<LedgerItem> get allItems; List<LedgerItem> get visibleItems;
/// Create a copy of LedgerListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LedgerListStateCopyWith<LedgerListState> get copyWith => _$LedgerListStateCopyWithImpl<LedgerListState>(this as LedgerListState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LedgerListState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LedgerListState&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.kindFilter, _this.kindFilter) || other.kindFilter == _this.kindFilter)&&(identical(other.statusFilter, _this.statusFilter) || other.statusFilter == _this.statusFilter)&&const DeepCollectionEquality().equals(other.allItems, _this.allItems)&&const DeepCollectionEquality().equals(other.visibleItems, _this.visibleItems));
}


@override
int get hashCode {
  final _this = this as LedgerListState;
  return Object.hash(runtimeType,_this.query,_this.kindFilter,_this.statusFilter,const DeepCollectionEquality().hash(_this.allItems),const DeepCollectionEquality().hash(_this.visibleItems));
}

@override
String toString() {
  final _this = this as LedgerListState;
  return 'LedgerListState(query: ${_this.query}, kindFilter: ${_this.kindFilter}, statusFilter: ${_this.statusFilter}, allItems: ${_this.allItems}, visibleItems: ${_this.visibleItems})';
}


}

/// @nodoc
abstract mixin class $LedgerListStateCopyWith<$Res>  {
  factory $LedgerListStateCopyWith(LedgerListState value, $Res Function(LedgerListState) _then) = _$LedgerListStateCopyWithImpl;
@useResult
$Res call({
 String query, LedgerKindFilter kindFilter, LedgerStatusFilter statusFilter, List<LedgerItem> allItems, List<LedgerItem> visibleItems
});




}
/// @nodoc
class _$LedgerListStateCopyWithImpl<$Res>
    implements $LedgerListStateCopyWith<$Res> {
  _$LedgerListStateCopyWithImpl(this._self, this._then);

  final LedgerListState _self;
  final $Res Function(LedgerListState) _then;

/// Create a copy of LedgerListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? kindFilter = null,Object? statusFilter = null,Object? allItems = null,Object? visibleItems = null,}) {
  return _then(LedgerListState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,kindFilter: null == kindFilter ? _self.kindFilter : kindFilter // ignore: cast_nullable_to_non_nullable
as LedgerKindFilter,statusFilter: null == statusFilter ? _self.statusFilter : statusFilter // ignore: cast_nullable_to_non_nullable
as LedgerStatusFilter,allItems: null == allItems ? _self.allItems : allItems // ignore: cast_nullable_to_non_nullable
as List<LedgerItem>,visibleItems: null == visibleItems ? _self.visibleItems : visibleItems // ignore: cast_nullable_to_non_nullable
as List<LedgerItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [LedgerListState].
extension LedgerListStatePatterns on LedgerListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LedgerListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LedgerListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LedgerListState value)  $default,){
final _that = this;
switch (_that) {
case _LedgerListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LedgerListState value)?  $default,){
final _that = this;
switch (_that) {
case _LedgerListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  LedgerKindFilter kindFilter,  LedgerStatusFilter statusFilter,  List<LedgerItem> allItems,  List<LedgerItem> visibleItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LedgerListState() when $default != null:
return $default(_that.query,_that.kindFilter,_that.statusFilter,_that.allItems,_that.visibleItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  LedgerKindFilter kindFilter,  LedgerStatusFilter statusFilter,  List<LedgerItem> allItems,  List<LedgerItem> visibleItems)  $default,) {final _that = this;
switch (_that) {
case _LedgerListState():
return $default(_that.query,_that.kindFilter,_that.statusFilter,_that.allItems,_that.visibleItems);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  LedgerKindFilter kindFilter,  LedgerStatusFilter statusFilter,  List<LedgerItem> allItems,  List<LedgerItem> visibleItems)?  $default,) {final _that = this;
switch (_that) {
case _LedgerListState() when $default != null:
return $default(_that.query,_that.kindFilter,_that.statusFilter,_that.allItems,_that.visibleItems);case _:
  return null;

}
}

}

/// @nodoc


class _LedgerListState extends LedgerListState {
  const _LedgerListState({required this.query, required this.kindFilter, required this.statusFilter, required  List<LedgerItem> allItems, required  List<LedgerItem> visibleItems}): _allItems = allItems,_visibleItems = visibleItems,super._();
  

@override final  String query;
@override final  LedgerKindFilter kindFilter;
@override final  LedgerStatusFilter statusFilter;
 final  List<LedgerItem> _allItems;
@override List<LedgerItem> get allItems {
  if (_allItems is EqualUnmodifiableListView) return _allItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allItems);
}

 final  List<LedgerItem> _visibleItems;
@override List<LedgerItem> get visibleItems {
  if (_visibleItems is EqualUnmodifiableListView) return _visibleItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_visibleItems);
}


/// Create a copy of LedgerListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LedgerListStateCopyWith<_LedgerListState> get copyWith => __$LedgerListStateCopyWithImpl<_LedgerListState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LedgerListState&&(identical(other.query, query) || other.query == query)&&(identical(other.kindFilter, kindFilter) || other.kindFilter == kindFilter)&&(identical(other.statusFilter, statusFilter) || other.statusFilter == statusFilter)&&const DeepCollectionEquality().equals(other.allItems, _allItems)&&const DeepCollectionEquality().equals(other.visibleItems, _visibleItems));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query,kindFilter,statusFilter,const DeepCollectionEquality().hash(_allItems),const DeepCollectionEquality().hash(_visibleItems));
}

@override
String toString() {
    return 'LedgerListState(query: $query, kindFilter: $kindFilter, statusFilter: $statusFilter, allItems: $allItems, visibleItems: $visibleItems)';
}


}

/// @nodoc
abstract mixin class _$LedgerListStateCopyWith<$Res> implements $LedgerListStateCopyWith<$Res> {
  factory _$LedgerListStateCopyWith(_LedgerListState value, $Res Function(_LedgerListState) _then) = __$LedgerListStateCopyWithImpl;
@override @useResult
$Res call({
 String query, LedgerKindFilter kindFilter, LedgerStatusFilter statusFilter, List<LedgerItem> allItems, List<LedgerItem> visibleItems
});




}
/// @nodoc
class __$LedgerListStateCopyWithImpl<$Res>
    implements _$LedgerListStateCopyWith<$Res> {
  __$LedgerListStateCopyWithImpl(this._self, this._then);

  final _LedgerListState _self;
  final $Res Function(_LedgerListState) _then;

/// Create a copy of LedgerListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? kindFilter = null,Object? statusFilter = null,Object? allItems = null,Object? visibleItems = null,}) {
  return _then(_LedgerListState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,kindFilter: null == kindFilter ? _self.kindFilter : kindFilter // ignore: cast_nullable_to_non_nullable
as LedgerKindFilter,statusFilter: null == statusFilter ? _self.statusFilter : statusFilter // ignore: cast_nullable_to_non_nullable
as LedgerStatusFilter,allItems: null == allItems ? _self._allItems : allItems // ignore: cast_nullable_to_non_nullable
as List<LedgerItem>,visibleItems: null == visibleItems ? _self._visibleItems : visibleItems // ignore: cast_nullable_to_non_nullable
as List<LedgerItem>,
  ));
}


}

// dart format on

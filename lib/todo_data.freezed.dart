// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Todo {
  String get description => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;

  /// Create a copy of Todo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TodoCopyWith<Todo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodoCopyWith<$Res> {
  factory $TodoCopyWith(Todo value, $Res Function(Todo) then) =
      _$TodoCopyWithImpl<$Res, Todo>;
  @useResult
  $Res call({String description, String id, bool completed});
}

/// @nodoc
class _$TodoCopyWithImpl<$Res, $Val extends Todo>
    implements $TodoCopyWith<$Res> {
  _$TodoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Todo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? id = null,
    Object? completed = null,
  }) {
    return _then(_value.copyWith(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TodoDataImplCopyWith<$Res> implements $TodoCopyWith<$Res> {
  factory _$$TodoDataImplCopyWith(
          _$TodoDataImpl value, $Res Function(_$TodoDataImpl) then) =
      __$$TodoDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String description, String id, bool completed});
}

/// @nodoc
class __$$TodoDataImplCopyWithImpl<$Res>
    extends _$TodoCopyWithImpl<$Res, _$TodoDataImpl>
    implements _$$TodoDataImplCopyWith<$Res> {
  __$$TodoDataImplCopyWithImpl(
      _$TodoDataImpl _value, $Res Function(_$TodoDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of Todo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? id = null,
    Object? completed = null,
  }) {
    return _then(_$TodoDataImpl(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$TodoDataImpl implements _TodoData {
  const _$TodoDataImpl(
      {required this.description, required this.id, this.completed = false});

  @override
  final String description;
  @override
  final String id;
  @override
  @JsonKey()
  final bool completed;

  @override
  String toString() {
    return 'Todo(description: $description, id: $id, completed: $completed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TodoDataImpl &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.completed, completed) ||
                other.completed == completed));
  }

  @override
  int get hashCode => Object.hash(runtimeType, description, id, completed);

  /// Create a copy of Todo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TodoDataImplCopyWith<_$TodoDataImpl> get copyWith =>
      __$$TodoDataImplCopyWithImpl<_$TodoDataImpl>(this, _$identity);
}

abstract class _TodoData implements Todo {
  const factory _TodoData(
      {required final String description,
      required final String id,
      final bool completed}) = _$TodoDataImpl;

  @override
  String get description;
  @override
  String get id;
  @override
  bool get completed;

  /// Create a copy of Todo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TodoDataImplCopyWith<_$TodoDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'splash_screen_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SplashScreenState {
  SplashScreenStatus get status => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SplashScreenStateCopyWith<SplashScreenState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SplashScreenStateCopyWith<$Res> {
  factory $SplashScreenStateCopyWith(
          SplashScreenState value, $Res Function(SplashScreenState) then) =
      _$SplashScreenStateCopyWithImpl<$Res, SplashScreenState>;
  @useResult
  $Res call({SplashScreenStatus status});
}

/// @nodoc
class _$SplashScreenStateCopyWithImpl<$Res, $Val extends SplashScreenState>
    implements $SplashScreenStateCopyWith<$Res> {
  _$SplashScreenStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SplashScreenStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SplashScreenStateImplCopyWith<$Res>
    implements $SplashScreenStateCopyWith<$Res> {
  factory _$$SplashScreenStateImplCopyWith(_$SplashScreenStateImpl value,
          $Res Function(_$SplashScreenStateImpl) then) =
      __$$SplashScreenStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SplashScreenStatus status});
}

/// @nodoc
class __$$SplashScreenStateImplCopyWithImpl<$Res>
    extends _$SplashScreenStateCopyWithImpl<$Res, _$SplashScreenStateImpl>
    implements _$$SplashScreenStateImplCopyWith<$Res> {
  __$$SplashScreenStateImplCopyWithImpl(_$SplashScreenStateImpl _value,
      $Res Function(_$SplashScreenStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
  }) {
    return _then(_$SplashScreenStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SplashScreenStatus,
    ));
  }
}

/// @nodoc

class _$SplashScreenStateImpl implements _SplashScreenState {
  const _$SplashScreenStateImpl({this.status = SplashScreenStatus.starting});

  @override
  @JsonKey()
  final SplashScreenStatus status;

  @override
  String toString() {
    return 'SplashScreenState(status: $status)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SplashScreenStateImpl &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SplashScreenStateImplCopyWith<_$SplashScreenStateImpl> get copyWith =>
      __$$SplashScreenStateImplCopyWithImpl<_$SplashScreenStateImpl>(
          this, _$identity);
}

abstract class _SplashScreenState implements SplashScreenState {
  const factory _SplashScreenState({final SplashScreenStatus status}) =
      _$SplashScreenStateImpl;

  @override
  SplashScreenStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$SplashScreenStateImplCopyWith<_$SplashScreenStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

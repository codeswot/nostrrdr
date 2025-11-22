// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nostr_relay_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$NostrRelayState {
  String get relay => throw _privateConstructorUsedError;
  bool get connected => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of NostrRelayState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NostrRelayStateCopyWith<NostrRelayState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NostrRelayStateCopyWith<$Res> {
  factory $NostrRelayStateCopyWith(
    NostrRelayState value,
    $Res Function(NostrRelayState) then,
  ) = _$NostrRelayStateCopyWithImpl<$Res, NostrRelayState>;
  @useResult
  $Res call({String relay, bool connected, String? error});
}

/// @nodoc
class _$NostrRelayStateCopyWithImpl<$Res, $Val extends NostrRelayState>
    implements $NostrRelayStateCopyWith<$Res> {
  _$NostrRelayStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NostrRelayState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? relay = null,
    Object? connected = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            relay: null == relay
                ? _value.relay
                : relay // ignore: cast_nullable_to_non_nullable
                      as String,
            connected: null == connected
                ? _value.connected
                : connected // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NostrRelayStateImplCopyWith<$Res>
    implements $NostrRelayStateCopyWith<$Res> {
  factory _$$NostrRelayStateImplCopyWith(
    _$NostrRelayStateImpl value,
    $Res Function(_$NostrRelayStateImpl) then,
  ) = __$$NostrRelayStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String relay, bool connected, String? error});
}

/// @nodoc
class __$$NostrRelayStateImplCopyWithImpl<$Res>
    extends _$NostrRelayStateCopyWithImpl<$Res, _$NostrRelayStateImpl>
    implements _$$NostrRelayStateImplCopyWith<$Res> {
  __$$NostrRelayStateImplCopyWithImpl(
    _$NostrRelayStateImpl _value,
    $Res Function(_$NostrRelayStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NostrRelayState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? relay = null,
    Object? connected = null,
    Object? error = freezed,
  }) {
    return _then(
      _$NostrRelayStateImpl(
        relay: null == relay
            ? _value.relay
            : relay // ignore: cast_nullable_to_non_nullable
                  as String,
        connected: null == connected
            ? _value.connected
            : connected // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$NostrRelayStateImpl implements _NostrRelayState {
  const _$NostrRelayStateImpl({
    required this.relay,
    this.connected = false,
    this.error,
  });

  @override
  final String relay;
  @override
  @JsonKey()
  final bool connected;
  @override
  final String? error;

  @override
  String toString() {
    return 'NostrRelayState(relay: $relay, connected: $connected, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NostrRelayStateImpl &&
            (identical(other.relay, relay) || other.relay == relay) &&
            (identical(other.connected, connected) ||
                other.connected == connected) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, relay, connected, error);

  /// Create a copy of NostrRelayState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NostrRelayStateImplCopyWith<_$NostrRelayStateImpl> get copyWith =>
      __$$NostrRelayStateImplCopyWithImpl<_$NostrRelayStateImpl>(
        this,
        _$identity,
      );
}

abstract class _NostrRelayState implements NostrRelayState {
  const factory _NostrRelayState({
    required final String relay,
    final bool connected,
    final String? error,
  }) = _$NostrRelayStateImpl;

  @override
  String get relay;
  @override
  bool get connected;
  @override
  String? get error;

  /// Create a copy of NostrRelayState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NostrRelayStateImplCopyWith<_$NostrRelayStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

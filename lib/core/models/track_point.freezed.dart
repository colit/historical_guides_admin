// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'track_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TrackPoint _$TrackPointFromJson(Map<String, dynamic> json) {
  return _TrackPoint.fromJson(json);
}

/// @nodoc
class _$TrackPointTearOff {
  const _$TrackPointTearOff();

  _TrackPoint call(
      {required double latitude,
      required double longitude,
      double? elevation}) {
    return _TrackPoint(
      latitude: latitude,
      longitude: longitude,
      elevation: elevation,
    );
  }

  TrackPoint fromJson(Map<String, Object?> json) {
    return TrackPoint.fromJson(json);
  }
}

/// @nodoc
const $TrackPoint = _$TrackPointTearOff();

/// @nodoc
mixin _$TrackPoint {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double? get elevation => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TrackPointCopyWith<TrackPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrackPointCopyWith<$Res> {
  factory $TrackPointCopyWith(
          TrackPoint value, $Res Function(TrackPoint) then) =
      _$TrackPointCopyWithImpl<$Res>;
  $Res call({double latitude, double longitude, double? elevation});
}

/// @nodoc
class _$TrackPointCopyWithImpl<$Res> implements $TrackPointCopyWith<$Res> {
  _$TrackPointCopyWithImpl(this._value, this._then);

  final TrackPoint _value;
  // ignore: unused_field
  final $Res Function(TrackPoint) _then;

  @override
  $Res call({
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? elevation = freezed,
  }) {
    return _then(_value.copyWith(
      latitude: latitude == freezed
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: longitude == freezed
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      elevation: elevation == freezed
          ? _value.elevation
          : elevation // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
abstract class _$TrackPointCopyWith<$Res> implements $TrackPointCopyWith<$Res> {
  factory _$TrackPointCopyWith(
          _TrackPoint value, $Res Function(_TrackPoint) then) =
      __$TrackPointCopyWithImpl<$Res>;
  @override
  $Res call({double latitude, double longitude, double? elevation});
}

/// @nodoc
class __$TrackPointCopyWithImpl<$Res> extends _$TrackPointCopyWithImpl<$Res>
    implements _$TrackPointCopyWith<$Res> {
  __$TrackPointCopyWithImpl(
      _TrackPoint _value, $Res Function(_TrackPoint) _then)
      : super(_value, (v) => _then(v as _TrackPoint));

  @override
  _TrackPoint get _value => super._value as _TrackPoint;

  @override
  $Res call({
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? elevation = freezed,
  }) {
    return _then(_TrackPoint(
      latitude: latitude == freezed
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: longitude == freezed
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      elevation: elevation == freezed
          ? _value.elevation
          : elevation // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TrackPoint implements _TrackPoint {
  _$_TrackPoint(
      {required this.latitude, required this.longitude, this.elevation});

  factory _$_TrackPoint.fromJson(Map<String, dynamic> json) =>
      _$$_TrackPointFromJson(json);

  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double? elevation;

  @override
  String toString() {
    return 'TrackPoint(latitude: $latitude, longitude: $longitude, elevation: $elevation)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TrackPoint &&
            const DeepCollectionEquality().equals(other.latitude, latitude) &&
            const DeepCollectionEquality().equals(other.longitude, longitude) &&
            const DeepCollectionEquality().equals(other.elevation, elevation));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(latitude),
      const DeepCollectionEquality().hash(longitude),
      const DeepCollectionEquality().hash(elevation));

  @JsonKey(ignore: true)
  @override
  _$TrackPointCopyWith<_TrackPoint> get copyWith =>
      __$TrackPointCopyWithImpl<_TrackPoint>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TrackPointToJson(this);
  }
}

abstract class _TrackPoint implements TrackPoint {
  factory _TrackPoint(
      {required double latitude,
      required double longitude,
      double? elevation}) = _$_TrackPoint;

  factory _TrackPoint.fromJson(Map<String, dynamic> json) =
      _$_TrackPoint.fromJson;

  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double? get elevation;
  @override
  @JsonKey(ignore: true)
  _$TrackPointCopyWith<_TrackPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'track_point.freezed.dart';
part 'track_point.g.dart';

@freezed
class TrackPoint with _$TrackPoint {
  factory TrackPoint({
    required double latitude,
    required double longitude,
    double? elevation,
  }) = _TrackPoint;

  factory TrackPoint.fromJson(Map<String, dynamic> json) =>
      _$TrackPointFromJson(json);
}

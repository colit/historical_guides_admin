import 'package:freezed_annotation/freezed_annotation.dart';

import 'track_point.dart';

part 'track.freezed.dart';
part 'track.g.dart';

@freezed
class Track with _$Track {
  factory Track({required String name, @Default([]) List<TrackPoint> points}) =
      _Track;

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);
}

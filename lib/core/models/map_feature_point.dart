import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:latlong2/latlong.dart' as lat_long;

class MapFeaturePoint {
  MapFeaturePoint({
    required this.id,
    required this.position,
  });
  final String id;
  final LatLng position;

  lat_long.LatLng get positionLatLong => lat_long.LatLng(
        position.latitude,
        position.longitude,
      );

  MapFeaturePoint copyWith({LatLng? position}) {
    return MapFeaturePoint(
      id: id,
      position: position ?? this.position,
    );
  }
}

import 'package:mapbox_gl/mapbox_gl.dart';

class MapFeaturePoint {
  MapFeaturePoint({
    required this.id,
    required this.position,
  });
  final String id;
  final LatLng position;
}

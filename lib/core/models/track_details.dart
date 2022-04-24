import 'package:geojson_vi/geojson_vi.dart';
import 'package:gpx/gpx.dart';
import 'package:historical_guides_admin/core/models/track_point.dart';
import 'package:latlong2/latlong.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';

class TrackDetails extends Object {
  TrackDetails(
    String xml,
  ) : gpx = GpxReader().fromString(xml);
  // final String xml;

  final Gpx gpx;

  late final List<TrackPoint> _points = [
    for (final trc in gpx.trks)
      for (final seg in trc.trksegs)
        for (final pt in seg.trkpts)
          if (pt.lat != null && pt.lon != null)
            TrackPoint(
              latitude: pt.lat!,
              longitude: pt.lon!,
              elevation: pt.ele,
            )
  ];

  String gpxToString() {
    gpx.creator = 'Piligrim App';
    final metadata = Metadata(name: 'Kulturpfad');
    gpx.metadata = metadata;
    final w = GpxWriter().asXml(gpx);
    return w.toXmlString();
  }

  LatLng get startPoint {
    return LatLng(_points.first.latitude, _points.first.longitude);
  }

  List<LatLng> get bounds {
    double latSW = double.infinity;
    double lngSW = double.infinity;
    double latNE = 0;
    double lngNE = 0;
    for (final point in _points) {
      if (point.latitude > latNE) {
        latNE = point.latitude;
      }
      if (point.longitude > lngNE) {
        lngNE = point.longitude;
      }
      if (point.latitude < latSW) {
        latSW = point.latitude;
      }
      if (point.longitude < lngSW) {
        lngSW = point.longitude;
      }
    }
    return [
      LatLng(latSW, lngSW),
      LatLng(latNE, lngNE),
    ];
  }

  double get length {
    if (_points.isEmpty) return 0;
    const distance = Distance();
    double output = 0;
    var firstPoint = startPoint;
    for (final point in _points) {
      final secondPoint = LatLng(point.latitude, point.longitude);
      output += distance(
        firstPoint,
        secondPoint,
      );
      firstPoint = secondPoint;
    }
    return output / 1000;
  }

  String get asGeoJSON {
    final points = [
      for (final point in _points)
        [point.longitude, point.latitude, point.elevation]
    ];
    final map = {
      'type': 'MultiLineString',
      'coordinates': [points],
    };
    final lines = GeoJSONGeometry.fromMap(map);
    final features = GeoJSONFeature(
      lines,
      properties: {
        'title': gpx.metadata?.name,
        'url': 'http://piligrim.consta.de',
      },
    );
    final featureCollection = GeoJSONFeatureCollection([features]);
    return featureCollection.toJSON();
  }
}

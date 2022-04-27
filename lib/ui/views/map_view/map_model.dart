import 'dart:math';

import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../../core/services/data_service.dart';
import '../../../core/services/map_service.dart';

class MapModel extends BaseModel {
  MapModel({
    required MapService mapService,
    required DataService dataService,
  })  : _mapService = mapService,
        _dataService = dataService {
    _mapService.addListener(_onMapUpdated);
    _dataService.addListener(_onDataUpdated);
  }

  // late final String _tourId;

  MapboxMapController? _controller;

  final MapService _mapService;
  final DataService _dataService;

  LatLng get currentPosition => _mapService.mapPosition;

  double get currentZoom => 15;

  get currentStyle => 'mapbox://styles/consta/cl1ntkeuh000814p61hbxkegk';

  Circle? _circle;

  bool _trackAdded = false;
  bool _pointsAdded = false;

  void _onDataUpdated() {
    final source = _dataService.currentTour?.poisAsGeoJson;
    _controller?.setGeoJsonSource('map_points_source', source!);
    // print(_dataService.currentTour?.poisAsGeoJson ?? 'no tour found');
    // print(_dataService.currentTour?.geoJSON ?? 'no track found');
    // final source = _dataService.currentTour?.poisAsGeoJson;
    // if (source != null) {
    //   _controller?.setGeoJsonSource('kPhotoSourceId', source);
    // }
    // if (_dataService.currentTour?.geoJSON != null && !_trackAdded) {
    //   _addTrackSource();
    // }
  }

  void _onMapUpdated() {
    if (_controller == null) return;

    if (_dataService.currentTour?.geoJSON != null && !_trackAdded) {
      _addTrackSource();
    }

    final source = _dataService.currentTour?.poisAsGeoJson;
    print('source: $source');

    if (source != null) {
      if (!_pointsAdded) {
        _controller
            ?.addSource(
                'map_points_source', GeojsonSourceProperties(data: source))
            .then((_) {
          _controller?.addLayer(
            'map_points_source',
            'points',
            const CircleLayerProperties(
                circleColor: '#003366', circleRadius: 10),
          );
          _pointsAdded = true;
        });
      } else {
        _controller?.setGeoJsonSource('map_points_source', source);
      }
    }

    final bounds = _mapService.mapBounds;
    if (bounds != null) {
      _controller!
          .animateCamera(CameraUpdate.newLatLngBounds(bounds))
          .then((success) {
        if (success ?? false) {
          _mapService.cleanBounds();
        }
      });
    }

    if (!_mapService.acivePointEditing && _circle != null) {
      _controller!.removeCircle(_circle!);
      _circle = null;
    }

    if (_mapService.pointToCreate != null && _circle == null) {
      _controller!
          .addCircle(
        CircleOptions(
            geometry: _mapService.pointToCreate!.position,
            circleColor: "#FF0000",
            draggable: true,
            circleRadius: 20),
      )
          .then((value) {
        _circle = value;
      });
    }
  }

  void _onFeatureDrag(
    id, {
    required LatLng current,
    required LatLng delta,
    required LatLng origin,
    required Point<double> point,
  }) {
    final position = _circle?.options.geometry;
    if (position != null) {
      _mapService.updateCurrentPoint(id, position);
    }
  }

  Future<void> _addTrackSource() async {
    if (_controller == null) return;
    await _controller!.addSource(
      'map_track_source',
      GeojsonSourceProperties(data: _dataService.currentTour?.geoJSON),
    );
    _createLayers();
    print('_addTrackSource(); ${_dataService.currentTour?.geoJSON}');
    _trackAdded = true;
  }

  Future<void> _addPointsSource() async {
    if (_controller != null) {
      await _controller!.addSource(
        'kPhotoSourceId',
        const GeojsonSourceProperties(
          maxzoom: 14.5,
        ),
      );
    }
  }

  Future<void> _createLayers() async {
    // create track line

    await _controller!.addLayer(
      'map_track_source',
      "track-line-white",
      const LineLayerProperties(
        lineColor: '#FFFFFF',
        lineWidth: 9.0,
      ),
    );

    // Symbols Layer
    await _controller!.addLayer(
      'kPhotoSourceId',
      "photo-points-white",
      const CircleLayerProperties(
        circleColor: '#FFFFFF',
        circleRadius: 16,
      ),
    );

    // create track line
    await _controller!.addLayer(
      'map_track_source',
      "track-line",
      const LineLayerProperties(
        lineColor: '#018b00',
        lineWidth: 3.0,
      ),
    );

    // Symbols Layer
    await _controller!.addLayer(
      'kPhotoSourceId',
      "photo-points",
      const CircleLayerProperties(
        circleColor: '#003366',
        circleRadius: 10,
      ),
    );
  }

  void onMapCreated(MapboxMapController controller) {
    _controller = controller;
  }

  void onMapClick(Point<double> point, LatLng position) {
    if (_mapService.addPointEnabled && _controller != null) {
      if (_circle == null) {
        _controller!
            .addCircle(
          CircleOptions(
              geometry: position,
              circleColor: "#FF0000",
              draggable: true,
              circleRadius: 20),
        )
            .then((value) {
          _circle = value;
          _mapService.updateCurrentPoint(
            _circle!.id,
            position,
          );
        });
      } else {
        _controller!.updateCircle(
          _circle!,
          CircleOptions(geometry: position),
        );
        _mapService.updateCurrentPoint(
          _circle!.id,
          position,
        );
      }
    }
  }

  void onCameraIdle() {
    final cameraPosition = _controller?.cameraPosition;
    if (cameraPosition != null) {
      _mapService.updateCameraPosition(cameraPosition.target);
    }
  }

  void onStyleLoadedCallback() {
    print('onStyleLoade');
    _controller!.onFeatureDrag.add(_onFeatureDrag);
    _controller!.onFeatureTapped.add((id, point, coordinates) {
      print('feature tapped: $point');
      _controller!.queryRenderedFeatures(point, ['points'], null).then((value) {
        print('value: $value');
        if (value.isNotEmpty) {
          final geojson = value.first;
          final uuid = geojson['properties']['uuid'] as int;
          print('uuid: $uuid');
          final coordinates = List<double>.from(
            geojson['geometry']['coordinates'],
          );
          final position = LatLng(coordinates[1], coordinates[0]);
          _controller!.animateCamera(CameraUpdate.newLatLng(position));
        }
      });
    });
  }

  @override
  void dispose() {
    _mapService.removeListener(_onMapUpdated);
    _dataService.removeListener(_onDataUpdated);
    super.dispose();
  }
}

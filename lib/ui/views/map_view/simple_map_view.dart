import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:historical_guides_admin/core/services/data_service.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';

import '../../../core/services/map_service.dart';

class SimpleMapView extends StatefulWidget {
  static const double zoomPadding = 60;
  const SimpleMapView({
    Key? key,
    required this.onMapReady,
  }) : super(key: key);

  final void Function()? onMapReady;

  @override
  State<SimpleMapView> createState() => _SimpleMapViewState();
}

class _SimpleMapViewState extends State<SimpleMapView> {
  late final _mapService = context.read<MapService>();
  late final _dataService = context.read<DataService>();

  late final MapboxMapController _mapController;

  Circle? circle;
  bool _trackAdded = false;

  void _onMapReady() {
    widget.onMapReady?.call();
    _mapController.onFeatureDrag.add(_onFeatureDrag);
  }

  void _onMapIdle() {
    final cameraPosition = _mapController.cameraPosition;
    if (cameraPosition != null) {
      _mapService.updateCameraPosition(cameraPosition.target);
    }
  }

  void _onMapClick(Point<double> point, LatLng coordinates) {
    _mapService.updateCurrentPoint(coordinates);
  }

  void _onFeatureDrag(
    id, {
    required LatLng current,
    required LatLng delta,
    required DragEventType eventType,
    required LatLng origin,
    required Point<double> point,
  }) {
    final position = circle?.options.geometry;
    if (position != null) {
      _mapService.updateCurrentPoint(position);
    }
  }

  void _onMapUpdate() {
    // Add track
    if (_dataService.currentTour?.geoJSON != null && !_trackAdded) {
      _addTrackSource();
    }
    // Update current editable point on map
    if (_mapService.pointToCreate != null && circle == null) {
      // place cirle
      final pointPosition = _mapService.pointToCreate!.position;
      _mapController
          .addCircle(
            CircleOptions(
                geometry: pointPosition,
                circleColor: "#FF0000",
                draggable: true,
                circleRadius: 20),
          )
          .then((value) => circle = value);
      _mapController
          .animateCamera(CameraUpdate.newLatLngZoom(pointPosition, 17));
    } else if (_mapService.pointToCreate == null && circle != null) {
      // remove circle
      _mapController.removeCircle(circle!).then((_) => circle = null);
    } else if (_mapService.pointToCreate != null && circle != null) {
      // update circle
      _mapController.updateCircle(
          circle!,
          CircleOptions(
            geometry: _mapService.pointToCreate!.position,
          ));
    }
    // zoom map
    final bounds = _mapService.mapBounds;
    if (bounds != null) {
      _mapController
          .animateCamera(CameraUpdate.newLatLngBounds(
        bounds,
        left: SimpleMapView.zoomPadding,
        right: SimpleMapView.zoomPadding,
        top: SimpleMapView.zoomPadding,
        bottom: SimpleMapView.zoomPadding,
      ))
          .then((success) {
        if (success ?? false) {
          _mapService.cleanBounds();
        }
      });
    }
  }

  Future<void> _addTrackSource() async {
    await _mapController.addSource(
      'map_track_source',
      GeojsonSourceProperties(data: _dataService.currentTour?.geoJSON),
    );
    _trackAdded = true;
    _createLayers();
  }

  Future<void> _createLayers() async {
    // create track line

    await _mapController.addLayer(
      'map_track_source',
      'track-line-white',
      const LineLayerProperties(
        lineColor: '#FFFFFF',
        lineWidth: 9.0,
      ),
    );

    // Symbols Layer
    await _mapController.addLayer(
      'kPhotoSourceId',
      'photo-points-white',
      const CircleLayerProperties(
        circleColor: '#FFFFFF',
        circleRadius: 16,
      ),
    );

    // create track line
    await _mapController.addLayer(
      'map_track_source',
      "track-line",
      const LineLayerProperties(
        lineColor: '#018b00',
        lineWidth: 3.0,
      ),
    );

    // Symbols Layer
    await _mapController.addLayer(
      'kPhotoSourceId',
      "photo-points",
      const CircleLayerProperties(
        circleColor: '#003366',
        circleRadius: 10,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    _mapService.addListener(_onMapUpdate);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MapboxMap(
      accessToken: dotenv.env['ACCESS_TOKEN']!,
      onMapCreated: (controller) {
        _mapController = controller;
      },
      onStyleLoadedCallback: _onMapReady,
      onCameraIdle: _onMapIdle,
      onMapClick: _onMapClick,
      initialCameraPosition: CameraPosition(
        target: _mapService.mapPosition,
        zoom: 17,
      ),
      styleString: 'mapbox://styles/consta/cl1ntkeuh000814p61hbxkegk',
      // onCameraIdle: model.onCameraIdle,
    );
  }
}

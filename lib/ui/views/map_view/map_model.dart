import 'dart:math';

import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../../core/services/map_service.dart';

class MapModel extends BaseModel {
  MapModel({required MapService mapService}) : _mapService = mapService {
    _mapService.addListener(_onMapUpdated);
  }

  MapboxMapController? _controller;
  late final String _tourId;

  final MapService _mapService;
  LatLng get currentPosition => _mapService.mapPosition;

  double get currentZoom => 15;

  get currentStyle => null;

  Circle? _circle;

  void _onMapUpdated() {
    if (_controller == null) return;

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

    if (!_mapService.acivePointEditing && _circle != null) {
      _controller!.removeCircle(_circle!);
      _circle = null;
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
  }

  void _onFeatureDrag(
    id, {
    required LatLng current,
    required LatLng delta,
    required LatLng origin,
    required Point<double> point,
  }) {
    _mapService.updateCurrentPoint(id, current);
  }

  void onMapCreated(MapboxMapController controller) {
    _controller = controller;
    _controller!.onFeatureDrag.add(_onFeatureDrag);
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

  @override
  void dispose() {
    _mapService.removeListener(_onMapUpdated);
    super.dispose();
  }

  void onCameraIdle() {
    final cameraPosition = _controller?.cameraPosition;
    if (cameraPosition != null) {
      _mapService.updateCameraPosition(cameraPosition.target);
    }
  }
}

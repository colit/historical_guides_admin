import 'dart:async';

import 'package:flutter/material.dart';
import 'package:historical_guides_admin/core/models/map_feature_point.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';

class MapService extends ChangeNotifier {
  bool _addPointEnabled = false;
  bool get addPointEnabled => _addPointEnabled;
  MapFeaturePoint? _currentPoint;
  LatLng? _boundsNE;
  LatLng? _boundsSW;
  LatLng _mapPosition = const LatLng(50.941303, 6.958138);

  LatLng get mapPosition => _mapPosition;
  MapFeaturePoint? get pointToCreate => _currentPoint;

  final _currentPointStreamController = StreamController<MapFeaturePoint?>();
  Stream<MapFeaturePoint?> get currentPoint =>
      _currentPointStreamController.stream;

  bool get acivePointEditing => _currentPoint != null;

  LatLngBounds? get mapBounds {
    if (_boundsNE == null || _boundsSW == null) return null;
    return LatLngBounds(
      northeast: _boundsNE!,
      southwest: _boundsSW!,
    );
  }

  void enablePointsEdit() {
    _addPointEnabled = true;
  }

  void disablePoints() {
    _addPointEnabled = false;
  }

  void showPoint(String id, double latitude, double longitude) {
    _currentPoint = MapFeaturePoint(
      id: id,
      position: LatLng(latitude, longitude),
    );

    _currentPointStreamController.add(_currentPoint);
    notifyListeners();
  }

  void createPoint() {
    _currentPoint = MapFeaturePoint(
      id: 'new_${DateTime.now().millisecondsSinceEpoch}',
      position: _mapPosition,
    );
    _currentPointStreamController.add(_currentPoint);
    notifyListeners();
  }

  void updateCurrentPoint(LatLng current) {
    if (_currentPoint == null) return;
    _currentPoint = _currentPoint!.copyWith(
      position: current,
    );
    notifyListeners();
    _currentPointStreamController.add(_currentPoint);
  }

  void removePoint() {
    _currentPoint = null;
    _currentPointStreamController.add(_currentPoint);
    notifyListeners();
  }

  void onLeaveEditorPage() {
    removePoint();
    disablePoints();
  }

  void updateCameraPosition(LatLng position) {
    _mapPosition = position;
  }

  void setBounds(Tour tour) {
    _boundsNE = LatLng(tour.boundsNE.latitude, tour.boundsNE.longitude);
    _boundsSW = LatLng(tour.boundsSW.latitude, tour.boundsSW.longitude);
    notifyListeners();
  }

  void cleanBounds() {
    _boundsNE = null;
    _boundsSW = null;
  }
}

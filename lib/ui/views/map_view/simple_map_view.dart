import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';

import '../../../core/services/map_service.dart';

class SimpleMapView extends StatefulWidget {
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
  late final MapboxMapController _mapController;

  Circle? circle;

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

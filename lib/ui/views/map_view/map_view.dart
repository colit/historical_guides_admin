import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:historical_guides_admin/core/services/map_service.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';

import '../../../core/services/data_service.dart';
import 'map_model.dart';

class MapView extends StatelessWidget {
  const MapView({
    Key? key,
    required this.onMapReady,
  }) : super(key: key);

  final void Function()? onMapReady;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<MapModel>(
        model: MapModel(
          mapService: context.read<MapService>(),
          dataService: context.read<DataService>(),
        ),
        builder: (context, model, child) {
          return MapboxMap(
            accessToken: dotenv.env['ACCESS_TOKEN']!,
            onMapCreated: (controller) => model.onMapCreated(controller),
            onStyleLoadedCallback: () {
              model.onStyleLoadedCallback();
              onMapReady?.call();
            }, //model.onMapIdle,
            onMapClick: model.onMapClick,
            initialCameraPosition: CameraPosition(
              target: model.currentPosition,
              zoom: model.currentZoom,
            ),
            styleString: model.currentStyle,
            onCameraIdle: model.onCameraIdle,
          );
        });
  }
}

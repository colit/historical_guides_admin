import 'package:flutter/material.dart';
import 'package:historical_guides_admin/core/services/map_service.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class StationPositionView extends StatelessWidget {
  const StationPositionView({
    Key? key,
    this.id,
    this.position,
    this.removable = false,
  })  : assert((id == null && position == null) ||
            (id != null && position != null)),
        super(key: key);

  final String? id;
  final LatLng? position;
  final bool removable;

  @override
  Widget build(BuildContext context) {
    final pointOnMap = id != null;
    return Row(
      children: [
        Icon(pointOnMap ? Icons.location_on : Icons.location_on_outlined),
        Expanded(
          child: pointOnMap
              ? Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(position!.latitude.toStringAsFixed(6)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(position!.longitude.toStringAsFixed(6)),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      context.read<MapService>().createPoint();
                    },
                    child: const Text('Marker platzieren'),
                  ),
                ),
        ),
        if (removable)
          RoundIconButton(
            icon: const Icon(Icons.close),
            onTap: () {
              context.read<MapService>().removePoint();
            },
          ),
      ],
    );
  }
}

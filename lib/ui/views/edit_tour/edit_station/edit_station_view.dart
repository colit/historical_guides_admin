import 'package:flutter/material.dart';
import 'package:historical_guides_admin/core/editor_state.dart';
import 'package:historical_guides_admin/core/models/map_feature_point.dart';
import 'package:historical_guides_admin/core/services/data_service.dart';
import 'package:historical_guides_admin/ui/widgets/text_input_widget.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/map_service.dart';
import 'station_details/station_photos_view.dart';
import 'station_details/station_position_view.dart';

class EditStationView extends StatefulWidget {
  const EditStationView({
    Key? key,
    this.station,
  }) : super(key: key);

  final Station? station;

  @override
  State<EditStationView> createState() => _EditStationViewState();
}

class _EditStationViewState extends State<EditStationView> {
  late final MapService _mapService = context.read<MapService>();

  late Station station;
  bool readyToSave = false;
  bool creatingNewPoint = false;

  void _onWidgetReady(Duration timestamp) {
    _mapService.enablePointsEdit();
    if (widget.station != null) {
      final station = widget.station!;
      _mapService.showPoint(
        station.id,
        station.position.latitude,
        station.position.longitude,
      );
    }
  }

  @override
  void initState() {
    station = widget.station ?? Station.empty;
    creatingNewPoint = widget.station == null;
    WidgetsBinding.instance.addPostFrameCallback(_onWidgetReady);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Station'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(UIHelper.kHorizontalSpaceMedium),
        child: Consumer<MapFeaturePoint?>(
          builder: (context, currentPoint, child) {
            final pointOnMap = currentPoint != null;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StationPositionView(
                  id: currentPoint?.id,
                  position: currentPoint?.positionLatLong,
                  removable: creatingNewPoint,
                ),
                UIHelper.verticalSpaceSmall(),
                TextInputWidget(
                  value: station.titel,
                  onChange: (value) {
                    station = station.copyWith(titel: value);
                    setState(() {
                      readyToSave = value.isNotEmpty;
                    });
                  },
                  labelText: 'Name',
                ),
                TextInputWidget(
                  value: station.description ?? '',
                  onChange: (value) {
                    station = station.copyWith(description: value);
                  },
                  maxLines: 20,
                  labelText: 'Beschreibung',
                ),
                if (pointOnMap)
                  StationImagesView(
                    images: station.images,
                    latitude: currentPoint.position.latitude,
                    longitude: currentPoint.position.longitude,
                    onImagesUpdate: (value) {
                      station = station.copyWith(images: value);
                      setState(() {
                        readyToSave = true;
                      });
                    },
                  ),
                UIHelper.verticalSpaceSmall(),
                ElevatedButton(
                  onPressed: readyToSave && pointOnMap
                      ? () {
                          station = station.copyWith(
                              position: currentPoint.positionLatLong);
                          context
                              .read<DataService>()
                              .saveStation(
                                station.copyWith(
                                  position: currentPoint.positionLatLong,
                                ),
                                createNew: creatingNewPoint,
                              )
                              .then((_) {
                            context.read<EditorState>().popPage();
                          });
                        }
                      : null,
                  child: const Text('Station speichern'),
                ),
                if (widget.station != null) ...[
                  UIHelper.verticalSpaceSmall(),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Station löschen'),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

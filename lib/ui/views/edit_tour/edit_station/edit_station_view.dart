import 'package:flutter/material.dart';
import 'package:historical_guides_admin/core/editor_state.dart';
import 'package:historical_guides_admin/core/models/feature_point.dart';
import 'package:historical_guides_admin/core/services/modal_view_service.dart';
import 'package:historical_guides_admin/ui/views/edit_tour/edit_station/photo_selector/photo_selector_view.dart';
import 'package:historical_guides_admin/ui/widgets/round_icon_button.dart';
import 'package:historical_guides_admin/ui/widgets/text_input_widget.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/data_service.dart';
import '../../../../core/services/map_service.dart';
import 'edit_station_model.dart';
import 'photo_selector/image_thumbnail_widget.dart';

class EditStationView extends StatelessWidget {
  const EditStationView({
    Key? key,
    this.station,
  }) : super(key: key);

  final Station? station;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<EditStationModel>(
      model: EditStationModel(
        mapService: context.read<MapService>(),
        dataService: context.read<DataService>(),
        editorState: context.read<EditorState>(),
      ),
      onModelReady: (model) => model.initModelWith(station),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Station'),
          ),
          floatingActionButton: model.editComplete || !model.pointRemovable
              ? FloatingActionButton(
                  child: const Icon(Icons.update),
                  onPressed: model.savePoint,
                )
              : null,
          body: Consumer<MapFeaturePoint?>(
            builder: (context, value, child) {
              final pointOnMap = value != null;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(UIHelper.kHorizontalSpaceMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(pointOnMap
                            ? Icons.location_on
                            : Icons.location_on_outlined),
                        Expanded(
                          child: pointOnMap
                              ? Wrap(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(value.position.latitude
                                          .toStringAsFixed(6)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(value.position.longitude
                                          .toStringAsFixed(6)),
                                    ),
                                  ],
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                    onPressed: () => model.addPoint(),
                                    child: const Text('Marker platzieren'),
                                  ),
                                ),
                        ),
                        if (pointOnMap && model.pointRemovable)
                          RoundIconButton(
                            icon: const Icon(Icons.close),
                            onTap: () => model.removePoint(),
                          ),
                      ],
                    ),
                    UIHelper.verticalSpaceSmall(),
                    TextInputWidget(
                      value: model.titel,
                      onChange: model.onChangeTitel,
                      labelText: 'Name',
                    ),
                    TextInputWidget(
                      value: model.description,
                      onChange: model.onChangeDescription,
                      maxLines: 20,
                      labelText: 'Beschreibung',
                    ),
                    if (model.images.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: model.images.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                mainAxisSpacing: UIHelper.kHorizontalSpaceSmall,
                                crossAxisSpacing: UIHelper.kVerticalSpaceSmall,
                                maxCrossAxisExtent: 100.0),
                        itemBuilder: (context, index) => ImageThumbnailWidget(
                          onTap: () {},
                          image: model.images[index],
                        ),
                      ),
                    UIHelper.verticalSpaceSmall(),
                    ElevatedButton(
                      onPressed: () {
                        if (value != null) {
                          context.read<ModalViewService>().show(
                                PhotoSelectorView(
                                  station: value,
                                  onSelectImage: (image) =>
                                      model.addImage(image),
                                ),
                              );
                        }
                      },
                      child: const Text('Weitere Fotos hinzufügen'),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

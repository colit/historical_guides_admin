import 'package:flutter/material.dart';
import 'package:historical_guides_admin/core/editor_state.dart';
import 'package:historical_guides_admin/core/models/feature_point.dart';
import 'package:historical_guides_admin/ui/widgets/round_icon_button.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/data_service.dart';
import '../../../../core/services/map_service.dart';
import 'edit_poi_model.dart';

class EditPoIView extends StatelessWidget {
  const EditPoIView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<EditPoIModel>(
      model: EditPoIModel(
        mapService: context.read<MapService>(),
        dataService: context.read<DataService>(),
        editorState: context.read<EditorState>(),
      ),
      onModelReady: (model) => model.createPoint(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit PoI'),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: model.editComplete ? model.savePoint : null,
          ),
          body: Consumer<MapFeaturePoint?>(
            builder: (context, value, child) {
              final pointOnMap = value != null;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
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
                        if (pointOnMap)
                          RoundIconButton(
                            icon: const Icon(Icons.close),
                            onTap: () => model.removePoint(),
                          ),
                      ],
                    ),
                    UIHelper.verticalSpaceSmall(),
                    TextField(
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      onChanged: model.onChangeTitel,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelText: 'Titel',
                      ),
                    ),
                    UIHelper.verticalSpaceSmall(),
                    TextField(
                      maxLines: 20,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      onChanged: model.onChangeDescription,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelText: 'Beschreibung',
                        alignLabelWithHint: true,
                      ),
                    ),
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

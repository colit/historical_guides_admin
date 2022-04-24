import 'package:flutter/material.dart';
import 'package:historical_guides_admin/core/app_state.dart';
import 'package:historical_guides_admin/core/services/data_service.dart';
import 'package:historical_guides_admin/ui/views/create_tour/create_tour_model.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

class CreateTrackView extends StatelessWidget {
  const CreateTrackView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Track'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BaseWidget<CreateTrackModel>(
          model: CreateTrackModel(
            dataService: context.read<DataService>(),
          ),
          onModelReady: (model) => model.getTracks(),
          builder: (_, model, __) {
            return Center(
              child: SizedBox(
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 30),
                    TextField(
                      controller: model.textFieldController,
                      onChanged: (value) => model.onNameChanged(value),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Tour name',
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(children: [
                      Expanded(
                          child: Text(model.trackName == null
                              ? 'Upload Track'
                              : 'Uploaded: ${model.trackName!}')),
                      ElevatedButton(
                        onPressed: model.selectTrack,
                        child: const Text('Select file (gpx)'),
                      ),
                    ]),
                    if (model.isTrackLoaded) ...[
                      const SizedBox(height: 15),
                      Text('Track Length: ${model.trackLength} km'),
                    ],
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: model.isTrackLoaded
                          ? () {
                              model.createTrack(onSuccess: () {
                                context.read<AppState>().popPage();
                              });
                            }
                          : null,
                      child: const Text('Create Tour'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:historical_guides_admin/core/models/map_feature_point.dart';
import 'package:historical_guides_admin/ui/widgets/text_input_widget.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

import '../../../core/editor_state.dart';
import '../../../core/services/data_service.dart';
import '../../../core/services/map_service.dart';
import 'edit_image_model.dart';
import 'image_uploader/image_uploader_view.dart';

class EditImageView extends StatelessWidget {
  static const viewId = 'edit_image';
  const EditImageView({Key? key, this.id = -1}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<EditImageModel>(
        model: EditImageModel(
          dataService: context.read<DataService>(),
          mapService: context.read<MapService>(),
          editorState: context.read<EditorState>(),
        ),
        onModelReady: (model) => model.initModel(id),
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(id < 0 ? 'Foto anlegen' : 'Foto editieren'),
            ),
            body: model.state == ViewState.busy
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(
                      UIHelper.kHorizontalSpaceSmall,
                    ),
                    child: Consumer<MapFeaturePoint?>(
                      builder: ((context, point, child) {
                        final latitude =
                            point?.position.latitude.toStringAsFixed(4);
                        final longitude =
                            point?.position.longitude.toStringAsFixed(4);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (point != null)
                              Padding(
                                padding: const EdgeInsets.all(
                                    UIHelper.kHorizontalSpaceSmall),
                                child: Text('Position: $latitude, $longitude'),
                              ),
                            TextInputWidget(
                              labelText: 'Name',
                              value: model.title,
                              onChange: model.updateName,
                            ),
                            TextInputWidget(
                              labelText: 'Beschreibung',
                              value: model.description,
                              onChange: model.updateDescription,
                            ),
                            ImageUploaderView(
                              url: model.image.imageURL,
                              onImageUpdate: (data, name) =>
                                  model.updateImage(data, name),
                            ),
                            TextInputWidget(
                              labelText: 'Veröffentlicht',
                              value: model.published.toString(),
                              onChange: (year) =>
                                  model.updatePublished(int.parse(year)),
                            ),
                            TextInputWidget(
                              labelText: 'Lizenz',
                              value: model.license,
                              onChange: model.updateLicense,
                            ),
                            TextInputWidget(
                              labelText: 'Lizenz URL',
                              value: model.licenseURL,
                              onChange: model.updateLizenzURL,
                            ),
                            TextInputWidget(
                              labelText: 'Autor',
                              value: model.author,
                              onChange: model.updateAutor,
                            ),
                            TextInputWidget(
                              labelText: 'Autor URL',
                              value: model.authorURL,
                              onChange: model.updateAutorURL,
                            ),
                            TextInputWidget(
                              labelText: 'Quelle',
                              value: model.source,
                              onChange: model.updateSource,
                            ),
                            TextInputWidget(
                              labelText: 'Quelle URL',
                              value: model.sourceURL,
                              onChange: model.updateSourceURL,
                            ),
                            ElevatedButton(
                              onPressed: model.checkUpdate(point)
                                  ? model.uploadData
                                  : null,
                              child: Text(model.newImage
                                  ? 'Foto hochladen'
                                  : 'Foto aktualisieren'),
                              style:
                                  Theme.of(context).elevatedButtonTheme.style,
                            ),
                            if (!model.newImage) ...[
                              UIHelper.verticalSpaceSmall(),
                              ElevatedButton(
                                onPressed: model.deleteImage,
                                child: const Text('Foto löschen'),
                                style:
                                    Theme.of(context).elevatedButtonTheme.style,
                              )
                            ]
                          ],
                        );
                      }),
                    ),
                  ),
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:historical_guides_admin/core/services/data_service.dart';
import 'package:historical_guides_admin/ui/views/edit_tour/edit_station/photo_selector/image_thumbnail_widget.dart';
import 'package:historical_guides_admin/ui/views/edit_tour/edit_station/photo_selector/photo_selector_model.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class PhotoSelectorView extends StatelessWidget {
  const PhotoSelectorView({
    Key? key,
    required this.position,
    this.onSelectImage,
  }) : super(key: key);

  final LatLng position;
  final void Function(ImageEntity)? onSelectImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(UIHelper.kHorizontalSpaceMedium),
      child: Container(
        color: kColorWhite,
        padding: const EdgeInsets.all(UIHelper.kHorizontalSpaceMedium),
        child: BaseWidget<PhotoSelectorModel>(
          model: PhotoSelectorModel(
            dataService: context.read<DataService>(),
          ),
          onModelReady: (model) => model.initModel(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
          builder: (context, model, child) {
            return model.state == ViewState.busy
                ? const CircularProgressIndicator()
                : Material(
                    child: model.images.isEmpty
                        ? const Text('Keine passende Bilder gefunden')
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: GridView.builder(
                                  itemCount: model.images.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          mainAxisSpacing:
                                              UIHelper.kHorizontalSpaceSmall,
                                          crossAxisSpacing:
                                              UIHelper.kVerticalSpaceSmall,
                                          maxCrossAxisExtent: 100.0),
                                  itemBuilder: (context, index) =>
                                      ImageThumbnailWidget(
                                    selected: model.selectedImageIndex == index,
                                    onTap: () {
                                      model.selectedImageIndex = index;
                                    },
                                    image: model.images[index],
                                  ),
                                ),
                              ),
                              UIHelper.verticalSpaceMedium(),
                              ElevatedButton(
                                  onPressed: model.selectedImageIndex == null
                                      ? null
                                      : () {
                                          onSelectImage
                                              ?.call(model.selectedImage);
                                          context
                                              .read<ModalViewService>()
                                              .close();
                                        },
                                  child: const Text('Foto hinzufügen'))
                            ],
                          ),
                  );
          },
        ),
      ),
    );
  }
}

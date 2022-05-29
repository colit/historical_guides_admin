import 'package:flutter/material.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../photo_selector/image_thumbnail_widget.dart';
import '../photo_selector/photo_selector_view.dart';

class StationImagesView extends StatefulWidget {
  const StationImagesView({
    Key? key,
    required this.latitude,
    required this.longitude,
    this.images = const <ImageEntity>[],
    this.onImagesUpdate,
  }) : super(key: key);

  final List<ImageEntity> images;
  final double latitude;
  final double longitude;
  final void Function(List<ImageEntity>)? onImagesUpdate;

  @override
  State<StationImagesView> createState() => _StationImagesViewState();
}

class _StationImagesViewState extends State<StationImagesView> {
  List<ImageEntity> images = [];
  @override
  void initState() {
    images = List<ImageEntity>.from(widget.images);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Fotos zu der Station'),
        UIHelper.verticalSpaceSmall(),
        if (images.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: images.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisSpacing: UIHelper.kHorizontalSpaceSmall,
                crossAxisSpacing: UIHelper.kVerticalSpaceSmall,
                maxCrossAxisExtent: 100.0),
            itemBuilder: (context, index) => ImageThumbnailWidget(
              onTap: () {
                _deleteImage(index);
              },
              image: images[index],
            ),
          )
        else
          const Text('Noch keine Fotos vorhanden'),
        UIHelper.verticalSpaceSmall(),
        ElevatedButton(
          onPressed: () {
            context.read<ModalViewService>().show(
                  PhotoSelectorView(
                    position: LatLng(widget.latitude, widget.longitude),
                    onSelectImage: (image) => _addImage(image),
                  ),
                );
          },
          child: const Text('Weitere Fotos hinzufügen'),
        ),
      ],
    );
  }

  void _deleteImage(int index) {
    setState(() {
      images.removeAt(index);
    });
    widget.onImagesUpdate?.call(images);
  }

  void _addImage(ImageEntity image) {
    if (images.indexWhere(((e) => e.id == image.id)) < 0) {
      setState(() {
        images.add(image);
      });
      widget.onImagesUpdate?.call(images);
    }
  }
}

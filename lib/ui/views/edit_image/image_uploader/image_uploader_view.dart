import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:historical_guides_admin/ui/widgets/file_picker_widget.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:image/image.dart' as img;

class ImageUploaderView extends StatefulWidget {
  const ImageUploaderView({
    Key? key,
    this.url,
    required this.onImageUpdate,
  }) : super(key: key);

  final String? url;
  final void Function(Uint8List data, String name) onImageUpdate;

  @override
  State<ImageUploaderView> createState() => _ImageUploaderViewState();
}

class _ImageUploaderViewState extends State<ImageUploaderView> {
  Image? image;
  late final networkImage =
      widget.url == null ? Container() : NetworkImageWidget(url: widget.url!);

  void _processImage(FilePickerResponce? responce) {
    if (responce == null) {
      print('remove image');
      setState(() {
        image = null;
      });
      return;
    }
    final imageTemp = img.decodeJpg(responce.data);
    final resizedImage = img.copyResize(imageTemp!, width: 1200);
    final imageData = Uint8List.fromList(img.encodeJpg(resizedImage));
    widget.onImageUpdate.call(imageData, responce.name);
    setState(() {
      image = Image.memory(imageData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(UIHelper.kVerticalSpaceSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 150,
            width: 150,
            color: kColorBackgroundLight,
            child: image ?? networkImage,
          ),
          FilePickerView(
            extensions: const ['jpg', 'jpeg'],
            onData: _processImage,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

class ImageThumbnailWidget extends StatefulWidget {
  const ImageThumbnailWidget({
    Key? key,
    required this.image,
    this.onTap,
    this.selected = false,
  }) : super(key: key);

  final ImageEntity image;
  final void Function()? onTap;
  final bool selected;

  @override
  State<ImageThumbnailWidget> createState() => _ImageThumbnailWidgetState();
}

class _ImageThumbnailWidgetState extends State<ImageThumbnailWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Material(
      child: InkWell(
        onTap: widget.onTap?.call,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: kColorPrimary,
              child: Center(
                child: NetworkImageWidget(
                  url: widget.image.imageURL!,
                ),
              ),
            ),
            if (widget.selected)
              Container(
                padding: const EdgeInsets.all(UIHelper.kHorizontalSpaceMedium),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: kColorSecondaryLight,
                ),
                child: const Icon(
                  Icons.check,
                  color: kColorWhite,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

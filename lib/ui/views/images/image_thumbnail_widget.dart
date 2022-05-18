import 'package:flutter/material.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

class ImageThumbnailWidget extends StatefulWidget {
  const ImageThumbnailWidget({
    Key? key,
    required this.image,
    this.onTap,
  }) : super(key: key);

  final ImageEntity image;
  final void Function()? onTap;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: kColorSecondary,
                // child: NetworkImageWidget(
                //   url: widget.image.imageURL!,
                // ),
              ),
            ),
            UIHelper.verticalSpace(4),
            Text(widget.image.title ?? 'NaN'),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

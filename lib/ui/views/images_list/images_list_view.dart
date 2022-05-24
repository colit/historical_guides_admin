import 'package:flutter/material.dart';
import 'package:historical_guides_admin/core/editor_state.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

import '../../../core/services/data_service.dart';
import '../../../core/services/map_service.dart';
import '../edit_image/edit_image_view.dart';
import 'images_list_model.dart';

class ImagesListView extends StatelessWidget {
  static const viewId = 'images_list';
  const ImagesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ImagesListModel>(
        model: ImagesListModel(
          dataService: context.read<DataService>(),
          mapService: context.read<MapService>(),
        ),
        onModelReady: (model) => model.initModel(),
        builder: (context, model, child) {
          return model.state == ViewState.busy
              ? Container()
              : Scaffold(
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      context
                          .read<EditorState>()
                          .pushPage(name: EditImageView.viewId);
                    },
                    child: const Icon(Icons.add),
                  ),
                  body: ListView.separated(
                    padding:
                        const EdgeInsets.all(UIHelper.kHorizontalSpaceSmall),
                    itemCount: model.imagesCount,
                    itemBuilder: (context, index) {
                      return model.imagesLoaded(index)
                          ? ImageListElement(
                              image: model.images[index],
                              onTap: (id) =>
                                  context.read<EditorState>().pushPage(
                                        name: EditImageView.viewId,
                                        arguments: id,
                                      ),
                            )
                          : Container();
                    },
                    separatorBuilder: (context, index) =>
                        UIHelper.verticalSpaceSmall(),
                  ),
                );

          // ImageListElement(
          //   image: model.images[index],
          // ));
        });
  }
}

class ImageListElement extends StatelessWidget {
  const ImageListElement({
    Key? key,
    required this.image,
    this.onTap,
  }) : super(key: key);

  final ImageEntity image;
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () => onTap?.call(image.id),
        child: Container(
          padding: const EdgeInsets.all(UIHelper.kHorizontalSpaceSmall),
          color: kColorBackgroundLight,
          child: Text(image.title ?? 'No title'),
        ),
      ),
    );
  }
}

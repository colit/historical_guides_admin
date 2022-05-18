import 'package:flutter/material.dart';
import 'package:historical_guides_admin/core/services/data_service.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

import 'image_thumbnail_widget.dart';
import 'images_model.dart';

class ImagesView extends StatelessWidget {
  const ImagesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseWidget<ImagesModel>(
        model: ImagesModel(
          dataService: context.read<DataService>(),
        ),
        onModelReady: (model) => model.initModel(),
        builder: (context, model, _) {
          return model.state == ViewState.busy
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 350,
                        maxWidth: 640,
                      ),
                      child: GridView.builder(
                        itemCount: model.images.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 180,
                          mainAxisSpacing: UIHelper.kHorizontalSpaceMedium,
                          crossAxisSpacing: UIHelper.kVerticalSpaceSmall,
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return ImageThumbnailWidget(
                            image: model.images[index],
                            onTap: () {},
                          );
                        },
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}

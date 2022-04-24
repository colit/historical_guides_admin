import 'package:flutter/material.dart';
import 'package:historical_guides_admin/core/services/data_service.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

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
          builder: (context, model, _) {
            return model.state == ViewState.busy
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: ElevatedButton(
                        onPressed: () {
                          model.createUUIDs();
                        },
                        child: const Text('Create UUIDs')),
                  );
          }),
    );
  }
}

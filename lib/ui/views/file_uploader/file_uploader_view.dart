import 'package:flutter/material.dart';
import 'package:historical_guides_admin/ui/views/file_uploader/file_uploader_model.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

class FileUploaderView extends StatelessWidget {
  const FileUploaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<FileUploaderModel>(
      model: FileUploaderModel(),
      builder: (context, model, child) {
        return Column(
          children: [],
        );
      },
    );
  }
}

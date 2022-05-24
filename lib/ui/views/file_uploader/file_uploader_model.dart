import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

class FileUploaderModel extends BaseModel {
  String? _fileName;

  String? get tourName => _fileName;

  // void createTrack({required Function onSuccess}) {
  //   if (_trackDetails == null) return;
  //   setState(ViewState.busy);
  //   _dataService
  //       .createTour(
  //     _trackDetails!.asGeoJSON,
  //     name: _fileName ?? 'My Tour',
  //     length: _trackDetails!.length,
  //     start: _trackDetails!.startPoint,
  //     bounds: _trackDetails!.bounds,
  //   )
  //       .then((_) {
  //     setState(ViewState.idle);
  //     onSuccess.call();
  //   });
  // }

  Future<void> selectTrack() async {
    PlatformFile? file;
    try {
      file = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['gpx'],
      ))
          ?.files
          .first;
    } on PlatformException catch (e) {
      print('Unsupported operation' + e.toString());
    } catch (e) {
      print(e.toString());
    }

    if (file != null) {
      final bytes = file.bytes;
      if (bytes != null) {
        // _trackDetails = TrackDetails(String.fromCharCodes(bytes));
        // final name = _trackDetails?.gpx.metadata?.name?.replaceAll('-', ' ') ??
        //     'no name';
        // if (textFieldController.text.isEmpty) {
        //   textFieldController.text = name;
        //   _fileName = name;
        // }
        notifyListeners();
      }
    }
  }

  void onNameChanged(String value) {
    _fileName = value;
  }

  getTracks() {}
}

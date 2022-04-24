import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:historical_guides_admin/core/models/track_details.dart';
import 'package:historical_guides_admin/core/services/data_service.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

class CreateTrackModel extends BaseModel {
  CreateTrackModel({
    required DataService dataService,
  }) : _dataService = dataService;

  final DataService _dataService;
  final textFieldController = TextEditingController();

  TrackDetails? _trackDetails;
  String? _tourName;

  String? get tourName => _tourName;
  String? get trackName => _trackDetails?.gpx.metadata?.name;
  double? get trackLength => _trackDetails?.length;
  bool get isTrackLoaded => _trackDetails != null;

  void createTrack({required Function onSuccess}) {
    if (_trackDetails == null) return;
    setState(ViewState.busy);
    _dataService
        .createTour(
      _trackDetails!.asGeoJSON,
      name: _tourName ?? 'My Tour',
      length: _trackDetails!.length,
      start: _trackDetails!.startPoint,
      bounds: _trackDetails!.bounds,
    )
        .then((_) {
      setState(ViewState.idle);
      onSuccess.call();
    });
  }

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
        _trackDetails = TrackDetails(String.fromCharCodes(bytes));
        final name = _trackDetails?.gpx.metadata?.name?.replaceAll('-', ' ') ??
            'no name';
        if (textFieldController.text.isEmpty) {
          textFieldController.text = name;
          _tourName = name;
        }
        notifyListeners();
      }
    }
  }

  void onNameChanged(String value) {
    _tourName = value;
  }

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  getTracks() {}
}

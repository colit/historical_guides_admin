import 'package:historical_guides_admin/core/services/data_service.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

import '../../../../core/editor_state.dart';
import '../../../../core/services/map_service.dart';

class EditPoIModel extends BaseModel {
  EditPoIModel({
    required MapService mapService,
    required DataService dataService,
    required EditorState editorState,
  })  : _mapService = mapService,
        _dataService = dataService,
        _editorState = editorState;

  final MapService _mapService;
  final DataService _dataService;
  final EditorState _editorState;

  bool get editComplete =>
      _mapService.pointToCreate != null && _title.isNotEmpty;

  String _title = '';
  String _description = '';

  void createPoint() {
    _mapService.enablePoints();
  }

  void removePoint() {
    _mapService.removePoint();
    notifyListeners();
  }

  void addPoint() {
    _mapService.createPoint();
    notifyListeners();
  }

  void onChangeTitel(String value) {
    _title = value;
    notifyListeners();
  }

  void onChangeDescription(String value) {
    _description = value;
    notifyListeners();
  }

  void savePoint() {
    _dataService.updateCurrentTour(
      latitude: _mapService.pointToCreate!.position.latitude,
      longitude: _mapService.pointToCreate!.position.longitude,
      title: _title,
      description: _description,
    );
    _mapService.onLeaveEditorPage();
    _editorState.popPage();
  }
}

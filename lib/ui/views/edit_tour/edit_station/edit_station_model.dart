import 'package:historical_guides_admin/core/services/data_service.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

import '../../../../core/editor_state.dart';
import '../../../../core/services/map_service.dart';

class EditStationModel extends BaseModel {
  EditStationModel({
    required MapService mapService,
    required DataService dataService,
    required EditorState editorState,
  })  : _mapService = mapService,
        _dataService = dataService,
        _editorState = editorState;

  final MapService _mapService;
  final DataService _dataService;
  final EditorState _editorState;

  bool get editComplete => _edited;

  bool _edited = false;

  bool _creatingNewPoint = true;
  Station _station = Station.empty;

  String get titel => _station.titel;
  String get description => _station.description ?? '';
  bool get pointRemovable => _creatingNewPoint;

  List<ImageEntity> get images => _station.images;

  void initModelWith(Station? station) {
    if (station != null) {
      _creatingNewPoint = false;
      print('initModelWith(station: ${station.titel})');
      _station = station;
      Future.delayed(const Duration(milliseconds: 100)).then((_) {
        _dataService.hideStation(station.id);
        _mapService.showPoint(
          station.id,
          station.position.latitude,
          station.position.longitude,
        );
      });
    }
    _mapService.enablePointsEdit();
  }

  void removePoint() {
    _mapService.removePoint();
    _edited = true;
    notifyListeners();
  }

  void addPoint() {
    _mapService.createPoint();
    _edited = true;
    notifyListeners();
  }

  void onChangeTitel(String value) {
    _station = _station.copyWith(titel: value);
    _edited = true;
    notifyListeners();
  }

  void onChangeDescription(String value) {
    _station = _station.copyWith(description: value);
    _edited = true;
    notifyListeners();
  }

  void savePoint() {
    final pointToCreate = _mapService.pointToCreate!;
    _dataService.updateCurrentTour(
      id: _creatingNewPoint ? pointToCreate.id : _station.id,
      latitude: pointToCreate.position.latitude,
      longitude: pointToCreate.position.longitude,
      title: _station.titel,
      description: _station.description,
      images: _station.images,
    );
    _mapService.onLeaveEditorPage();
    _editorState.popPage();
  }

  void addImage(ImageEntity image) {
    var images = List<ImageEntity>.from(_station.images)..add(image);
    _station = _station.copyWith(images: images);
    notifyListeners();
  }
}

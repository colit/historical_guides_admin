import 'dart:typed_data';

import 'package:historical_guides_admin/core/editor_state.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

import '../../../core/services/data_service.dart';
import '../../../core/services/map_service.dart';

class EditImageModel extends BaseModel {
  EditImageModel({
    required DataService dataService,
    required MapService mapService,
    required EditorState editorState,
  })  : _dataService = dataService,
        _mapService = mapService,
        _editorState = editorState;

  final DataService _dataService;
  final MapService _mapService;
  final EditorState _editorState;

  late ImageEntity _image;
  ImageEntity get image => _image;

  bool _newImage = false;
  bool _dataUpdated = false;
  String _title = 'New Name';
  String _description = 'Description';
  Uint8List? _imageData;

  String get title => _title;
  String get description => _description;
  bool get newImage => _newImage;

  void initModel(int id) {
    setState(ViewState.busy);
    if (id > 0) {
      _dataService.getImageDetails(id).then((image) {
        _image = image;
        print('image loaded: ${image.objectId}');
        _mapService.showPoint(id.toString(), image.latitude, image.longitude);
        setState(ViewState.idle);
      });
    } else {
      _newImage = true;
      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        _mapService.createPoint();
        final position = _mapService.mapPosition;
        _image = ImageEntity.withPosition(
          position.latitude,
          position.longitude,
        );
        setState(ViewState.idle);
      });
    }
  }

  void updateImage(Uint8List data) {
    _imageData = data;
    _dataUpdated = true;
  }

  void updateName(String value) {
    _title = value;
    _dataUpdated = true;
  }

  void updateDescription(String value) {
    _description = value;
    _dataUpdated = true;
  }

  void uploadData() {
    setState(ViewState.busy);
    _dataService
        .updateImage(
      _image.copyWith(
        id: _image.id,
        latitude: _mapService.pointToCreate!.position.latitude,
        longitude: _mapService.pointToCreate!.position.longitude,
        title: _title,
        description: _description,
      ),
      imageData: _imageData,
      create: _newImage,
    )
        .then((_) {
      _mapService.removePoint();
      _editorState.popPage();
    });
  }

  void deleteImage() {
    setState(ViewState.busy);
    _dataService.deleteImage(_image).then((_) {
      _mapService.removePoint();
      _editorState.popPage();
    });
  }
}

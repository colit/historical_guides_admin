import 'dart:typed_data';

import 'package:historical_guides_admin/core/editor_state.dart';
import 'package:historical_guides_admin/core/models/map_feature_point.dart';
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

  bool get dataUpdated => _dataUpdated;

  Uint8List? _imageData;
  String? _imageName;

  String? get title => _image.title;
  String? get description => _image.description;
  String? get author => _image.author;
  String? get authorURL => _image.authorURL;
  String? get license => _image.license;
  String? get licenseURL => _image.licenseURL;
  String? get source => _image.source;
  String? get sourceURL => _image.sourceURL;
  int? get published => _image.yearPublished;

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

  void updateImage(Uint8List data, String name) {
    _imageData = data;
    _imageName = name;
    _dataUpdated = true;
  }

  void updateName(String value) {
    _image = _image.copyWith(title: value);
    _registerUpdate();
  }

  void updateDescription(String value) {
    _image = _image.copyWith(description: value);
    _registerUpdate();
  }

  void uploadData() {
    setState(ViewState.busy);
    _dataService
        .updateImage(
      _image.copyWith(
        latitude: _mapService.pointToCreate!.position.latitude,
        longitude: _mapService.pointToCreate!.position.longitude,
      ),
      imageData: _imageData,
      imageName: _imageName,
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

  void updateLicense(String value) {
    _image = _image.copyWith(license: value);
    _registerUpdate();
  }

  void updateLizenzURL(String value) {
    _image = _image.copyWith(licenseURL: value);
    _registerUpdate();
  }

  void updateAutor(String value) {
    _image = _image.copyWith(author: value);
    _registerUpdate();
  }

  void updateAutorURL(String value) {
    _image = _image.copyWith(authorURL: value);
    _registerUpdate();
  }

  void updateSource(String value) {
    _image = _image.copyWith(source: value);
    _registerUpdate();
  }

  void updateSourceURL(String value) {
    _image = _image.copyWith(sourceURL: value);
    _registerUpdate();
  }

  void updatePublished(int value) {
    _image = _image.copyWith(yearPublished: value);
    _registerUpdate();
  }

  void _registerUpdate() {
    _dataUpdated = true;
    notifyListeners();
  }

  bool checkUpdate(MapFeaturePoint? point) {
    return _image.latitude != point?.position.latitude ||
        _image.longitude != point?.position.longitude ||
        _dataUpdated;
  }
}

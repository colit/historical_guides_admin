import 'package:historical_guides_commons/historical_guides_commons.dart';

import '../../../../../core/services/data_service.dart';

class PhotoSelectorModel extends BaseModel {
  PhotoSelectorModel({required DataService dataService})
      : _dataService = dataService;

  final DataService _dataService;
  List<ImageEntity> _images = [];
  List<ImageEntity> get images => _images;

  int? _selectedImageIndex;

  int? get selectedImageIndex => _selectedImageIndex;

  ImageEntity get selectedImage => _images[_selectedImageIndex!];

  set selectedImageIndex(int? index) {
    _selectedImageIndex = _selectedImageIndex == index ? null : index;
    notifyListeners();
  }

  void initModel({required double latitude, required double longitude}) {
    setState(ViewState.busy);
    _dataService.getImagesAroundStation(latitude, longitude).then((images) {
      _images = images;
      setState(ViewState.idle);
    });
  }
}

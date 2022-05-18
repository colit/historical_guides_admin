import 'package:historical_guides_admin/core/services/data_service.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

class ImagesModel extends BaseModel {
  ImagesModel({required DataService dataService}) : _dataService = dataService;

  final DataService _dataService;

  List<ImageEntity> _images = [];
  List<ImageEntity> get images => _images;

  void getImages() {
    setState(ViewState.busy);
  }

  void createUUIDs() {
    // setState(ViewState.busy);
    // _dataService.createUUIDs().then((_) => setState(ViewState.idle));
  }

  void initModel() {
    setState(ViewState.busy);
    _dataService.getImages().then((images) {
      print('found: ${images.length}');
      _images = images;
      setState(ViewState.idle);
    });
  }
}

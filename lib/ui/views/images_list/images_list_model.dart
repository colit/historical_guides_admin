import 'package:historical_guides_commons/historical_guides_commons.dart';

import '../../../core/services/data_service.dart';
import '../../../core/services/map_service.dart';

class ImagesListModel extends BaseModel {
  ImagesListModel({
    required DataService dataService,
    required MapService mapService,
  })  : _dataService = dataService,
        _mapService = mapService;

  final DataService _dataService;
  final MapService _mapService;

  List<ImageEntity> _images = [];

  List<ImageEntity> get images => _images;

  void initModel() {
    setState(ViewState.busy);
    _dataService.getImages().then((images) {
      _images = images;
      setState(ViewState.idle);
    });
  }
}

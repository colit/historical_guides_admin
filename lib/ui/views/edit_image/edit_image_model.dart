import 'package:historical_guides_commons/historical_guides_commons.dart';

import '../../../core/services/data_service.dart';
import '../../../core/services/map_service.dart';

class EditImageModel extends BaseModel {
  EditImageModel({
    required DataService dataService,
    required MapService mapService,
  })  : _dataService = dataService,
        _mapService = mapService;

  final DataService _dataService;
  final MapService _mapService;

  late ImageEntity _image;

  ImageEntity get image => _image;

  void initModel(int id) {
    setState(ViewState.busy);
    if (id > 0) {
      _dataService.getImageDetails(id).then((image) {
        _image = image;
        print('image: ${image.latitude}, ${image.longitude}');
        _mapService.showPoint(id.toString(), image.latitude, image.longitude);
        setState(ViewState.idle);
      });
    } else {
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
}

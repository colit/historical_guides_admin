import 'package:historical_guides_admin/core/services/data_service.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

class ImagesModel extends BaseModel {
  ImagesModel({required DataService dataService}) : _dataService = dataService;

  final DataService _dataService;

  void getImages() {
    setState(ViewState.busy);
  }

  void createUUIDs() {
    // setState(ViewState.busy);
    // _dataService.createUUIDs().then((_) => setState(ViewState.idle));
  }
}

import 'package:historical_guides_admin/core/services/data_service.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

import '../../../../core/services/map_service.dart';

class TourInfosModel extends BaseModel {
  TourInfosModel({
    required DataService dataService,
    required MapService mapService,
  })  : _dataService = dataService,
        _mapService = mapService {
    _dataService.addListener(_onDataUpdate);
  }

  final DataService _dataService;
  final MapService _mapService;

  Tour? tour;

  void _onDataUpdate() {
    tour = _dataService.currentTour;
    notifyListeners();
  }

  void initModel(String id) {
    setState(ViewState.busy);
    _dataService.getTourDetails(id).then((value) {
      tour = value;
      _mapService.setBounds(value);
      setState(ViewState.idle);
    });
  }

  @override
  void dispose() {
    _dataService.removeListener(_onDataUpdate);
    super.dispose();
  }
}

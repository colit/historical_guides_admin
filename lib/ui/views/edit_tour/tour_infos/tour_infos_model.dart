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

  Tour? get tour => _dataService.currentTour;
  List<Station> get pointsOfInterest =>
      _dataService.currentTour?.stations.where((e) => !e.removed).toList() ??
      [];

  bool _tourUpdated = false;
  bool get tourUpdated => _tourUpdated;

  void _onDataUpdate() {
    _tourUpdated = true;
    notifyListeners();
  }

  void initModel(String id) {
    setState(ViewState.busy);
    _dataService.getTourDetails(id).then((value) {
      _mapService.setBounds(value);
      setState(ViewState.idle);
    });
  }

  @override
  void dispose() {
    _dataService.removeListener(_onDataUpdate);
    super.dispose();
  }

  void saveTour() {
    if (tour == null) return;
    _dataService.saveTour().then((_) {
      _tourUpdated = false;
      notifyListeners();
    });
  }

  void deletePoint(int index) {
    if (tour == null) return;
    final points = tour!.stations;
    final p = points.removeAt(index);
    points.insert(index, p.copyWith(removed: true));
    _dataService.updateTour(tour?.copyWith(stations: points));
  }

  void updateTourDescription(String value) {
    final newTour = tour?.copyWith(description: value);
    _dataService.updateTour(newTour);
    _tourUpdated = true;
  }

  void updateTourName(String value) {
    final newTour = tour?.copyWith(name: value);
    _dataService.updateTour(newTour);
    _tourUpdated = true;
  }

  void updateStationsOrder(int oldIndex, int newIndex) {
    _dataService.updateStationsOrder(oldIndex, newIndex);
    _tourUpdated = true;
    notifyListeners();
  }
}

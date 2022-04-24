import 'package:historical_guides_admin/core/app_state.dart';
import 'package:historical_guides_admin/core/services/data_service.dart';
import 'package:historical_guides_admin/navigation/app_routes.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

class ToursModel extends BaseModel {
  ToursModel({
    required DataService dataService,
    required AppState appState,
  })  : _dataService = dataService,
        _appState = appState;
  final DataService _dataService;
  final AppState _appState;

  List<Tour> _tours = [];

  List<Tour> get tours => _tours;

  void getTours() {
    setState(ViewState.busy);
    _dataService.getToursList().then((result) {
      _tours = result;
      setState(ViewState.idle);
    });
  }

  Future<bool> deleteTour(int index) async {
    final tourToRemove = _tours[index];
    final success = await _dataService.removeTour(tourToRemove.id);
    if (success) {
      _tours.remove(tourToRemove);
    }
    return true;
  }

  void updateTours() {
    notifyListeners();
  }

  void editTour(int index) {
    _appState.pushPage(
      name: TourEditPath.key,
      arguments: TourDetailArguments(_tours[index].id),
    );
  }
}

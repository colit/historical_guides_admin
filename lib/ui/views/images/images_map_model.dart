import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../../core/services/data_service.dart';
import '../../../core/services/map_service.dart';

class ImagesMapModel extends BaseModel {
  ImagesMapModel({
    required DataService dataService,
    required MapService mapService,
  })  : _dataService = dataService,
        _mapService = mapService;

  final DataService _dataService;
  final MapService _mapService;

  late MapboxMapController _controller;

  get onMapClick => null;

  LatLng get currentPosition => _mapService.mapPosition;

  List<ImageEntity> _images = [];
  double get currentZoom => 17;

  get currentStyle => null;

  void initModel() {
    setState(ViewState.busy);
    _dataService.getImages().then((images) {
      print('found: ${images.length}');
      _images = images;
      setState(ViewState.idle);
    });
  }

  void onMapCreated(MapboxMapController controller) {
    _controller = controller;
  }

  void onStyleLoadedCallback() {}
}

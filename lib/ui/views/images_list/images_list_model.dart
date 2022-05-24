import 'package:historical_guides_commons/historical_guides_commons.dart';

import '../../../core/services/data_service.dart';
import '../../../core/services/map_service.dart';

class ImagesListModel extends BaseModel {
  ImagesListModel({
    required DataService dataService,
    required MapService mapService,
  })  : _dataService = dataService,
        _mapService = mapService {
    _dataService.addListener(_onDataUpdate);
  }

  final DataService _dataService;
  final MapService _mapService;

  List<ImageEntity> _images = [];
  int _totalImages = 0;
  int _cursor = 0;
  bool _loading = false;

  List<ImageEntity> get images => _images;
  int get imagesCount => _totalImages;

  // reload image list on data update
  void _onDataUpdate() {
    _images = [];
    _cursor = 0;
    _loading = false;
    initModel();
  }

  void initModel() {
    setState(ViewState.busy);
    _dataService.countImages().then((value) {
      _totalImages = value;
      setState(ViewState.idle);
    });
  }

  bool imagesLoaded(int index) {
    bool loaded = index < _images.length;
    if (!loaded && !_loading) {
      _loading = true;
      _dataService.getImages(_images.length).then((value) {
        _loading = false;
        _images.addAll(value);
        notifyListeners();
      });
    }
    return loaded;
  }

  @override
  void dispose() {
    _dataService.removeListener(_onDataUpdate);
    super.dispose();
  }
}

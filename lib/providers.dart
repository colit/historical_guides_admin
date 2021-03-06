import 'package:historical_guides_admin/core/models/map_feature_point.dart';
import 'package:historical_guides_admin/core/services/map_service.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/app_state.dart';
import 'core/editor_state.dart';
import 'core/repositories/parse_server_repository.dart';
import 'core/services/data_service.dart';
import 'core/services/tracks_services.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders,
];

List<SingleChildWidget> independentServices = [
  ChangeNotifierProvider(create: (_) => AppState()),
  ChangeNotifierProvider(create: (_) => EditorState()),
  ChangeNotifierProvider(create: (_) => MapService()),
  Provider(create: (_) => TracksService()),
  Provider(create: (_) => ParseServerRepository()),
  Provider(create: (_) => ModalViewService()),
];

List<SingleChildWidget> dependentServices = [
  ChangeNotifierProxyProvider<ParseServerRepository, DataService>(
    create: (_) => DataService(),
    update: (_, databaseRepository, service) =>
        service!..update(databaseRepository),
  ),
];

List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<MapFeaturePoint?>(
    initialData: null,
    create: (context) =>
        Provider.of<MapService>(context, listen: false).currentPoint,
  ),
];

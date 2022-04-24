import 'package:historical_guides_admin/core/models/feature_point.dart';
import 'package:historical_guides_admin/core/services/map_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/app_state.dart';
import 'core/editor_state.dart';
import 'core/repositories/graphql_repository.dart';
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
  Provider(create: (_) => GraphQLRepository()),
];

List<SingleChildWidget> dependentServices = [
  ChangeNotifierProxyProvider<GraphQLRepository, DataService>(
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

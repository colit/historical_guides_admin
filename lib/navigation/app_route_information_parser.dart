import 'package:flutter/material.dart';

import '../core/app_state.dart';
import 'app_routes.dart';

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  AppRouteInformationParser({required AppState appState})
      : _appState = appState;

  final AppState _appState;

  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    if (uri.pathSegments.isEmpty ||
        uri.pathSegments.first == TrackPickerPath.key) {
      _appState.initState(0);
      return TrackPickerPath();
    }
    if (uri.pathSegments.first == ImagesPath.key) {
      _appState.initState(1);
      return ImagesPath();
    }
    if (uri.pathSegments.first == SetupPath.key) {
      _appState.initState(2);
      return SetupPath();
    }
    return PageNotFoundPath();
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) {
    print(configuration);
    if (configuration is TrackPickerPath) {
      return const RouteInformation(location: '/');
    }
    if (configuration is SetupPath) {
      return const RouteInformation(location: '/${SetupPath.key}');
    }
    if (configuration is ImagesPath) {
      return const RouteInformation(location: '/${ImagesPath.key}');
    }
    return null;
  }
}

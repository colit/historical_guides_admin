import 'package:flutter/material.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

import '../core/app_state.dart';
import '../ui/views/app_shell.dart';
import 'app_routes.dart';

class RootRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppState _appState;

  RootRouterDelegate({required AppState appState})
      : navigatorKey = GlobalKey<NavigatorState>(),
        _appState = appState {
    appState.addListener(notifyListeners);
  }

  @override
  AppRoutePath get currentConfiguration {
    // TODO: check switch!
    switch (_appState.currentDestination) {
      case AppState.toursPath:
        return TrackPickerPath();
      case AppState.imagesPath:
        return ImagesPath();
      default:
        return SetupPath();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          child: ModalViewManager(
            modalViewService: context.read<ModalViewService>(),
            child: const AppShell(),
          ),
        )
      ],
      onPopPage: _onPopPage,
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    if (configuration is TrackPickerPath) {
      _appState.setHomePage(0);
    } else if (configuration is ImagesPath) {
      _appState.setHomePage(1);
    } else if (configuration is SetupPath) {
      _appState.setHomePage(2);
    }
  }

  bool _onPopPage(Route route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }
    notifyListeners();
    return true;
  }
}

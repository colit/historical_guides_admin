import 'package:flutter/material.dart';

import '../core/app_state.dart';
import 'app_routes.dart';

class ShellRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final AppState _appState;

  ShellRouterDelegate({required AppState appState}) : _appState = appState {
    // _appState.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) {
    final pages = _appState.getPages();
    print(pages);
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        _appState.popPage();
        notifyListeners();
        return route.didPop(result);
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    assert(false);
  }
}

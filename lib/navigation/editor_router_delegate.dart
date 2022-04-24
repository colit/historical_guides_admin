import 'package:flutter/material.dart';
import 'package:historical_guides_admin/core/services/map_service.dart';
import 'package:provider/provider.dart';

import '../core/editor_state.dart';
import 'app_routes.dart';

class EditorRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  EditorRouterDelegate({required EditorState appState})
      : _editorState = appState;

  final EditorState _editorState;

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    assert(false);
  }

  @override
  Widget build(BuildContext context) {
    final pages = _editorState.getPages();
    final mapService = context.read<MapService>();
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        _editorState.popPage();
        mapService.onLeaveEditorPage();
        notifyListeners();
        return route.didPop(result);
      },
    );
  }
}

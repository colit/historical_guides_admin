import 'package:flutter/material.dart';

import '../ui/views/edit_tour/edit-poi/edit_poi_view.dart';
import '../ui/views/edit_tour/tour_infos/tour_infos_view.dart';

class EditorState extends ChangeNotifier {
  List<RouteSettings> _pages = [];

  void setInitialPageWith(String id) {
    _pages = [
      RouteSettings(
        name: 'tour_infos',
        arguments: id,
      ),
    ];
  }

  List<Page> getPages() {
    final pages = [
      for (final pageSettings in _pages) _createPage(pageSettings)
    ];
    return pages;
  }

  void pushPage({required String name, Object? arguments}) {
    _pages.add(RouteSettings(
      name: name,
      arguments: arguments,
    ));
    notifyListeners();
  }

  void popPage() {
    if (_pages.length > 1) {
      _pages.removeLast();
      notifyListeners();
    }
  }

  Page _createPage(RouteSettings settings) {
    switch (settings.name) {
      case 'poi_editor':
        return MaterialPage(
          key: ValueKey(settings.name),
          child: const EditPoIView(),
        );
      default:
        return MaterialPage(
          key: ValueKey(settings.name),
          child: TourInfosView(
            id: settings.arguments! as String,
          ),
        );
    }
  }
}

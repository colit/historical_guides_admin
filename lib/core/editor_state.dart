import 'package:flutter/material.dart';
import 'package:historical_guides_admin/ui/views/edit_image/edit_image_view.dart';
import 'package:historical_guides_admin/ui/views/images_list/images_list_view.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

import '../ui/views/edit_tour/edit_station/edit_station_view.dart';
import '../ui/views/edit_tour/tour_infos/tour_infos_view.dart';

class EditorState extends ChangeNotifier {
  List<RouteSettings> _pages = [];

  void setInitialPage([String? pageId, dynamic arguments]) {
    if (pageId != null) {
      _pages = [
        RouteSettings(
          name: pageId,
          arguments: arguments,
        ),
      ];
    }
  }

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
          child: EditStationView(
            station: settings.arguments as Station?,
          ),
        );
      case ImagesListView.viewId:
        return MaterialPage(
          key: ValueKey(settings.name),
          child: const ImagesListView(),
        );
      case EditImageView.viewId:
        return MaterialPage(
          key: ValueKey(settings.name),
          child: EditImageView(
            id: (settings.arguments ?? -1) as int,
          ),
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

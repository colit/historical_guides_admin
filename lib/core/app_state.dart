import 'package:flutter/material.dart';
import 'package:historical_guides_admin/navigation/app_routes.dart';
import 'package:historical_guides_admin/navigation/fade_animation_page.dart';
import 'package:historical_guides_admin/ui/views/edit_tour/edit_tour_view.dart';

import '../ui/views/create_tour/create_tour_view.dart';
import '../ui/views/images/images_map_view.dart';
import '../ui/views/images/images_view.dart';
import '../ui/views/setup/setup_view.dart';
import '../ui/views/tours/tours_view.dart';

class AppState extends ChangeNotifier {
  static const toursPath = '/';
  static const imagesPath = '/images';
  static const setupPath = '/setup';
  static const pageNotFoundPath = '/404';

  int _selectedIndex = 0;
  String? selectedPageId;

  List<RouteSettings> _pages = [];

  final _destinations = [toursPath, imagesPath, setupPath];

  String get currentDestination => _destinations[_selectedIndex];

  int get selectedIndex => _selectedIndex;

  final _pageNames = [TrackPickerPath.key, ImagesPath.key, SetupPath.key];

  set selectedIndex(int idx) {
    _selectedIndex = idx;
    print('set selectedIndex($idx)');
    _pages = [
      if (idx >= 0 && idx < _pageNames.length)
        RouteSettings(name: _pageNames[idx])
    ];
    // if (selectedPageId != null) {
    //   print('add page $selectedPageId');
    //   _pages.add(
    //     RouteSettings(
    //       name: 'tour_details',
    //       arguments: TourDetailArguments(selectedPageId!),
    //     ),
    //   );
    // }
    notifyListeners();
  }

  void initState(int idx) {
    print('initState: $idx');
    _selectedIndex = idx;
    _pages = [
      if (idx >= 0 && idx < _pageNames.length)
        RouteSettings(name: _pageNames[idx])
    ];
  }

  void setHomePage(int idx) {
    selectedPageId = null;
    selectedIndex = idx;
  }

  List<Page> getPages() {
    final pages = [
      for (final pageSettings in _pages) _createPage(pageSettings)
    ];
    return pages;
  }

  Page _createPage(RouteSettings settings) {
    switch (settings.name) {
      case TrackDetailsPath.key:
        return MaterialPage(
          key: ValueKey(settings.name),
          child: const CreateTrackView(),
        );
      case SetupPath.key:
        return FadeAnimationPage(
          key: ValueKey(settings.name),
          child: const SetupView(),
        );
      case ImagesPath.key:
        return FadeAnimationPage(
          key: ValueKey(settings.name),
          child: const ImagesMapView(),
        );
      case TourEditPath.key:
        return MaterialPage(
          key: ValueKey(settings.name),
          child: EditTourView(
            id: (settings.arguments as TourDetailArguments).id.toString(),
          ),
        );
      default:
        return FadeAnimationPage(
          key: ValueKey(settings.name),
          child: const ToursView(),
        );
    }
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
}

class TourDetailArguments extends Object {
  TourDetailArguments(
    this.id,
  );
  final String id;
}

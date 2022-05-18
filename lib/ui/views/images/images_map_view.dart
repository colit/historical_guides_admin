import 'package:flutter/material.dart';
import 'package:historical_guides_admin/ui/views/images_list/images_list_view.dart';
import 'package:historical_guides_admin/ui/views/map_view/map_view.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

import '../../../core/editor_state.dart';
import '../../../navigation/editor_router_delegate.dart';

class ImagesMapView extends StatefulWidget {
  const ImagesMapView({Key? key}) : super(key: key);

  @override
  State<ImagesMapView> createState() => _ImagesMapViewState();
}

class _ImagesMapViewState extends State<ImagesMapView> {
  bool mapReady = false;
  late final routerDelegate = EditorRouterDelegate(
    appState: context.read<EditorState>(),
  );

  late final backButtonDispatcher = Router.of(context)
      .backButtonDispatcher
      ?.createChildBackButtonDispatcher();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 5,
          child: Container(
            color: kColorSecondary,
            child: MapView(
              onMapReady: () {
                context
                    .read<EditorState>()
                    .setInitialPage(ImagesListView.viewId);
                setState(() {
                  mapReady = true;
                });
              },
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(color: kColorWhite),
            child: Consumer<EditorState>(builder: (context, value, child) {
              return mapReady
                  ? Router(
                      routerDelegate: routerDelegate,
                      backButtonDispatcher: backButtonDispatcher,
                    )
                  : Container();
            }),
          ),
        ),
      ],
    );
  }
}

// BaseWidget<ImagesMapModel>(
//         model: ImagesMapModel(
//           dataService: context.read<DataService>(),
//           mapService: context.read<MapService>(),
//         ),
//         // onModelReady: (model) => model.initModel(),
//         builder: (context, model, _) {
//           return model.state == ViewState.busy
//               ? const Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : 
//         });

import 'package:flutter/material.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

import '../../../core/app_state.dart';
import '../../../core/editor_state.dart';
import '../../../navigation/editor_router_delegate.dart';
import '../../widgets/round_icon_button.dart';
import '../map_view/map_view.dart';
import '../map_view/simple_map_view.dart';

class EditTourView extends StatefulWidget {
  const EditTourView({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<EditTourView> createState() => _EditTourViewState();
}

class _EditTourViewState extends State<EditTourView> {
  bool mapIsReady = false;
  late final routerDelegate = EditorRouterDelegate(
    appState: context.read<EditorState>(),
  );

  late final backButtonDispatcher = Router.of(context)
      .backButtonDispatcher
      ?.createChildBackButtonDispatcher();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          flex: 5,
          child: Stack(
            children: [
              SimpleMapView(onMapReady: () {
                if (!mapIsReady) {
                  context.read<EditorState>().setInitialPageWith(widget.id);
                  setState(() {
                    mapIsReady = true;
                  });
                }
              }),
              Padding(
                padding: const EdgeInsets.all(UIHelper.kHorizontalSpaceSmall),
                child: RoundIconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 24,
                  ),
                  onTap: () {
                    final appState = context.read<AppState>();
                    appState.selectedPageId = null;
                    appState.popPage();
                  },
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 3,
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(color: kColorWhite),
            child: Consumer<EditorState>(builder: (context, value, child) {
              return mapIsReady
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

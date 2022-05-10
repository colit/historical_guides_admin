import 'package:flutter/material.dart';
import 'package:historical_guides_admin/ui/views/edit_tour/tour_infos/tour_infos_model.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

import '../../../../core/editor_state.dart';
import '../../../../core/services/data_service.dart';
import '../../../../core/services/map_service.dart';
import '../../../widgets/text_input_widget.dart';

class TourInfosView extends StatelessWidget {
  const TourInfosView({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<TourInfosModel>(
      model: TourInfosModel(
        mapService: context.read<MapService>(),
        dataService: context.read<DataService>(),
      ),
      onModelReady: (model) => model.initModel(id),
      builder: (context, model, child) {
        return model.state == ViewState.busy
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                appBar: AppBar(
                  title: Text(model.tour!.name),
                ),
                floatingActionButton: model.tourUpdated
                    ? FloatingActionButton(onPressed: model.saveTour)
                    : null,
                body: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextInputWidget(
                            value: model.tour!.name,
                            maxLines: 1,
                            labelText: 'Name',
                            onChange: model.updateTourName,
                          ),
                          TextInputWidget(
                            value: model.tour!.description ?? '',
                            maxLines: 10,
                            labelText: 'Beschreibung',
                            onChange: model.updateTourDescription,
                          ),
                          Container(
                            padding: const EdgeInsets.all(
                              UIHelper.kHorizontalSpaceSmall,
                            ),
                            color: Colors.greenAccent,
                            child: Text(model.tour!.geoJSON),
                          ),
                          Container(
                            padding: const EdgeInsets.all(
                              UIHelper.kHorizontalSpaceSmall,
                            ),
                            color: Colors.blueAccent,
                            child:
                                Text(model.tour!.vectorAssets ?? 'no assets'),
                          ),
                          Container(
                            color: Colors.blueGrey,
                            padding: const EdgeInsets.all(
                              UIHelper.kHorizontalSpaceSmall,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ReorderableListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  header: const Text('Stationen'),
                                  itemCount: model.pointsOfInterest.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          StationListItem(
                                    key: ValueKey(
                                        model.pointsOfInterest[index].id),
                                    item: model.pointsOfInterest[index],
                                    onDelete: () => model.deletePoint(index),
                                  ),
                                  onReorder: (int oldIndex, int newIndex) {
                                    model.updateStationsOrder(
                                        oldIndex, newIndex);
                                  },
                                ),
                                UIHelper.verticalSpaceSmall(),
                                ElevatedButton(
                                  onPressed: () => context
                                      .read<EditorState>()
                                      .pushPage(name: 'poi_editor'),
                                  child: const Text('Add Point of Interest'),
                                )
                              ],
                            ),
                            height: 600,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
      },
    );
  }
}

class StationListItem extends StatelessWidget {
  const StationListItem({
    Key? key,
    required this.item,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);

  final Station item;
  final void Function()? onDelete;
  final void Function()? onEdit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            child: InkWell(
              onTap: () => onDelete?.call(),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.delete,
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              child: InkWell(
                onTap: () => context.read<EditorState>().pushPage(
                      name: 'poi_editor',
                      arguments: item,
                    ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(item.titel),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

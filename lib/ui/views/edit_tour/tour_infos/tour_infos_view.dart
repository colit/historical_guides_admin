import 'package:flutter/material.dart';
import 'package:historical_guides_admin/ui/views/edit_tour/tour_infos/tour_infos_model.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

import '../../../../core/editor_state.dart';
import '../../../../core/services/data_service.dart';
import '../../../../core/services/map_service.dart';

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
                body: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            color: Colors.amberAccent,
                            child: Text(model.tour!.name),
                            height: 60,
                          ),
                          Container(
                            color: Colors.greenAccent,
                            child: Text(model.tour!.geoJSON),
                            height: 60,
                          ),
                          Container(
                            color: Colors.blueAccent,
                            child:
                                Text(model.tour!.vectorAssets ?? 'no assets'),
                            height: 60,
                          ),
                          Container(
                            color: Colors.blueGrey,
                            child: Column(
                              children: [
                                const Text('Sehenswürdigkeiten'),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      model.tour!.pointsOfInterest.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(model
                                        .tour!.pointsOfInterest[index].titel),
                                  ),
                                ),
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

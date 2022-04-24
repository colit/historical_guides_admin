import 'package:flutter/material.dart';
import 'package:historical_guides_admin/core/services/data_service.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

import '../../../core/app_state.dart';
import 'tours_model.dart';

class ToursView extends StatelessWidget {
  const ToursView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<AppState>().pushPage(
              name: 'track_details',
            ),
        child: const Icon(Icons.add),
      ),
      body: BaseWidget<ToursModel>(
          model: ToursModel(
            appState: context.read<AppState>(),
            dataService: context.read<DataService>(),
          ),
          onModelReady: (model) => model.getTours(),
          builder: (context, model, child) {
            return model.state == ViewState.busy
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 350,
                          maxWidth: 640,
                        ),
                        child: ListView.builder(
                          itemCount: model.tours.length,
                          itemBuilder: (context, index) {
                            return Material(
                              child: InkWell(
                                onTap: () => model.editTour(index),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(model.tours[index].name),
                                      ),
                                      DeleteButton(
                                        onTap: () => model.deleteTour(index),
                                        onReady: () => model.updateTours(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
          }),
    );
  }
}

class DeleteButton extends StatefulWidget {
  const DeleteButton({
    Key? key,
    this.onTap,
    this.onReady,
  }) : super(key: key);

  final Future<bool> Function()? onTap;
  final void Function()? onReady;

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  var _state = ViewState.idle;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          setState(() => _state = ViewState.busy);
          widget.onTap?.call().then((success) {
            if (success) {
              setState(() => _state = ViewState.idle);
              widget.onReady?.call();
            }
          });
        },
        child: SizedBox(
          width: 44,
          height: 44,
          child: _state == ViewState.idle
              ? const Icon(Icons.delete)
              : const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:historical_guides_admin/core/app_state.dart';
import 'package:provider/provider.dart';

import '../../../core/models/track_details.dart';

class TrackPickerView extends StatefulWidget {
  const TrackPickerView({Key? key}) : super(key: key);

  @override
  State<TrackPickerView> createState() => _TrackPickerViewState();
}

class _TrackPickerViewState extends State<TrackPickerView> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? _fileName;
  bool _isLoading = false;
  bool _userAborted = false;
  List<PlatformFile>? _paths;
  PlatformFile? _file;
  String? _directoryPath;

  void _pickFiles() async {
    _resetState();
    try {
      _directoryPath = null;
      _file = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['gpx'],
      ))
          ?.files
          .first;
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    if (_file != null) {
      final bytes = _file!.bytes;
      if (bytes != null) {
        final xml = String.fromCharCodes(bytes);
        context.read<AppState>().pushPage(
              name: 'track_details',
              arguments: TrackDetails(xml),
            );
      }
    }
    setState(() {
      _isLoading = false;
      _fileName = _file != null ? _file!.name : '...';
      _userAborted = _paths == null;
    });
  }

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _userAborted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.read<AppState>().pushPage(
                name: 'track_details',
              ),
          child: const Icon(Icons.add),
        ),
        body: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_directoryPath != null) Text(_directoryPath!),
                    if (_fileName != null) Text(_fileName!),
                    // const SizedBox(height: 10),
                    // ElevatedButton(
                    //   onPressed: _pickFiles,
                    //   child: const Text('Pick file'),
                    // ),
                    const SizedBox(height: 10),
                    if (_userAborted)
                      const Text('Du hast das Upload abgebrochen'),
                  ],
                ),
        ));
  }
}

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilePickerView extends StatefulWidget {
  const FilePickerView({
    Key? key,
    required this.onData,
    this.extensions = const [],
  }) : super(key: key);

  final void Function(Uint8List?) onData;
  final List<String> extensions;

  @override
  State<FilePickerView> createState() => _FilePickerViewState();
}

class _FilePickerViewState extends State<FilePickerView> {
  String? _fileName;
  bool _isLoading = false;
  PlatformFile? _file;

  void _logException(String message) {
    print(message);
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _fileName = null;
    });
  }

  void _pickFiles() async {
    _resetState();
    try {
      _file = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: widget.extensions,
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
        widget.onData.call(bytes);
      }
    }
    setState(() {
      _isLoading = false;
      _fileName = _file != null ? _file!.name : '...';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? const CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_fileName == null)
                  ElevatedButton(
                    onPressed: _pickFiles,
                    child: const Text('Select file'),
                  )
                else
                  Row(children: [
                    Text(_fileName!),
                    Material(
                      child: InkWell(
                          child: const Icon(Icons.close),
                          onTap: () {
                            widget.onData.call(null);
                            setState(() {
                              _isLoading = false;
                              _fileName = null;
                            });
                          }),
                    )
                  ]),
              ],
            ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

class ModalViewService {
  late Function(Widget) _showDialogListener;
  late Function() _closeDialogListener;
  Completer? _dialogCompleter;

  void registerViewListener({
    required Function(Widget) opener,
    required Function() completer,
  }) {
    _showDialogListener = opener;
    _closeDialogListener = completer;
  }

  Future show(Widget content) {
    _dialogCompleter = Completer();
    _showDialogListener(content);
    return _dialogCompleter!.future;
  }

  // void complete() {
  //   _dialogCompleter!.complete();
  //   _dialogCompleter = null;
  // }

  void close() {
    print('_dialogCompleter: $_dialogCompleter');
    _dialogCompleter!.complete();
    _dialogCompleter = null;
    _closeDialogListener();
  }
}

import 'package:flutter/material.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

class TextInputWidget extends StatefulWidget {
  const TextInputWidget({
    Key? key,
    this.value = '',
    this.onChange,
    this.maxLines = 1,
    this.labelText,
  }) : super(key: key);

  final String value;
  final void Function(String)? onChange;
  final int maxLines;
  final String? labelText;

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  late TextEditingController controller;

  bool changed = false;

  @override
  void initState() {
    controller = TextEditingController(
      text: widget.value,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(UIHelper.kHorizontalSpaceSmall),
      color: changed ? const Color(0xffeeeeee) : kColorWhite,
      child: TextField(
        controller: controller,
        maxLines: widget.maxLines,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.none,
        autocorrect: false,
        onChanged: (value) {
          widget.onChange?.call(value);
          setState(() {
            changed = true;
          });
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          labelText: widget.labelText,
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

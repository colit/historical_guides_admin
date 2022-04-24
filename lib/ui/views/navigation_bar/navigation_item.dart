import 'package:flutter/material.dart';

class NavigationItem extends StatelessWidget {
  const NavigationItem(
      {Key? key, required this.label, this.selected = false, this.onTap})
      : super(key: key);

  final String label;
  final bool selected;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      waitDuration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.only(left: 20),
      message: label,
      child: Material(
        color: selected ? Colors.white : Colors.amberAccent,
        child: InkWell(
          mouseCursor: SystemMouseCursors.click,
          hoverColor: Colors.white,
          onTap: () {
            onTap?.call();
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'navigation_item.dart';

class NavigationBarWeb extends StatelessWidget {
  const NavigationBarWeb({
    Key? key,
    this.onTap,
    this.selectedIndex,
  }) : super(key: key);

  final Function(int)? onTap;
  final int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationItem(
          label: 'Tracks',
          onTap: () => onTap?.call(0),
          selected: selectedIndex == 0,
        ),
        NavigationItem(
          label: 'Bilder',
          onTap: () => onTap?.call(1),
          selected: selectedIndex == 1,
        ),
        NavigationItem(
          label: 'Einstellungen',
          onTap: () => onTap?.call(2),
          selected: selectedIndex == 2,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    Key? key,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  final void Function()? onTap;

  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        width: 40,
        height: 40,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Material(
          child: InkWell(
            onTap: onTap?.call,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Center(
                child: icon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Clickable extends StatefulWidget {
  final void Function()? onClick;
  final void Function(bool hovered)? onHover;
  final Widget child;
  const Clickable({
    this.onClick,
    this.onHover,
    required this.child,
    Key? key
  }) : super(key: key);

  @override
  State<Clickable> createState() => _ClickableState();
}

class _ClickableState extends State<Clickable> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        widget.onHover?.call(true);
      },
      onExit : (event) {
        widget.onHover?.call(false);
      },
      child: GestureDetector(
        onTap: () {
          widget.onClick?.call();
        },
        child: widget.child,
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../FTLStyle.dart';

class FTLIconButton extends StatefulWidget {
  final void Function(bool hovered)? onHover;
  final void Function()? onClick;
  final IconData iconData;
  final double size;
  final EdgeInsets margin;
  final double width;
  final double height;
  const FTLIconButton(this.iconData, {
    this.width = 100,
    this.height = 100,
    this.margin = const EdgeInsets.all(0.0),
    this.onClick,
    this.onHover,
    this.size = 18,
    Key? key,
  }) : super(key: key);

  @override
  State<FTLIconButton> createState() => _FTLIconButtonState();
}

class _FTLIconButtonState extends State<FTLIconButton> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return FTLButton(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      onHover: (hovered) {
        setState(() {
          this.hovered = hovered;
        });
        widget.onHover?.call(hovered);
      },
      onClick: widget.onClick,
      child : Icon(widget.iconData,
        color: hovered ? FTLColors.selected : FTLColors.normal,
        size: widget.size,
      ),
    );
  }
}

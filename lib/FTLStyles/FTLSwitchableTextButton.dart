import 'package:flutter/material.dart';

import '../Clickable.dart';
import '../FTLStyle.dart';

class FTLSwitchableTextButton extends StatefulWidget {
  final int currentIndex;
  final List<String> items;
  final String? message;
  final String errorMessage;
  final void Function(int index) onClick;
  const FTLSwitchableTextButton({
    this.message,
    this.errorMessage = "",
    required this.items,
    required this.currentIndex,
    required this.onClick,
    Key? key
  }) : super(key: key);

  @override
  State<FTLSwitchableTextButton> createState() => _FTLSwitchableTextButtonState();
}

class _FTLSwitchableTextButtonState extends State<FTLSwitchableTextButton> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return Clickable(
      child: Text("${widget.message ?? ""}${widget.items[widget.currentIndex]}",
          style: TextStyle(
            fontSize: 20.0,
            color : hovered ? FTLColors.selected : FTLColors.normal,
          )
      ),
      onClick: () => widget.onClick(widget.currentIndex),
      onHover: (hovered) {
        setState(() {
          this.hovered = hovered;
        });
      },
    );
  }
}

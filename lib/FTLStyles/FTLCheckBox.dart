import 'package:flutter/material.dart';
import '../FTLStyle.dart';

class FTLCheckBox extends StatefulWidget {
  final double width;
  final double height;
  final bool selected;
  final void Function(bool enabled) onClick;
  const FTLCheckBox({
    this.width = 30,
    this.height = 30,
    required this.onClick,
    required this.selected,
    Key? key
  }) : super(key: key);

  @override
  State<FTLCheckBox> createState() => _FTLCheckBoxState();
}

class _FTLCheckBoxState extends State<FTLCheckBox> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return FTLButton(
      width: widget.width,
      height: widget.height,
      onHover: (hovered) {
        setState(() {
          this.hovered = hovered;
        });
      },
      onClick: () {
        widget.onClick(!widget.selected);
      },
      child: (widget.selected ? Icon(Icons.check,
          color: hovered ? FTLColors.selected : FTLColors.normal,
          size: 13
      ) : const SizedBox()),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ftl_mv_save_manager/ColorStates.dart';
import 'FTLButton.dart';
import 'FTLColors.dart';
import 'ColorStates.dart';

class FTLTextButton extends StatefulWidget {
  final String text;
  final double fontSize;
  final double width;
  final double height;
  final EdgeInsets margin;
  final InvokeFunc? onClick;
  final ColorStates? textColors;
  final ColorStates? borderColors;

  const FTLTextButton(this.text,
    {
      this.textColors,
      this.borderColors,
      this.fontSize = 20.0,
      this.width = double.infinity,
      this.height = double.infinity,
      this.margin = const EdgeInsets.all(0.0),
      this.onClick,
      Key? key
    }) : super(key: key);

  @override
  State<FTLTextButton> createState() => _FTLTextButtonState();
}

class _FTLTextButtonState extends State<FTLTextButton> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    var textColors = widget.textColors ?? ColorStates();
    var borderColors = widget.borderColors ?? ColorStates();

    return FTLButton(
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
        onClick: widget.onClick,
        borderColors: borderColors,
        onEnter : () => setState(() => selected = true),
        onExit : () => setState(() => selected = false),
        child: Text(widget.text,
          style: TextStyle(
            fontSize: widget.fontSize,
            color: selected ? textColors.hover : textColors.normal,
          ),
        ),
    );
  }
}

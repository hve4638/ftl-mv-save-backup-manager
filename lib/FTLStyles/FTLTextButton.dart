import 'package:flutter/material.dart';
import 'package:ftl_mv_save_manager/ColorStates.dart';
import 'FTLButton.dart';
import 'FTLColors.dart';
import '../ColorStates.dart';

class FTLTextButton extends StatefulWidget {
  final String text;
  final double fontSize;
  final double width;
  final double height;
  final EdgeInsets margin;
  final InvokeFunc? onClick;
  final ColorStates? textColors;
  final ColorStates? borderColors;
  final ColorStates? backgroundColors;

  const FTLTextButton(this.text,
    {
      this.textColors,
      this.borderColors,
      this.backgroundColors,
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
    final defaultTextAndBorderColorStates = ColorStates(normal: FTLColors.normal, hover: FTLColors.selected);
    var textColors = widget.textColors ?? defaultTextAndBorderColorStates;
    var borderColors = widget.borderColors ?? defaultTextAndBorderColorStates;
    var backgroundColors = widget.backgroundColors ?? ColorStates.all(FTLColors.blueAccent);

    return FTLButton(
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
        onClick: widget.onClick,
        backgroundColors: backgroundColors,
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

import 'package:flutter/material.dart';

import '../ColorStates.dart';
import 'FTLButtonStyle.dart';
import 'FTLColors.dart';
import 'FTLTextButton.dart';
import '../Messages/FTLMessage.dart';

class FTLToggleTextButton extends StatefulWidget {
  final String text;
  final void Function(bool) onChanged;
  final bool selected;
  final FTLButtonStyle? normalButtonStyle;
  final FTLButtonStyle? selectedButtonStyle;
  final double fontSize;
  final double width;
  final double height;
  final EdgeInsets margin;
  const FTLToggleTextButton(this.text, {
    required this.selected,
    required this.onChanged,
    this.normalButtonStyle,
    this.selectedButtonStyle,
    this.fontSize = 20.0,
    this.width = double.infinity,
    this.height = double.infinity,
    this.margin = const EdgeInsets.all(0.0),
    Key? key,
  }) : super(key: key);

  @override
  State<FTLToggleTextButton> createState() => _FTLToggleTextButtonState();
}

class _FTLToggleTextButtonState extends State<FTLToggleTextButton> {
  final selectedButtonStyleDefault = FTLButtonStyle(
    border: ColorStates(
      normal: FTLColors.normal,
      hover: FTLColors.selected,
    ),
    background: ColorStates(
      normal: FTLColors.blueAccent,
      hover: FTLColors.blueAccent,
    ),
    child: ColorStates(
      normal: FTLColors.normal,
      hover: FTLColors.selected,
    ),
  );
  final normalButtonStyleDefault = FTLButtonStyle(
    border: ColorStates(
      normal: FTLColors.normal,
      hover: FTLColors.selected,
    ),
    background: ColorStates(
      normal: FTLColors.blueAccent,
      hover: FTLColors.blueAccent,
    ),
    child: ColorStates(
      normal: FTLColors.normal,
      hover: FTLColors.selected,
    ),
  );

  @override
  Widget build(BuildContext context) {
    var normalButtonStyle = widget.normalButtonStyle ?? normalButtonStyleDefault;
    var selectedButtonStyle = widget.selectedButtonStyle ?? selectedButtonStyleDefault;

    return FTLTextButton(widget.text,
        fontSize : widget.fontSize,
        width: widget.width,
        height: widget.height,
        margin : const EdgeInsets.all(8),
        backgroundColors: widget.selected ? selectedButtonStyle.background : normalButtonStyle.background,
        borderColors: widget.selected ? selectedButtonStyle.border : normalButtonStyle.border,
        textColors: widget.selected ? selectedButtonStyle.child : normalButtonStyle.child,
        onClick: () {
          widget.onChanged(!widget.selected);
        },
    );
  }
}

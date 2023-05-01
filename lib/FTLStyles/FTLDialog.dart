import 'package:flutter/material.dart';
import 'FTLColors.dart';

class FTLDialog extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;
  final double borderThickness;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color color;
  final Color borderColor;
  const FTLDialog({
    required this.child,
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderThickness = 3,
    this.padding = const EdgeInsets.all(0),
    this.margin = const EdgeInsets.all(0),
    this.borderColor = FTLColors.border,
    this.color = FTLColors.blueBackground,
    Key? key
  }) : super(key: key);

  @override
  State<FTLDialog> createState() => _FTLDialogState();
}

class _FTLDialogState extends State<FTLDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width : widget.width,
        height : widget.height,
        padding: widget.padding,
        margin: widget.margin,
        decoration: BoxDecoration(
          color: widget.color,
          border: Border.all(
            color: widget.borderColor,
            width: widget.borderThickness,
          ),
        ),
        child : widget.child,
    );
  }
}

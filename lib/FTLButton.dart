import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:ftl_mv_save_manager/FTLDialog.dart';

import 'ColorStates.dart';
import 'FTLColors.dart';
typedef InvokeFunc = void Function();
typedef OnChangedFunc = void Function(bool);

class FTLButton extends StatefulWidget {
  final InvokeFunc? onEnter;
  final InvokeFunc? onExit;
  final InvokeFunc? onClick;
  final OnChangedFunc? onHover;
  final Widget child;
  final double width;
  final double height;
  final EdgeInsets margin;
  final ColorStates? borderColors;
  const FTLButton({
    required this.child,
    this.borderColors,
    this.onHover,
    this.onEnter,
    this.onExit,
    this.onClick,
    this.width = double.infinity,
    this.height = double.infinity,
    this.margin = const EdgeInsets.all(0.0),
    Key? key,
  }) : super(key: key);

  @override
  State<FTLButton> createState() => _FTLButtonState();
}

class _FTLButtonState extends State<FTLButton> {
  bool entered = false;
  //Color borderColor = FTLColors.border;

  @override
  Widget build(BuildContext context) {
    var borderColors = widget.borderColors ?? ColorStates();

    return Container(
      width : widget.width,
      height : widget.height,
      padding : widget.margin,
      child: MouseRegion(
        onEnter: (event) {
          setState(() => entered = true);
          widget.onEnter?.call();
          widget.onHover?.call(true);
        },
        onExit : (event) {
          setState(() => entered = false);
          widget.onExit?.call();
          widget.onHover?.call(false);
        },
        child: GestureDetector(
          onTap : () {
            widget.onClick?.call();
          },
          child: FTLDialog(
            color : FTLColors.blueAccent,
            borderColor: entered ? borderColors.hover : borderColors.normal,
            child: Center(
                child : widget.child
            ),
          ),
        ),
      ),
    );
  }
}

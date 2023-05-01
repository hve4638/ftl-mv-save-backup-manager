import 'package:flutter/material.dart';
import 'FTLStyle.dart';

class ColorStates {
  late Color normal;
  late Color hover;
  late Color selected;
  late Color down;

  ColorStates({
    this.normal = FTLColors.normal,
    this.hover = FTLColors.selected,
    this.selected = FTLColors.selected,
    this.down = FTLColors.normal,
  });

  ColorStates.all(Color color) {
    normal = color;
    hover = color;
    selected = color;
    down = color;
  }
}
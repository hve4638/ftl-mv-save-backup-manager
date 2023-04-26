import 'package:flutter/material.dart';
import 'FTLColors.dart';

class ColorStates {
  Color normal;
  Color hover;
  Color selected;
  Color down;

  ColorStates({
    this.normal = FTLColors.normal,
    this.hover = FTLColors.selected,
    this.selected = FTLColors.selected,
    this.down = FTLColors.normal,
  });
}
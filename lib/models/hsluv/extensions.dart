import 'package:flutter/painting.dart';
import 'package:klr/models/hsluv/hsluv-color.dart';

extension ColorExtensions on Color {
  HSLuvColor toHSLuvColor()
    => HSLuvColor.fromColor(this);
}

extension HSLColorExtensions on HSLColor {
  HSLuvColor toHSLuvColor()
    => HSLuvColor.fromColor(this.toColor());
}
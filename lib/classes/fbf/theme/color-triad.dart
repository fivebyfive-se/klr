import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:klr/helpers/color.dart';

class ColorTriad {
  ColorTriad(this.base, this.dark, this.light);
  
  ColorTriad.fromBase(this.base)
    : this.dark  = base.deltaLightness(-33.3).deltaSaturation(11.1),
      this.light = base.deltaLightness(40.0);
  
  final Color base;
  final Color dark;
  final Color light;

  LinearGradient toGradient(
    {AxisDirection direction = AxisDirection.down}
  )
  => LinearGradient(
      colors: [dark, base, light],
      begin: dirBegin(direction),
      end: dirEnd(direction)
    );

  Color choose(bool choice) => choice ? light : dark;
}

Alignment dirBegin(AxisDirection dir)
  => dir == AxisDirection.down ? Alignment.topCenter
    : dir == AxisDirection.up ? Alignment.bottomCenter
      : dir == AxisDirection.left ? Alignment.centerRight
        : Alignment.centerLeft;

Alignment dirEnd(AxisDirection dir)
  => dir == AxisDirection.down ? Alignment.bottomCenter
    : dir == AxisDirection.up ? Alignment.topCenter
      : dir == AxisDirection.left ? Alignment.centerLeft
        : Alignment.centerRight;


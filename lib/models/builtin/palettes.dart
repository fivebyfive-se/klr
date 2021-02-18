import 'package:flutter/painting.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/helpers/color.dart';

class Palettes {
  static Map<String, Color> vhs60 = {
    'Blue Dart Frog': Color(0xff0076B3), // h: 200 + 60 
    'Blue Magenta':   Color(0xff5C2EB8), // h: 260 + 60
    'Violet Red':     Color(0xffB3127D), // h: 320 + ...
    'Taisha':         Color(0xffD96226), // h:  20
    'Old Lime':       Color(0xffAACC66), // h:  80
    'Wintergreen':    Color(0xff49F281), // h: 140
  };
}

extension PaletteExtensions on Palette {
  void addHexValues(Iterable<String> hexValues) 
    => this.colors.addAll(
      hexValues.map((v) => colorFromHex(v).toHSL())
        .map((c) => PaletteColor(color: c)).toList()
    );
}
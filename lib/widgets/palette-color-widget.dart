import 'package:flutter/material.dart';
import 'package:klr/app/klr.dart';

import 'package:klr/helpers/color.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/widgets/btn.dart';
import 'package:klr/widgets/txt.dart';

class PaletteColorWidget extends StatelessWidget {
  PaletteColorWidget({
    this.onPressed,
    this.paletteColor,
    this.size = 50,
    this.containerColor = Colors.transparent

  });

  final Color containerColor;
  final PaletteColor paletteColor;
  final double size;
  final void Function() onPressed;

  Color get color => paletteColor.color.toColor();
  String get hex  => paletteColor.color.toHex();
  String get name => paletteColor.name;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(color: containerColor, width: 4.0)
        )
      ),
      child: btn(hex,
        backgroundColor: color,
        onPressed: onPressed
      ),
    );
  }
}

enum ColorType {
  original,
  shade,
  harmony
} 
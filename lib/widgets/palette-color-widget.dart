import 'package:flutter/material.dart';
import 'package:klr/app/klr.dart';

import 'package:klr/helpers/color.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/widgets/txt.dart';

class PaletteColorWidget extends StatelessWidget {
  PaletteColorWidget({
    this.paletteColor,
    this.onPressed,
    this.onGeneratedPressed,
    this.size = 50
  });

  final PaletteColor paletteColor;
  final double size;
  final void Function() onPressed;
  final void Function(PaletteColor paletteColor, Color newColor, ColorType type) onGeneratedPressed;

  Color get color => paletteColor.color.toColor();
  String get hex  => paletteColor.color.toHex();
  String get name => paletteColor.name;
  List<Color> get generatedColors
    => paletteColor.transformedColors.map((c) => c.toColor())
            .toList();
  List<Color> get shades
    => paletteColor.shades.map((c) => c.toColor()).toList();

  @override
  Widget build(BuildContext context) {
    final isCurrColor = (Color c) => c.toHex() == color.toHex();

    final btn = (Color c, double sz, ColorType type) {
      final lum = c.computeLuminance();
      final fg = lum < 0.5 ? Klr.theme.foreground : Klr.theme.background;
      final height = isCurrColor(c) ? sz : sz / 2;
      return TextButton(
        onPressed: isCurrColor(c) 
          ? onPressed : 
          () => onGeneratedPressed(paletteColor, c, type),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(c),
          minimumSize:  MaterialStateProperty.all(Size(sz, height)),
        ),

        child: Txt(c.toHex(),
          isCurrColor(c) ? TxtType.strong : TxtType.em,
          style: TextStyle(color: fg))
      );
    };
    return Container(
      height: size + 10,
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ...shades.map(
            (c) => btn(c, size, isCurrColor(c) ? ColorType.original : ColorType.shade)
          ).toList(),
          ...generatedColors.map((c) => btn(c, size, ColorType.harmony)).toList()
        ],
      )
    );
  }
}

enum ColorType {
  original,
  shade,
  harmony
} 
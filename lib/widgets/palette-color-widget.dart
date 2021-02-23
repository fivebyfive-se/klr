import 'package:flutter/material.dart';
import 'package:klr/app/klr.dart';

import 'package:klr/helpers/color.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/widgets/txt.dart';

class PaletteColorWidget extends StatelessWidget {
  PaletteColorWidget({
    this.onPressed,
    this.onGeneratedPressed,
    this.paletteColor,
    this.size = 50,
    this.showGenerated,
    this.containerColor = Colors.transparent

  });

  final Color containerColor;
  final bool showGenerated;
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
      final height = isCurrColor(c) ? sz : sz / (type == ColorType.shade ? 1.5 : 2);
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
      height: size,
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
      decoration: BoxDecoration(
        // color: color,
        border: BorderDirectional(
          bottom: BorderSide(color: containerColor, width: 4.0)
        )
      ),
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: showGenerated ? [
          btn(color, size, ColorType.original),
          ...generatedColors.map((c) => btn(c, size, ColorType.harmony)).toList()
        ] : [
          btn(color, size, ColorType.original)
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
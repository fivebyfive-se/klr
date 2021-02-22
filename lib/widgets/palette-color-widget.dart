import 'package:flutter/material.dart';
import 'package:klr/app/klr.dart';

import 'package:klr/helpers/color.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/widgets/txt.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class PaletteColorWidget extends StatelessWidget {
  PaletteColorWidget({this.paletteColor, this.onPressed, this.size = 50});

  final PaletteColor paletteColor;
  final double size;
  final void Function() onPressed;

  Color get color => paletteColor.color.toColor();
  String get hex  => paletteColor.color.toHex();
  String get name => paletteColor.name;
  List<Color> get generatedColors
    => paletteColor.transformedColors.map((c) => c.toColor())
            .toList();

  @override
  Widget build(BuildContext context) {
    final btn = (Color c, double sz) => TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(c),
        minimumSize:  MaterialStateProperty.all(Size(sz, sz))
      ),
      child: Txt.p(c.toHex(), style: TextStyle(
        color: c.computeLuminance() < 0.5 
            ? Klr.theme.foreground : Klr.theme.background
      ))
    );
    return Container(
      height: size + 10,
      child: Wrap(
        alignment: WrapAlignment.start,
        children: [
          btn(color, size),
          ...generatedColors.map((c) => btn(c, size)).toList()
        ],
      )
    );
  }
}
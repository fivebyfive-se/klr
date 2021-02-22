import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:klr/klr.dart';
import 'package:klr/helpers/color.dart';
import 'package:klr/helpers/iterable.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/services/app-state-service.dart';
import 'package:klr/widgets/btn.dart';
import 'package:klr/widgets/togglable-text-editor.dart';
import 'package:klr/widgets/txt.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

void showPaletteColorDialog(BuildContext context, PaletteColor paletteColor)
  => showDialog(
    context: context, 
    builder: (context) => buildPaletteColorDialog(context, paletteColor)
  );

StatefulBuilder buildPaletteColorDialog(BuildContext context, PaletteColor paletteColor) {
  final viewportSize = MediaQuery.of(context).size;
  final harmonies = appStateService().snapshot.harmonies
    .order<Harmony>((a, b) => a.name.compareTo(b.name)).toList();
  final harmonyById = (String id) => harmonies.firstWhere((h) => h.uuid == id);
  final harmonyNameById = (String id) => id == null || id == "" ? 'None' : harmonyById(id).name;

  return StatefulBuilder(
    builder: (context, setState) {
      final saveColor = () {
        paletteColor.save();
        setState(() {});
      };
      final setColor = (Color col) {
        paletteColor.color = col.toHSL();
        saveColor();
      };
      final selectHarmony = (String uuid) {
        paletteColor.harmony = uuid;
        paletteColor.transformations.clear();
        if (uuid != null && uuid != "") {
          final h = harmonyById(uuid);
          paletteColor.transformations.addAll(
            h.transformations.toList()
          );
        }
        saveColor();
      };
      final addShade = (int dir) {
        final currDeltas = paletteColor.shadeDeltas;
        if (dir < 0) {
          final shade = min(currDeltas.isEmpty ? 0 : currDeltas.min(), 0) - 12.5;
          paletteColor.shadeDeltas = [shade, ...currDeltas];
        } else {
          final shade = max(currDeltas.isEmpty ? 0 : currDeltas.max(), 0) + 12.5;
          paletteColor.shadeDeltas = [...currDeltas, shade];
        }
        saveColor();
      };
      final removeShade = (int dir) {
        final currDeltas = paletteColor.shadeDeltas;
        if (currDeltas.isNotEmpty) {
          if (dir < 0) {
            currDeltas.removeAt(0);
          } else {
            currDeltas.removeLast();
          }
          paletteColor.shadeDeltas = [...currDeltas];
        }
        saveColor();
      };
 
      return AlertDialog(
            backgroundColor: Klr.theme.dialogBackground,
            title: TogglableTextEditor(
              initalText: paletteColor.name,
              onChanged: (v) {
                paletteColor.name = v;
                saveColor();
              },
            ),
            actions: [
              btn(
                "Close",
                onPressed: () => Navigator.pop(context),
              )
            ],
            content: Container(
              width: viewportSize.width - viewportSize.width / 3,
              height: viewportSize.height - viewportSize.height / 3,
              child: ListView(
                children: <Widget>[
                  Container(
                    height: viewportSize.height / 6,
                    child: ColorPicker(
                      pickerColor: paletteColor.color.toColor(),
                      onColorChanged: setColor,
                      colorPickerWidth: viewportSize.width / 4,
                      enableAlpha: true,
                      displayThumbColor: true,
                      showLabel: false,
                      paletteType: PaletteType.hsl,
                      pickerAreaBorderRadius: const BorderRadius.only(
                        topLeft: const Radius.circular(4.0),
                        topRight: const Radius.circular(4.0),
                      ),
                    ),
                  ),
                  Divider(),
                  Container(
                    height: viewportSize.height / 8,
                    child: Wrap(
                      children: [
                        Txt.subtitle2('Harmony/generator:'),
                        Txt.subtitle2(' '),
                        PopupMenuButton<String>(
                          initialValue: paletteColor.harmony,
                          child: Txt.subtitle2(harmonyNameById(paletteColor.harmony)),
                          onSelected: selectHarmony,
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: "",
                              child: Text('None')
                            ),
                            PopupMenuDivider(),
                            ...harmonies.map((h) => PopupMenuItem(
                              child: Text(h.name),
                              value: h.uuid
                            )).toList(),
                        ]),
                        
                      ],
                    )
                  ),
                  Container(
                    height: viewportSize.height / 8,
                    child: paletteColor.harmony == null ? null
                      : Wrap(
                        children: [
                          ...paletteColor.transformedColors.map(
                              (t) => Icon(
                                LineAwesomeIcons.square_full,
                                color: t.toColor(),
                                size: 32.0
                              ))
                        ],
                      )
                  ),
                  Divider(),
                  Container(
                    height: viewportSize.height / 8,
                    child: Column(
                      children: [
                        Txt.subtitle2("Shades:"),
                        Wrap(
                          children: [
                            IconButton(
                              icon: Icon(LineAwesomeIcons.minus_square, size: 32.0),
                              onPressed: () => removeShade(-1),
                            ),
                            IconButton(
                              icon: Icon(LineAwesomeIcons.plus_square, size: 32.0),
                              onPressed: () => addShade(-1),
                            ),
                            ...paletteColor.shades.map((s) => Icon(
                                LineAwesomeIcons.square_full,
                                color: s.toColor()
                              )
                            ),
                            IconButton(
                              icon: Icon(LineAwesomeIcons.plus_square, size: 32.0),
                              onPressed: () => addShade(1),
                            ),
                            IconButton(
                              icon: Icon(LineAwesomeIcons.minus_square, size: 32.0),
                              onPressed: () => removeShade(1),
                            ),
                          ]
                        )
                      ],
                    )
                  ),
                  
                ]
              )
            )
          );
        }
  );
}
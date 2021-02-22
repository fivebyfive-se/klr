import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:klr/klr.dart';
import 'package:klr/helpers/color.dart';
import 'package:klr/helpers/iterable.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/services/app-state-service.dart';
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
              TextButton(
                child: Text("Close"),
                onPressed: () => Navigator.pop(context),
              )
            ],
            content: Container(
              width: viewportSize.width - 150,
              height: viewportSize.height - 150,
              child: ListView(
                children: <Widget>[
                  ColorPicker(
                    pickerColor: paletteColor.color.toColor(),
                    onColorChanged: setColor,
                    colorPickerWidth: 250.0,
                    pickerAreaHeightPercent: 0.7,
                    enableAlpha: true,
                    displayThumbColor: true,
                    showLabel: true,
                    paletteType: PaletteType.hsl,
                    pickerAreaBorderRadius: const BorderRadius.only(
                      topLeft: const Radius.circular(2.0),
                      topRight: const Radius.circular(2.0),
                    ),
                  ),
                  Row(
                    children: [
                      Txt.subtitle1('Add harmonic generator:'),
                      Txt.subtitle1(' '),
                      PopupMenuButton<String>(
                        initialValue: paletteColor.harmony,
                        child: Txt.subtitle1(harmonyNameById(paletteColor.harmony)),
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
                  ),
                  paletteColor.harmony == null ? null : Wrap(
                    children: [
                      ...paletteColor.transformedColors.map((t) => Icon(
                        LineAwesomeIcons.square_full,
                        color: t.toColor()
                      ))
                    ],
                  )
                ]
              )
            )
          );
        }
  );
}
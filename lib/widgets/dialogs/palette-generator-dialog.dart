import 'package:flutter/material.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/klr.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/services/app-state-service.dart';
import 'package:klr/services/color-name-service.dart';

import 'package:klr/services/palette-generator-service.dart';
import 'package:klr/views/views.dart';
import 'package:klr/widgets/color-generator-config.dart';

import 'package:klr/models/hsluv/hsluv-color.dart';

void showGeneratorDialog(BuildContext context)
  => showDialog(
    context: context,
    builder: (context) => buildGeneratorDialog(context)
  );

Widget buildGeneratorDialog(BuildContext context) {
  final appService = AppStateService.getInstance();
  final nameService = ColorNameService.getInstance();
  final genService = PaletteGeneratorService.getInstance().init();
  
  final viewportSize = MediaQuery.of(context).size;
  final dialogWidth = viewportSize.width - viewportSize.width / 3.5;
  final dialogHeight = viewportSize.height - viewportSize.height / 2.5;

  ColorGenerator chosenColor;

  return KlrStatefulBuilder(
    builder: (context, klr, setState) {
      final t = KlrConfig.t(context);

      final contentWidth = dialogWidth;
      final contentHeight = dialogHeight;

      final colorBoxWidth = contentWidth / 4;

      final colorBox = (
        HSLuvColor col, {
          void Function() onTap,
          IconData icon,
          String label,
          String subtitle,
          bool small = false,
        }) {
          final color = col.toColor();
          final invColor = col.invertLightness()
            .withSaturation(0)
            .toColor();

          return Container(
            alignment: Alignment.center,
            width: colorBoxWidth,
            height: small ? klr.size(5) : klr.size(10),
            decoration: BoxDecoration(
              color: color,
              border: small 
                ? klr.border.only(top: 1, color: invColor)
                : klr.border.only(bottom: 1, color: invColor)
            ),
            child: ListTile(
              tileColor: color,
              onTap: onTap,
              leading: onTap == null ? null 
                : Icon(icon ?? Icons.edit, color: invColor),
              title: Text(
                label ?? col.toHex(),
                style: klr.textTheme.bodyText1.copyWith(
                  color: invColor,
                  fontWeight: small ? FontWeight.normal : FontWeight.bold
                )
              ),
              subtitle: subtitle == null 
                ? null : Text(
                  subtitle,
                  style: klr.textTheme.bodyText2.copyWith(
                    color: invColor,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic
                  )
                ),
            ));
        };

      final colorCard = (ColorGenerator gen) {
        return Container(
          width: colorBoxWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              colorBox(
                gen.color,
                onTap: () => setState(() => chosenColor = gen),
                label: gen.color.toHex()
              ),
              ...gen.colors
                .map(
                    (c) => colorBox(c, small: true)
                ).toList()
            ],            
          ),
        );
      };

      final createPalette = (List<ColorGenerator> colors) async {
        final List<PaletteColor> paletteColors = [];

        for (final gen in colors) {
          final List<HSLuvColor> chunk = [gen.color, ...gen.colors];
          for (final col in chunk) {
            final palCol = await PaletteColor.scaffoldAndSave(
              fromColor: col,
              name: nameService.guessName(col.toColor())
            );
            paletteColors.add(palCol);
          }
        }
        final palette = await Palette.scaffoldAndSave(
          name: "Generated palette",
          colors: paletteColors
        );
        await appService.setCurrentPalette(palette);
        Navigator.pop(context);
        Navigator.pushNamed(context, PalettePage.routeName);
      };


      return StreamBuilder<List<ColorGenerator>>(
        stream: genService.colorStream,
        initialData: genService.snapshot,

        builder: (context, snapshot) {
          final colors = snapshot.data;
          final configWidth = chosenColor == null 
            ? 0
            : contentWidth - colorBoxWidth;
          final configHeight = contentHeight;

          return AlertDialog(
            backgroundColor: klr.theme.dialogBackground,

            actions: [
              FbfBtn.action(
                'Save',
                onPressed: () => createPalette(colors)
              ),
              FbfBtn.choice(
                t.btn_close, 
                onPressed: () => Navigator.pop(context)
              )
            ],

            title: Text('Generate palette'),

            content: Container(
              width: dialogWidth,
              height: dialogHeight,
              child: Row(
                children: [
                  AnimatedContainer(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(shape: BoxShape.rectangle),
                    duration: const Duration(milliseconds: 300),
                    alignment: Alignment.topLeft,
                    width: contentWidth - configWidth,
                    height: contentHeight,

                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      itemExtent: colorBoxWidth,
                      children: <Widget>[
                        ...(chosenColor == null 
                          ? colors.map((c) => colorCard(c)).toList()
                          : [ colorCard(chosenColor) ]
                        ),
                        colorBox(
                          HSLuvColor.fromColor(klr.theme.dialogBackground),
                          label: 'Add color',
                          icon: Icons.add,
                          onTap: () => genService.addColor()
                        )
                      ],
                    )
                  ),

                  AnimatedContainer(
                    alignment: Alignment.topLeft,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: klr.theme.dialogBackground,
                      border: klr.border.only(
                        left: 1.0, 
                        color: chosenColor == null
                          ? klr.theme.dialogBackground
                          : klr.theme.foreground
                      )
                    ),
                    duration: const Duration(milliseconds: 300),
                    width: configWidth,
                    height: configHeight,
                    child: chosenColor == null 
                      ? Container()
                      : Container(
                          child: ColorGeneratorConfig(
                            color: chosenColor,
                            width: configWidth,
                            height: configHeight,
                            onChanged: (c) => genService.updateColor(c),
                            onClose: () => setState(() => chosenColor = null),
                          ),
                        )
                  ),
                ],
              ),
            ),
          );
        }
      );
    }
  );
}



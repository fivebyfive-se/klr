import 'package:flutter/material.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/klr.dart';

import 'package:klr/services/palette-generator-service.dart';
import 'package:klr/widgets/color-generator-config.dart';

import 'package:klr/widgets/hsluv/hsluv-color.dart';

void showGeneratorDialog(BuildContext context)
  => showDialog(
    context: context,
    builder: (context) => buildGeneratorDialog(context)
  );

Widget buildGeneratorDialog(BuildContext context) {
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
                : Icon(Icons.edit, color: invColor),
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
                onPressed: () => Navigator.pop(context)
              ),
              FbfBtn.choice(
                t.btn_close, 
                onPressed: () => Navigator.pop(context)
              )
            ],

            title: Row(
              children: [
                Expanded(child: Text('Generate palette')),
                Expanded(
                  child: TextButton(
                    child: Text(
                      "New color",
                      style: klr.textTheme.subtitle1.copyWith(
                        color: klr.theme.primaryAccent
                      )
                    ),
                    onPressed: () => genService.addColor(),
                  )
                )
              ],
            ),

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
                        right: 1.0, 
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



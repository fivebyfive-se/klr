import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import 'package:fbf/fbf.dart';
import 'package:fbf/hsluv.dart';

import 'package:klr/klr.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/models/generator.dart';

import 'package:klr/services/color-name-service.dart';

import 'package:klr/widgets/color-generator-config.dart';

void showGeneratorDialog(BuildContext context)
  => showDialog(
    context: context,
    builder: (context) => buildGeneratorDialog(context)
  );

Widget buildGeneratorDialog(BuildContext context) {
  final nameService = ColorNameService.getInstance();
  
  final viewportSize = MediaQuery.of(context).size;
  final dialogWidth = viewportSize.width / 1.5;
  final dialogHeight = viewportSize.height / 2;

  final List<int> activeColor = [];
  final List<ColorGenerator> colors = [];
  final rng = Random();

  final randColor = () => HSLuvColor.fromAHSL(
    100.0, 
    rng.nextValue(0, 360),
    rng.nextValue(40, 60),
    rng.nextValue(30, 60)
  );

  final addGenerator = () {
    final rc = randColor();
    final gc = rc.deltaHue(180).deltaLightness(40).deltaSaturation(40);
    colors.add(
      ColorGenerator.curveTo(rc, gc, CurveType.cubic, CurveDir.easeInOut, 5)
    );
  };
  final removeGenerator = (int i) {
    colors.removeAt(i);
  };


  addGenerator();

  return KlrStatefulBuilder(
    builder: (context, klr, setState) {
      final t = KlrConfig.t(context);

      final contentWidth = dialogWidth;
      final contentHeight = dialogHeight;

      final toggleActive = (int idx)
        => setState(() {
          if (activeColor.contains(idx)) {
            activeColor.remove(idx);
          } else {
            activeColor.add(idx);
          }
        });
      final isActive = (int idx) => activeColor.contains(idx);
      final createPalette = () async {
        final List<PaletteColor> paletteColors = [];
        final String date = DateTime.now().toIso8601String();

        for (var gen in colors) {
          for (var col in gen.toColors().toList()) {
            paletteColors.add(
              await PaletteColor.scaffoldAndSave(
                fromColor: col,
                name: nameService.guessName(col.toColor()) 
              )
            );
          }
        }
        await Palette.scaffoldAndSave(
          name: "${t.generator_paletteName} ($date)",
          colors: paletteColors
        );
        Navigator.pop(context);
      };

      return StatefulBuilder(
        builder: (context, setState) {
          final configHeight = contentHeight - 64.0;

          return AlertDialog(
            backgroundColor: klr.theme.dialogBackground,

            actions: [
              FbfBtn.action(
                t.btn_save,
                onPressed: () => createPalette()
              ),
              FbfBtn.choice(
                t.btn_close, 
                onPressed: () => Navigator.pop(context)
              )
            ],

            title: Text(t.generator_title),

            content: Container(
              width: dialogWidth,
              height: dialogHeight,
              child: CustomScrollView(
                slivers: [
                  SliverStickyHeader(
                    header: Container(
                      height: 64,
                      width: dialogWidth,
                      color: klr.theme.appBarBackground,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 6, 
                            child: Center(child: Text(t.generator_generator))
                          ),
                          Expanded(
                            flex: 6,
                            child: Center(child: Text(t.generator_colors))
                          )
                        ],
                      ),
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          ...colors.mapIndex<ColorGenerator,Widget>((gen, i) => Container(
                            height: dialogHeight,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 6,
                                  child:  
                                    isActive(i) 
                                      ? Column(
                                        children: <Widget>[
                                          ColorGeneratorConfig(
                                            colorGenerator: gen,
                                            height: dialogHeight - 64.0,
                                            width: dialogWidth,
                                            onChanged: (v) {
                                              setState(() {
                                                colors[i] = v;
                                              });
                                            },
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () => toggleActive(i),
                                            icon: Icon(Icons.close),
                                            label: Text(t.btn_close)
                                          )
                                        ],
                                      )
                                      : Column(
                                          children: <Widget>[
                                            ElevatedButton.icon(
                                              onPressed: () => toggleActive(i),
                                              icon: Icon(Icons.edit),
                                              label: Text(t.generator_generator),
                                            )
                                          ]
                                      )
                                ),
                                Expanded(
                                  flex: 6,
                                  child: GridView.count(
                                    crossAxisCount: 3,
                                    children: [
                                      ...gen.toColors().map((c) => Container(
                                        color: c.toColor(),
                                        alignment: Alignment.center,
                                        child: Text(
                                          c.toColor().toHex(),
                                          style: klr.textTheme.bodyText2
                                            .withColor(c.invertLightnessGreyscale().toColor())
                                        ),
                                      )).toList()
                                    ],
                                  )
                                )
                              ]
                            ),
                          )
                          ).toList()
                        ]
                      ),
                    ),
                  )
                ],
              )
            )
          );
        }
      );
    }
  );
}



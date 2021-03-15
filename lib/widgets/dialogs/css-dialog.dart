import 'package:flutter/material.dart';

import 'package:flutter_highlight/flutter_highlight.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/app/klr.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/models/hsluv.dart';

void showCssDialog(BuildContext context, Palette palette)
  => showDialog(
    context: context, 
    builder: (context) => buildCssDialog(context, palette)
  );

List<String> paletteToCss(Palette palette, {bool useCssVars = false, bool useHex = true}) {
    final output = <String>[];
    final c = (HSLuvColor c) => c.toHSLColor().toCss(hex: useHex);
    final line = (List<String> parts) => parts.join('');

    final buildCss = (name, color) =>
      (useCssVars) 
        ? ["--$name: " + c(color) + ";"]
        : [".$name {", "    color: " + c(color) + ";", "}"]; 

    for (var c in palette.colors) {
      final cssName = "color-" + c.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
      output.addAll(buildCss(cssName, c.color));
      int n = 0;
      for (var s in [...c.shades, ...c.transformedColors]) {
        n++;
        output.addAll(buildCss("$cssName-$n", s));
      }
    }
    return (useCssVars) 
      ? ["::root{", ...output, "}"]
      : output;
  }

Widget buildCssDialog(BuildContext context, Palette palette) {
  final viewportSize = MediaQuery.of(context).size;
  var useCssVars = false;
  var useHex = true;

  return KlrStatefulBuilder(
    builder: (context, klr, setState) {
      return AlertDialog(
        backgroundColor: klr.theme.dialogBackground,
        actions: [
          FbfBtn.choice("Close", onPressed: () => Navigator.pop(context))
        ],
        title: Row(
          children: [
            Expanded(flex: 1,
              child: CheckboxListTile(
                value: useCssVars,
                onChanged: (v) => setState(() => useCssVars = v),
                title: Text('Use CSS variables'),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: klr.theme.secondary,
              )
            ),
            Expanded(flex: 1,
              child: CheckboxListTile(
                value: useHex,
                onChanged: (v) => setState(() => useHex = v),
                title: Text('Use hexadecimal colors'),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: klr.theme.secondary,
              )
            ),
          ]
        ),
        content: Container(
            width: viewportSize.width - viewportSize.width / 3,
            height: viewportSize.height - viewportSize.height / 2.5,
            color: klr.theme.background,
            padding: klr.edge.all(),
            child: SingleChildScrollView(
              child: HighlightView(
                paletteToCss(palette, useCssVars: useCssVars, useHex: useHex)
                  .join("\n"),
                language: "css",
                theme: klr.theme.codeHighlightTheme,
                textStyle: klr.codeTheme.bodyText1,
              )
            )
          )
        
    );
  }
);
  
}
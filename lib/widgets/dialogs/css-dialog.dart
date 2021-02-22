import 'package:flutter/material.dart';
import 'package:klr/app/klr.dart';
import 'package:klr/helpers/color.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/widgets/txt.dart';

void showCssDialog(BuildContext context, Palette palette)
  => showDialog(
    context: context, 
    builder: (context) => buildCssDialog(context, palette)
  );

List<TextSpan> paletteToCss(Palette palette, {bool useCssVars = false, bool useHex = true}) {
    final output = <TextSpan>[];
    final ts = ({String text, TextStyle style}) => TextSpan(text: text, style: style);
    final t = (String text) => ts(
      text: text,
      style: Txt.typeStyle(TxtType.code).copyWith(color: Klr.theme.foreground)
    );
    final c = (HSLColor c) => ts(
      text: c.toCss(hex: useHex),
      style: Txt.typeStyle(TxtType.code).copyWith(color: c.toColor())
    );
    final line = (List<TextSpan> s) => TextSpan(children: s);

    final buildCss = (name, color) =>
      (useCssVars) 
        ? line([t("--$name: "), c(color), t(";")])
        : line([t(".$name {\n"), t("    color: "), c(color), t(";\n}")]); 

    for (var c in palette.colors) {
      final cssName = "color-" + c.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
      output.add(buildCss(cssName, c.color));
      int n = 0;
      for (var s in [...c.shades, ...c.transformedColors]) {
        n++;
        output.add(buildCss("$cssName-$n", s));
      }
    }
    return (useCssVars) 
      ? [t("::root{"), ...output, t("}")]
      : output;
  }

StatefulBuilder buildCssDialog(BuildContext context, Palette palette) {
  final viewportSize = MediaQuery.of(context).size;
  var useCssVars = false;
  var useHex = true;

  return StatefulBuilder(
    builder: (context, setState) {
      return AlertDialog(
        backgroundColor: Klr.theme.dialogBackground,
        actions: [
          TextButton(
            child: Txt.subtitle3("Close"),
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                EdgeInsets.all(10.0)
              ),
              minimumSize: MaterialStateProperty.all(
                Size(50,30)
              ),
              backgroundColor: MaterialStateProperty.all(
                Klr.theme.primaryAccent
              )
            ),
          )
        ],
        title: Row(
          children: [
            Expanded(flex: 1,
              child: CheckboxListTile(
                value: useCssVars,
                onChanged: (v) {
                  useCssVars = v;
                  setState(() {});
                },
                title: Text('Use CSS variables'),
                controlAffinity: ListTileControlAffinity.leading,
              )
            ),
            Expanded(flex: 1,
              child: CheckboxListTile(
                value: useHex,
                onChanged: (v) {
                  useHex = v;
                  setState(() {});
                },
                title: Text('Use hexadecimal colors'),
                controlAffinity: ListTileControlAffinity.leading,
              )
            ),
          ]
        ),
        content: Container(
            width: viewportSize.width - viewportSize.width / 3,
            height: viewportSize.height - viewportSize.height / 3,
          child: ListView(
            children: [
              ...paletteToCss(palette, useCssVars: useCssVars, useHex: useHex)
                .map((l) => RichText(
                  text: l
                )).toList(),
            
          ]
        )
      )
    );
  }
);
  
}
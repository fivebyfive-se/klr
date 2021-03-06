import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:fbf/fbf.dart';
import 'package:fbf/hsluv.dart';

import 'package:klr/klr.dart';

import 'package:klr/models/app-state.dart';
import 'package:klr/widgets/expanding-table.dart';

class CssTable extends StatefulWidget {
  const CssTable({Key key, this.palette}) : super(key: key);

  final Palette palette;

  @override
  _CssTableState createState() => _CssTableState();
}

class _CssTableState extends State<CssTable> {
  bool _isActive = false;
  bool _useHex = true;
  bool _useCssVars = false;

  List<String> _paletteToCss(Palette palette) {
    final output = <String>[];
    final c = (HSLuvColor c) => c.toHSLColor().toCss(hex: _useHex);

    final buildCss = (name, color) =>
      (_useCssVars) 
        ? ["--$name: " + c(color) + ";"]
        : [".$name {", "    color: " + c(color) + ";", "}"]; 

    for (var c in palette.colors) {
      final cssName = "color-" + c.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
      output.addAll(buildCss(cssName, c.color));
      if (c.harmony != null) {
        int n = 0;
        for (var s in [...c.transformedColors]) {
          n++;
          output.addAll(buildCss("$cssName--${c.harmony}-$n", s));
        }

      }
    }
    return (_useCssVars) 
      ? ["::root{", ...output, "}"]
      : output;
  }


  @override
  Widget build(BuildContext context) {
    final klr = KlrConfig.of(context);
    final t = KlrConfig.t(context);
    final palette = widget.palette;
    final headerStyle = klr.textTheme.subtitle1.withColor(
      klr.theme.tableSubHeaderForegroundColor
    );
    
    return ExpandingTable(
      headerIcon: LineAwesomeIcons.css_3_logo,
      headerLabel: t.css_title,
      headerBuilder: (c, a) => Row(
        children: <Widget>[
          Expanded(
            child: CheckboxListTile(
              value: _useCssVars,
              onChanged: (v) => setState(() => _useCssVars = v),
              title: Text(t.css_useVariables, style: headerStyle),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: klr.theme.onPrimary,
            ),
          ),
          Expanded(
            child: CheckboxListTile(
              value: _useHex,
              onChanged: (v) => setState(() => _useHex = v),
              title: Text(t.css_useHex, style: headerStyle),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: klr.theme.onPrimary,
            ),
          ),
        ]
      ),
      contentBuilder: (c, a) => SingleChildScrollView(
        child: HighlightView(
          _paletteToCss(palette)
            .join("\n"),
          language: "css",
          padding: klr.edge.only(bottom: 4, top: 2, left: 1, right: 2),
          theme: klr.theme.codeHighlightTheme,
          textStyle: klr.codeTheme.bodyText1,

        )
      )
    );
  }
}
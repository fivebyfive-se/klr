import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/klr.dart';

import 'package:klr/models/app-state.dart';
import 'package:klr/models/hsluv.dart';
import 'package:klr/widgets/expanding-table.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

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
      int n = 0;
      for (var s in [...c.shades, ...c.transformedColors]) {
        n++;
        output.addAll(buildCss("$cssName-$n", s));
      }
    }
    return (_useCssVars) 
      ? ["::root{", ...output, "}"]
      : output;
  }


  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.of(context).size;
    final klr = KlrConfig.of(context);
    final duration = const Duration(milliseconds: 400);
    final palette = widget.palette;
    
    return ExpandingTable(
      headerIcon: LineAwesomeIcons.css_3_logo,
      headerLabel: 'CSS',
      headerBuilder: (c, a) => Row(
        children: <Widget>[
          Expanded(
            child: CheckboxListTile(
              value: _useCssVars,
              onChanged: (v) => setState(() => _useCssVars = v),
              title: Text('Use CSS variables'),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: klr.theme.secondary,
            ),
          ),
          Expanded(
            child: CheckboxListTile(
              value: _useHex,
              onChanged: (v) => setState(() => _useHex = v),
              title: Text('Use hexadecimal colors'),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: klr.theme.secondary,
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
    // return SliverStickyHeader(
    //   header: Container(
    //     height: 64.0,
    //     width: viewport.width,
    //     decoration: BoxDecoration(
    //       color: klr.theme.cardBackground,
    //       border: klr.border.only(top: 1.0, color: klr.theme.bottomNavBackground)
    //     ),
    //     child: Row(
    //       children: <Widget>[
    //         Expanded(
    //           child: ListTile(
    //             leading: Icon(
    //               LineAwesomeIcons.css_3_logo,
    //               color: _isActive
    //                 ? klr.theme.foreground
    //                 : klr.theme.foregroundDisabled
    //             ),
    //             title: Text('CSS'),
    //             onTap: () => setState(() => _isActive = !_isActive),
    //           )
    //         ),
    //         Expanded(flex: 1,
    //           child: AnimatedOpacity(
    //             duration: duration,
    //             opacity: _isActive ? 1.0 : 0.0,
    //             child: CheckboxListTile(
    //               value: _useCssVars,
    //               onChanged: (v) => setState(() => _useCssVars = v),
    //               title: Text('Use CSS variables'),
    //               controlAffinity: ListTileControlAffinity.leading,
    //               activeColor: klr.theme.secondary,
    //             ),
    //           )
    //         ),
    //         Expanded(flex: 1,
    //           child: AnimatedOpacity(
    //             duration: duration,
    //             opacity: _isActive ? 1.0 : 0.0,
    //             child: CheckboxListTile(
    //               value: _useHex,
    //               onChanged: (v) => setState(() => _useHex = v),
    //               title: Text('Use hexadecimal colors'),
    //               controlAffinity: ListTileControlAffinity.leading,
    //               activeColor: klr.theme.secondary,
    //             ),
    //           )
    //         ),
    //       ]
    //     )
    //   ),
    //   sliver: SliverToBoxAdapter(
    //     child:  AnimatedContainer(
    //       duration: duration,
    //       width: viewport.width,
    //       height: _isActive ? viewport.height / 3 : 0.0,
    //       child: SingleChildScrollView(
    //         child: HighlightView(
    //           _paletteToCss(palette)
    //             .join("\n"),
    //           language: "css",
    //           padding: klr.edge.only(bottom: 4, top: 2, left: 1, right: 2),
    //           theme: klr.theme.codeHighlightTheme,
    //           textStyle: klr.codeTheme.bodyText1,
    //         )
    //       )
    //     )
    //   )
    // );
  }
}
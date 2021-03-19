import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/klr.dart';
import 'package:klr/models/hsluv/contrast.dart';
import 'package:klr/views/palette-page.dart';
import 'package:klr/widgets/richer-text.dart';
import 'package:klr/widgets/text-with-icon.dart';

import 'editor-tile/list-selector-tile.dart';

class ContrastTable extends StatefulWidget {
  const ContrastTable({
    Key key,
    this.colors,
  }) : super(key: key);

  final List<ColorItem> colors;
  @override
  _ContrastTableState createState() => _ContrastTableState();
}

class _ContrastTableState extends State<ContrastTable> {
  bool _contrastActive = false;
  ColorItem  _contrastBackground;
  List<ColorItem> get _colors => widget.colors
    .where((c) => c.label != _contrastBackground.label)
    .toList();

  @override
  void initState() {
    super.initState();
    _contrastBackground = widget.colors.first;
  }

  @override
  Widget build(BuildContext context) {    
    final viewport = MediaQuery.of(context).size;
    final klr = KlrConfig.of(context);

    final contrastDuration = const Duration(milliseconds: 400);
    final tsLarge = klr.textTheme.subtitle1.copyWith(fontSize: 24);
    final tsNormal = klr.textTheme.bodyText2;

    return SliverStickyHeader(
      header: Container(
        height: 64,
        width: viewport.width,
        decoration: BoxDecoration(
          color: klr.theme.cardBackground,
          border: klr.border.only(top: 1.0, color: klr.theme.bottomNavBackground)
        ),
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                leading: Icon(
                  Icons.brightness_6,
                  color: _contrastActive
                    ? klr.theme.foreground
                    : klr.theme.foregroundDisabled
                ),
                title: Text('Contrast', style: klr.textTheme.subtitle1),
                onTap: () => setState(() => _contrastActive = !_contrastActive),
              ),
            ),
            Expanded(
              child: AnimatedOpacity(
                duration: contrastDuration,
                opacity: _contrastActive ? 1.0 : 0.0,
                child: ListSelectorTile<ColorItem>(
                  itemWidgetBuilder: (ci) => TextWithIcon(
                    icon: Icon(Icons.circle, color: ci.color.toColor()),
                    text: Text(ci.label, style: klr.textTheme.subtitle1)
                  ),
                  items: _colors,
                  label: 'Background color',
                  onSelected: (v) => setState(() => _contrastBackground = v),
                  value: _contrastBackground,
                ),
              ),
            )
          ],
        )
      ),
      sliver:
        SliverList(
          delegate: SliverChildListDelegate(
            [...(_colors
            .where((c) => c.color != _contrastBackground.color)
            .map((c) {
              final contrast = _contrastBackground.color
                .contrastWith(c.color);
              final isGood = contrast >= Contrast.W3C_CONTRAST_TEXT;
              final isOK = contrast >= Contrast.W3C_CONTRAST_LARGE_TEXT;

              return AnimatedContainer(
                height: _contrastActive ? 100.0 : 0,
                duration: contrastDuration,
                width: viewport.width,
                decoration: _contrastActive 
                  ? BoxDecoration(
                    border: klr.border.only(
                      bottom: 1.0,
                      color: klr.theme.cardBackground
                    )
                  )
                  : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Expanded(
                    child: Container(
                      padding: klr.edge.all(2),
                      color: klr.theme.dialogBackground,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              c.label,
                              style: tsLarge
                            )
                          ),
                          Expanded(
                            child: Text(
                              contrast.toStringAsFixed(1),
                              style: tsLarge.withColor(
                              isGood ? klr.theme.foreground
                                : isOK ? klr.theme.warning
                                  : klr.theme.error
                              )
                            ),
                          )
                        ]
                      ),
                    )
                  ),
                  Expanded(
                    child: Container(
                      color: _contrastBackground.color.toColor(),
                      padding: klr.edge.all(2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "Large text\n", 
                              style: tsLarge.withColor(c.color.toColor())
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Smaller text", 
                              style: tsNormal.withColor(c.color.toColor())
                            ),
                          ),
                        ]
                      ),
                    ),
                  )
                ]),
              );
            }).toList()),
            AnimatedContainer(
              duration: contrastDuration,
              height: _contrastActive ? 100 : 0,
              color: klr.theme.cardBackground,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.info_outline),
                  ),
                  Expanded(
                    flex: 11,
                    child: Container(
                      padding: klr.edge.xy(2, 1),
                      child: RicherText.from([
                          "WCAG requires a contrast of at least 4.5 "
                          "between text and background.\n",
                        ], 
                        baseStyle: tsNormal
                          .withColor(klr.theme.cardForeground)
                      ),
                    )
                  )
                ]
              )
            )
          ])
      )
    );
  }
}
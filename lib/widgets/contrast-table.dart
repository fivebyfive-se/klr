import 'package:flutter/material.dart';

import 'package:fbf/fbf.dart';
import 'package:fbf/hsluv.dart';

import 'package:klr/klr.dart';

import 'package:klr/views/palette-page.dart';
import 'package:klr/widgets/expanding-table.dart';
import 'package:klr/widgets/text-with-icon.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'editor-tile/list-selector-tile.dart';

class ContrastTable extends StatefulWidget {
  const ContrastTable({
    Key key,
    this.colors,
    this.onChanged,
  }) : super(key: key);

  final List<ColorItem> colors;
  final void Function(ColorItem) onChanged;

  @override
  _ContrastTableState createState() => _ContrastTableState();
}

class _ContrastTableState extends State<ContrastTable> {
  ColorItem  _contrastBackground;
  List<ColorItem> get _colors => widget.colors
    .where((c) => c.label != _contrastBackground.label)
    .toList();
  KlrConfig get klr => KlrConfig.of(context);

  void _applyColor(ColorItem color, HSLuvColor newColor)
    => widget.onChanged?.call(ColorItem(
      color: newColor,
      id: color.id
    ));

  Widget _colorLabel(ColorItem ci) 
    => TextWithIcon(
          icon: Icon(Icons.circle, color: ci.color.toColor()),
          text: Text(ci.label, style: klr.textTheme.bodyText2)
        );

  @override
  void initState() {
    super.initState();
    _contrastBackground = widget.colors.first;
  }

  @override
  Widget build(BuildContext context) {    
    final t = KlrConfig.t(context);
    final tsLarge = klr.textTheme.bodyText2.copyWith(fontSize: 24);
    final tsNormal = klr.textTheme.bodyText2;
    final bgColor = _contrastBackground.color;
    
    final row = (List<Widget> children) 
      => Expanded(
          child: Row(
            mainAxisAlignment:  MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: 
              children.mapIndex<Widget,Widget>(
                (item, idx) => Expanded(
                  child: item,
                  flex: children.length - (idx == 0 ? 0 : 1)
                )
              ).toList()
          ),
        );

    final contrastResult = (ColorItem ci, [HSLuvColor suggest]) {
      final contrast = ci.color.contrastWith(bgColor);
      final textLabel = _colorLabel(ci);
      final ratioLabel = (double r) => Text(
        r.toStringAsFixed(1),
        style: tsLarge.withColor(
        r >= Contrast.W3C_CONTRAST_TEXT ? klr.theme.foreground
          : r >= Contrast.W3C_CONTRAST_LARGE_TEXT ? klr.theme.warning
            : klr.theme.error
        )
      );
      final suggestContrast = suggest == null ? 0.0
        : suggest.contrastWith(bgColor);

      return Container(
        padding: klr.edge.all(1),
        color: klr.theme.dialogBackground,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            row([
              textLabel,
              ratioLabel(contrast)
            ]),
            ...(suggest == null ? [] : [
              row([
                _colorLabel(
                  ColorItem(
                    color: suggest, 
                    name: "Suggestion:\n" + suggest.toHex()
                  )
                ),
                ratioLabel(suggestContrast),
              ]),
            ])
          ]
        ),
      );
    };

    final contrastExample = (ColorItem ci, [HSLuvColor suggest]) {
      final ex = (HSLuvColor c) => RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: t.contrast_largeText + "\n", 
              style: tsLarge.withColor(c.toColor())
            ),
            TextSpan(
              text: t.contrast_smallText, 
              style: tsNormal.withColor(c.toColor())
            )
          ]
        )
      );
      return Container(
        color: bgColor.toColor(),
        padding: klr.edge.all(1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ex(ci.color)
            ),
            ...(suggest == null ? [] : [
              row([
                ex(suggest),
                ElevatedButton(
                  onPressed: () => _applyColor(ci, suggest),
                  child: Text('Apply')
                )
              ])
            ])
          ]
        ),
      );
    };

    return ExpandingTable(
      headerIcon: Icons.brightness_6,
      headerLabel: t.contrast_title,
      headerBuilder: (c, a) => ListSelectorTile<ColorItem>(
        itemWidgetBuilder: (ci) => TextWithIcon(
          icon: Icon(Icons.circle, color: ci.color.toColor()),
          text: Text(ci.label, style: klr.textTheme.subtitle1)
        ),
        items: _colors,
        label: t.contrast_background,
        onSelected: (v) => setState(() => _contrastBackground = v),
        value: _contrastBackground,
      ),
      contentBuilder: (c, a) => ListView(
        children: [
          ..._colors
            .where((c) => c.color != bgColor)
            .map((c) {
              final contrast = bgColor.contrastWith(c.color);
              final isGood = contrast >= Contrast.W3C_CONTRAST_TEXT;
              final suggest = isGood ? null : c.color.ensureContrast(bgColor);

              return Container(
                height: klr.tileHeightx2 + klr.tileHeight,
                decoration: BoxDecoration(
                  border: klr.border.only(bottom: 2, color: klr.theme.foreground)
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Expanded(
                      child: contrastResult(c, suggest)
                    ),
                    Expanded(
                      child: contrastExample(c, suggest)
                    ),
                  ]
                ),
              );
            }
          ).toList(),
          Container(
            padding: klr.edge.xy(2, 1),
            child: Text(
              t.contrast_helpText,
              style: tsNormal.withColor(klr.theme.cardForeground)
            ),
          )
        ],
      ),
    );
  }
}
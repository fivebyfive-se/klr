import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/klr.dart';

import 'editor-tile.dart';

class NumberPickerTile extends EditorTile {
  const NumberPickerTile({
    Key key,
    @required String label,
    @required this.value,
    @required this.onChanged,
    this.min = 0.0,
    this.max = 100.0,
    this.step = 5.0
  }) : 
    assert(value != null),
    assert(onChanged != null),
    assert(label != null),
    super(key: key, label: label);

  final double value;
  final double min;
  final double max;
  final double step;
  final void Function(double) onChanged;

  @override
  Widget buildField(BuildContext context, KlrConfig klr) {
    final itemStyle = klr.textTheme.bodyText1
      .copyWith(color: klr.theme.foreground, fontWeight: FontWeight.bold);
    final secondaryStyle = klr.textTheme.overline
      .copyWith(
        color: klr.theme.foreground.deltaLightness(-10),
        fontWeight: FontWeight.normal
      );

    final icon = (IconData id, bool enabled) => Icon(
      id, color: enabled 
        ? klr.theme.secondaryAccent 
        : klr.theme.foregroundDisabled
    );
    final minusEnabled = value >= (step + min);
    final valueString = value.toStringAsFixed(0);
    final wrappedValueString = value.wrap(max, min: min).toStringAsFixed(0);
    final valueOverflows = value > max;
    bool wrapDisplayedValue = false; 

    return StatefulBuilder(
      builder: (c, setState) =>  SizedBox(
        width: fieldWidth,
        height: fieldHeight,
        child: Row(
          children: [
            IconButton(
              icon: icon(Icons.remove_circle_outline, minusEnabled),
              onPressed: minusEnabled
                ? () => onChanged(value - step)
                : null,
            ),
            TextButton(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: wrapDisplayedValue && valueOverflows 
                        ? wrappedValueString
                        : valueString,
                      style: itemStyle
                    ),
                    ...(valueOverflows 
                      ? [
                      TextSpan(
                        text: "\n(" + (
                          wrapDisplayedValue ? valueString : wrappedValueString
                        ) + ")",
                        style: secondaryStyle
                      )]: [])
                  ],
                )
              ),
              onPressed: () => setState(() => wrapDisplayedValue = !wrapDisplayedValue),
            ),
            IconButton(
              icon: icon(Icons.add_circle_outline, true),
              onPressed: () => onChanged(value + step),
            ),
          ],
        )
      )
    );
  }
}
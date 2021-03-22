import 'package:flutter/material.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/klr.dart';

abstract class EditorTile extends StatelessWidget {
  const EditorTile({
    Key key,
    this.label,
    this.labelStyle,
    this.fieldStyle,
  }) : super(key: key);

  final String label;
  final TextStyle labelStyle;
  final TextStyle fieldStyle;

  double get fieldHeight => 40.0;
  double get fieldWidth  => 108.0;
  
  Widget buildField(
    BuildContext context,
    KlrConfig klr
  );

  @override
  Widget build(BuildContext context) {
    final klr = KlrConfig.of(context);
    
    final tsLabel = klr.textTheme.subtitle1
      .withFontWeight(FontWeight.normal)
      .merge(labelStyle);
    final tsField = klr.textTheme.subtitle1
      .withFontWeight(FontWeight.bold)
      .merge(fieldStyle);

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 48.0,
        maxHeight: 48.0
      ),
      child: ListTile(
        leading: Text(
          label,
          style: tsLabel
        ),
        minLeadingWidth: fieldWidth,
        title: DefaultTextStyle(
          style: tsField,
          child: buildField(context, klr)
        )
      )
    );
  }
}
import 'package:flutter/material.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/klr.dart';

abstract class EditorTile extends StatelessWidget {
  const EditorTile({
    Key key,
    this.label,
  }) : super(key: key);

  final String label;

  double get fieldHeight => 40.0;
  double get fieldWidth  => 108.0;
  
  Widget buildField(
    BuildContext context,
    KlrConfig klr
  );

  @override
  Widget build(BuildContext context) {
    final klr = KlrConfig.of(context);
    
    final labelStyle = klr.textTheme.subtitle1
      .withFontWeight(FontWeight.normal);
    final fieldStyle = klr.textTheme.subtitle1
      .withFontWeight(FontWeight.bold);

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 48.0,
        maxHeight: 48.0
      ),
      child: ListTile(
        leading: Text(
          label,
          style: labelStyle
        ),
        minLeadingWidth: fieldWidth,
        title: DefaultTextStyle(
          style: fieldStyle,
          child: buildField(context, klr)
        )
      )
    );
  }
}
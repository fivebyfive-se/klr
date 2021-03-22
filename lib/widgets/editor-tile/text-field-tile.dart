import 'package:fbf/fbf.dart';
import 'package:flutter/material.dart';
import 'package:klr/klr.dart';

import 'editor-tile.dart';

class TextFieldTile extends EditorTile {
  const TextFieldTile({
    Key key,
    String label,
    this.value,
    this.onChanged,
    TextStyle labelStyle,
    TextStyle fieldStyle,
  }) : super(
          key: key,
          label: label,
          labelStyle: labelStyle,
          fieldStyle: fieldStyle,
        );

  final String value;
  final void Function(String) onChanged;

  @override
  Widget buildField(BuildContext context, KlrConfig klr) {
    final _ctrl = textEditCtrlFromValue(value);
    return TextField(
      controller: _ctrl,
      onSubmitted: (v) => onChanged?.call(v),
    );
  }
}
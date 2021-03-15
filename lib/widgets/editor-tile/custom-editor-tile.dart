import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:klr/klr.dart';

import 'package:klr/widgets/editor-tile/editor-tile.dart';

class CustomEditorTile extends EditorTile {
  const CustomEditorTile({
    Key key,
    String label,
    @required this.childBuilder
  }) :  assert(childBuilder != null),
        super(key: key, label: label ?? "");  

  final Widget Function(BuildContext context, KlrConfig config) 
    childBuilder;

  @override
  Widget buildField(BuildContext context, KlrConfig klr)
    => childBuilder(context, klr);
}
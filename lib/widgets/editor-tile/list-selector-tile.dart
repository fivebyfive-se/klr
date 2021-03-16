import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:klr/klr.dart';

import 'editor-tile.dart';

typedef ItemToWidget<T> = Widget Function(T item);
typedef ItemChanged<T> = void Function(T); 

class ListSelectorTile<T> extends EditorTile {
  const ListSelectorTile({
    Key key,
    String label,
    @required this.itemWidgetBuilder,
    @required this.items,
    @required this.onSelected,
    this.value,
  }) 
    : super(key: key, label: label);

  /// If supplied, is used to generate the widget for each
  /// item. If not supplied, defaults to using toString
  /// and Text
  final ItemToWidget<T> itemWidgetBuilder;

  /// List of items
  final List<T> items;

  /// Called when an item is selected
  final ItemChanged<T> onSelected;

  /// Current value -- defaults to first item in [items]
  final T value;

  @protected
  Widget _itemToWidget(T item)
    => itemWidgetBuilder(item);


  @override
  Widget buildField(BuildContext context, KlrConfig klr)
    => PopupMenuButton<T>(
        child: _itemToWidget(value ?? items.first),
        initialValue: value,
        itemBuilder: (_) => items.map(
          (e) => PopupMenuItem(
            child: _itemToWidget(e),
            value: e
          )
        ).toList(),
        onSelected: onSelected,
      );
}


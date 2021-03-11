import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:klr/widgets/text-with-icon.dart';

typedef ItemToIcon<T> = IconData Function(T item);
typedef ItemToString<T> = String Function(T item);
typedef OnSelectFunction<T> = void Function(T); 

class PopupMenuTile<E> extends StatelessWidget {
  const PopupMenuTile({
    Key key,
    this.iconDataBuilder,
    this.itemNameBuilder,
    this.items,
    this.label,
    this.onSelected,
    this.value,
  }) 
    : super(key: key);

  /// If supplied, each item in the menu will be prefixed with
  /// an icon as built by this function
  final ItemToIcon<E> iconDataBuilder;

  /// If supplied, is used to generate the name of each
  /// item. If not supplied, defaults to using toString
  /// (and removing any prefixed text ending with ".",
  /// which makes, e.g., enums easier to read).
  final ItemToString<E> itemNameBuilder;

  /// List of items
  final List<E> items;

  /// Label to show before menu button
  final String label;

  /// Called when an item is selected
  final OnSelectFunction<E> onSelected;

  /// Current value -- defaults to first item in [items]
  final E value;

  @protected
  String _enumToString(Object e) {
    final full = e.toString();
    final period = full.indexOf('.');
    return period <= 0 ? full : full.substring(period + 1); 
  } 

  @protected
  String _itemToString(E item)
    => itemNameBuilder == null 
      ? _enumToString(item)
      : itemNameBuilder(item);

  @protected
  Widget _childBuilder(E item)
    => iconDataBuilder == null
      ? Text(_itemToString(item))
      : TextWithIcon(
          icon: iconDataBuilder(item), 
          text: _itemToString(item),
        );

  @override
  Widget build(BuildContext context)
    => ListTile(
      leading: Text(label),
      title: PopupMenuButton<E>(
        child: _childBuilder(value ?? items.first),
        initialValue: value,
        itemBuilder: (_) => items.map(
          (e) => PopupMenuItem(
            child: _childBuilder(e),
            value: e
          )
        ).toList(),
        onSelected: onSelected,
      ) 
    );
}


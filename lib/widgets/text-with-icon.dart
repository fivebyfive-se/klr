import 'package:flutter/material.dart';

class TextWithIcon extends StatelessWidget {
  const TextWithIcon({
    Key key,
    this.icon,
    this.text,
    this.spacing = 10.0,
    this.iconAffinity = IconAffinity.leading
  }) : super(key: key);

  final IconData icon;
  final String   text;
  final double   spacing;
  final IconAffinity iconAffinity;

  List<Widget> get _items
    => <Widget>[Icon(icon), Text(text)];

  List<Widget> get _orderedItems
    => iconAffinity == IconAffinity.leading
        ? _items : _items.reversed; 

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      children: _orderedItems,
    );
  }
}

enum IconAffinity {
  leading,
  trailing
}
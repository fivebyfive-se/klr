import 'package:flutter/material.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/klr.dart';

import 'package:klr/models/hsluv.dart';

class ColorList extends StatefulWidget {
  const ColorList({
    Key key,
    this.showActions = true,
    this.onAdd,
    this.onSelect,
    this.onDelete,
    this.onPromote,
    this.items,
    this.height,
    this.width,
  }) : super(key: key);

  final bool showActions;
  final List<ColorListItem> items;

  final void Function() onAdd;
  final void Function(ColorListItem) onSelect;
  final void Function(List<ColorListItem>) onDelete;
  final void Function(List<ColorListItem>) onPromote;

  final double height;
  final double width;

  @override
  _ColorListState createState() => _ColorListState();
}

class _ColorListState extends State<ColorList> {
  bool _showDetails = false;
  bool _isSelecting = false;

  List<ColorListItem> _selected = [];

  KlrConfig get _klr => KlrConfig.of(context);

  List<ColorListItem> get _derivedSelected
    => _selected.where((i) => i.isDerived).toList();

  bool get _anySelected => _selected.isNotEmpty;
  bool get _anyDerivedSelected => _derivedSelected.isNotEmpty;

  void _toggleSelecting([bool force])
    => setState(() => _isSelecting = force ?? !_isSelecting);

  void _toggleDetails([bool force])
    => setState(() => _showDetails = force ?? !_showDetails);

  void _toggleSelect(ColorListItem item) {
    if (_selected.any((i) => i.id == item.id)) {
      _selected.remove(item);
    } else {
      _selected.add(item);
    }

    _toggleSelecting(true);
  }

  void _deleteSelected() {
    widget.onDelete(_selected);
    _selected.clear();

    _toggleSelecting(false);
  }

  void _promoteSelected() {
    widget.onPromote(_derivedSelected);
    _selected.clear();

    _toggleSelecting(false);
  }

  Widget _iconButton(IconData iconData, void Function() onPressed)
    => IconButton(icon: Icon(iconData), onPressed: onPressed);

  List<Widget> _leftActions() => <Widget>[
    (_isSelecting
      ? _iconButton(Icons.close, () => _toggleSelecting(false))
      : _iconButton(Icons.check, () => _toggleSelecting(true))
    )
  ];

  List<Widget> _rightActions() => _isSelecting
    ? <Widget>[
      _iconButton(
        Icons.delete_outline,
        _anySelected ? () => _deleteSelected() : null
      ),
      _iconButton(
        Icons.upgrade_outlined,
        _anyDerivedSelected ? () => _promoteSelected() : null
      )
  ] : <Widget>[
    _iconButton(
      Icons.add,
      () => widget.onAdd?.call()
    ),
    _iconButton(
      _showDetails ? Icons.list : Icons.grid_view,
      () => _toggleDetails()
    )
  ];

  Widget _colorTile(ColorListItem item) {
    final bool selected = _selected.any((i) => i.id == item.id);
    final titleStyle = _klr.textTheme.subtitle1.withColor(
      selected ? _klr.theme.onPrimary : item.color.invertLightness().toColor()
    );
    return ListTile(
      tileColor: item.color.toColor(),
      selected: selected,
      selectedTileColor: _klr.theme.primaryBackground,
      title: Text(item.label, style: titleStyle)
    );
  }

  @override
  Widget build(BuildContext context) {
    final klr = KlrConfig.of(context);
    final viewSize = MediaQuery.of(context).size;
    final actionsSize = 40.0;
    final width = widget.width ?? viewSize.width;
    final height = widget.height ?? viewSize.height / 2;

    return Container(
      width: width,
      height: height,
      child: Column(
        children: <Widget>[
          widget.showActions ? Container(
            height: actionsSize,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonBar(
                  children: _leftActions(),
                ),
                ButtonBar(
                  children: _rightActions(),
                )
              ],
            )
          ) : Container(),
          Expanded(
            child: GridView.count(
              crossAxisCount: _showDetails ? 1 : 5,
              crossAxisSpacing: klr.size(),
              mainAxisSpacing: klr.size(),
              primary: false,
              children: <Widget>[
                ...widget.items.map(
                  (i) => _colorTile(i)
                ).toList()
              ],
            )
          ),
        ]
      ),
    );
  }
}

class ColorListItem {
  final String id;
  final String parentId;
  final String name;
  final HSLuvColor color;

  ColorListItem({
    this.id,
    this.parentId,
    this.color,
    this.name
  });

  String get label => name ?? color.toHex();

  bool get isDerived => parentId != null;
}

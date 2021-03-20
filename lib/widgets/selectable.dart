import 'package:flutter/material.dart';

import 'package:fbf/fbf.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import 'package:klr/klr.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class SelectableList<T> extends StatefulWidget {
  const SelectableList({
    Key key, 
    this.crossAxisCount = 5, 
    this.items, 
    this.widgetBuilder,
    this.noItems,
    this.actions,
    this.selectedActions,
    this.onPressed,
    this.width,
    this.height,
    this.compact,
  }) : super(key: key);

  final int crossAxisCount;
  final List<T> items;
  final void Function(T item) onPressed;
  final Widget noItems;
  final Widget Function(T item, bool selected, bool showDetails) widgetBuilder;

  final List<ListItemAction<T>> actions;
  final List<ListItemAction<T>> selectedActions;

  final double width;
  final double height;

  final bool compact;

  @override
  _SelectableListState<T> createState() => _SelectableListState<T>();
}

class _SelectableListState<T> extends State<SelectableList<T>> {
  List<int> _selected = <int>[];
  bool _selectionActive = false;
  bool _viewCompact;

  List<T> get _items => widget.items;
  List<T> get _selectedItems => _selected.map((i) => _items[i]).toList();

  void _toggleViewCompact([bool force])
    => setState(() => _viewCompact = force ?? !_viewCompact);

  void _toggleSelectionActive([bool force]) {
    _selectionActive = force ?? !_selectionActive;
    if (!_selectionActive) {
      _selected.clear();
    }
    setState(() {});
  }

  bool _isSelected(int index) => _selected.contains(index);

  void _toggleSelected(int index) {
    if (_isSelected(index)) {
      _selected.remove(index);
    } else {
      _selected.add(index);
    }
    _toggleSelectionActive(true);
  }

  Widget _iconButton({
    Widget icon,
    Widget label,
    void Function() onPressed
  })
    => label == null
      ? IconButton(icon: icon, onPressed: onPressed)
      : TextButton.icon(onPressed: onPressed, icon: icon, label: label);

  List<Widget> _selectedActions()
    => widget.selectedActions == null ? []
      : widget.selectedActions.map(
        (i) => _iconButton(
          icon: i.icon,
          onPressed: () {
            i.onPressed.call(_selectedItems);
            _toggleSelectionActive(false);
          },
          label: i.label
        )
      ).toList();
  
  List<Widget> _actions()
    => widget.actions == null ? []
      : widget.actions.map(
          (i) => _iconButton(
            icon: i.icon,
            label: i.label,
            onPressed: () => i.onPressed.call(_items),
          )
        ).toList();

  List<Widget> _leftActions()
    => <Widget>[
      _iconButton(
        icon: Icon(_selectionActive 
          ? LineAwesomeIcons.times 
          : LineAwesomeIcons.check
        ),
        onPressed: () => _toggleSelectionActive()
      )
    ];

  List<Widget> _rightActions()
    => _selectionActive ? <Widget>[
      ..._selectedActions(),
    ] : <Widget>[
      ..._actions(),
      _iconButton(
        icon: Icon(_viewCompact 
          ? Icons.apps 
          : Icons.view_stream_outlined),
        onPressed: () => _toggleViewCompact()
      ),
    ];

  @override void initState(){
    super.initState();

    _viewCompact = widget.compact ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final klr = KlrConfig.of(context);
    final viewport = MediaQuery.of(context).size;
    final width = widget.width ?? viewport.width;
    final height = widget.height ?? viewport.height;
    final itemHeight = width / widget.crossAxisCount;
    final itemWidth  = _viewCompact ? itemHeight : width;

    return SliverStickyHeader(
      header: Container(
        height: klr.tileHeight,
        color: KlrConfig.of(context).theme.bottomNavBackground,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ButtonBar(
              children: _leftActions(),
              alignment: MainAxisAlignment.start
            ),
            ButtonBar(
              children: _rightActions(),
              alignment: MainAxisAlignment.end,
            )
          ],
        )
      ), 
      sliver: widget.items.isEmpty
        ? SliverToBoxAdapter(
          child: Container(
            alignment: Alignment.center,
            height: itemHeight * 2,
            padding: klr.edge.xy(4.0, 3.0),
            color: klr.theme.cardBackground,
            child: widget.noItems ?? Text('No items...')
          )
        )
        : SliverGrid.count(
        crossAxisCount: _viewCompact ? widget.crossAxisCount : 1,
        childAspectRatio: itemWidth / itemHeight,
        children: widget.items.mapIndex(
          (item, index) => SelectableItem(
            child: widget.widgetBuilder(
              item,
              _isSelected(index),
              !_viewCompact
            ),
            onPress: _selectionActive
              ? () => _toggleSelected(index)
              : () => widget.onPressed?.call(item),
            onLongPress: () => _toggleSelected(index),
            selected: _isSelected(index),
            selectionActive: _selectionActive,
            width: itemWidth,
            height: itemHeight
          )
        ).toList(),
      )
    );
  }
}

class ListItemAction<T> {
  const ListItemAction({this.icon, this.label, this.onPressed});

  final Widget icon;
  final Widget label;
  final void Function(List<T>) onPressed;
}

class SelectableItem extends StatelessWidget {
  const SelectableItem({Key key, 
    this.selected,
    this.selectionActive,
    this.child,
    this.onPress,
    this.onLongPress,
    this.width,
    this.height,
  }) : super(key: key);

  final Widget child;
  final bool selected;
  final bool selectionActive;
  final void Function() onPress;
  final void Function() onLongPress;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final klr = KlrConfig.of(context);
    final padding = selectionActive ? klr.size(3.5) : 0;
    return InkWell(
      onLongPress: onLongPress,
      onTap: onPress,
      child: Container(
        color: klr.theme.appBarBackground,
        height: height,
        width: width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              color: klr.theme.cardBackground,
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutBack,
              child: child,
              width: width - padding,
              height: height - padding
            ),
            AnimatedContainer(
              alignment: Alignment.topLeft,
              duration: const Duration(milliseconds: 300),
              height: selectionActive ? height - padding / 2 : height,
              width: selectionActive ? width - padding / 2 : width,
              child: selectionActive 
                ? Icon(selected ? Icons.check_circle_outlined : Icons.circle)
                : null
            )
          ],
        )
      )
    );
  }
}
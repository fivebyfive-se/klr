import 'package:flutter/material.dart';

import 'package:fbf/fbf.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import 'package:klr/klr.dart';
import 'package:klr/widgets/expanding-table.dart';
import 'package:klr/widgets/text-with-icon.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class SelectableList<T> extends StatefulWidget {
  const SelectableList({
    Key key, 
    this.crossAxisCount = 5, 
    this.items, 
    this.widgetBuilder,
    this.noItems,
    this.leftActions,
    this.rightActions,
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

  final List<ListItemAction<T>> leftActions;
  final List<ListItemAction<T>> rightActions;

  final double width;
  final double height;

  final bool compact;

  @override
  _SelectableListState<T> createState() => _SelectableListState<T>();
}

class _SelectableListState<T> extends State<SelectableList<T>> {
  List<int> _selected = <int>[];
  bool _selectionActive = false;
  bool _showHelp = false;
  bool _viewCompact;

  KlrConfig get klr => KlrConfig.of(context);
  List<T> get _items => widget.items;
  List<T> get _selectedItems => _selected.map((i) => _items[i]).toList();

  List<ListItemAction<T>> get _leftActions => <ListItemAction<T>>[
    ListItemAction<T>(
      icon: Icon(LineAwesomeIcons.question_circle),
      legend: Text('Show this help message'),
      onPressed: (_) => setState(() => _showHelp = !_showHelp),
      shouldShow: (_, __) => true
    ),
    ListItemAction<T>(
      icon: Icon(LineAwesomeIcons.check),
      legend: Text('Start selection'),
      onPressed: (_) => _toggleSelectionActive(true),
      shouldShow: (_,selectionActive) => !selectionActive
    ),
    ListItemAction<T>(
      icon: Icon(LineAwesomeIcons.times),
      legend: Text('Cancel selection'),
      onPressed: (_) => _toggleSelectionActive(false),
      shouldShow: (_,selectionActive) => selectionActive
    ),
    ...(widget.leftActions ?? <ListItemAction<T>>[])
  ];

  List<ListItemAction<T>> get _rightActions => <ListItemAction<T>>[
    ...(widget.rightActions ?? <ListItemAction<T>>[]),
    ListItemAction<T>(
      icon: Icon(Icons.apps),
      legend: Text('Show as grid'),
      onPressed: (_) => _toggleViewCompact(true),
      shouldShow: (_,__) => !_viewCompact
    ),
    ListItemAction<T>(
      icon: Icon(Icons.view_stream_outlined),
      legend: Text('Show as list'),
      onPressed: (_) => _toggleViewCompact(false),
      shouldShow: (_,__) => _viewCompact
    )
  ];

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

  Widget _legendItem({
    Widget icon,
    Widget legend
  }) => Padding(
    padding: klr.edge.xy(2, 1),
    child: TextWithIcon(
      icon: icon,
      text: legend,
      spacing: klr.size()
    )
  );

  List<Widget> _itemsToIcons(List<ListItemAction<T>> list)
    => list.where((l) => l.shouldShow(_selectedItems, _selectionActive))
        .map((l) => _iconButton(
          icon: l.icon,
          label: l.label,
          onPressed: () => l.onPressed(_selectedItems)
        )).toList();

  List<Widget> _itemsToLegends(List<ListItemAction<T>> list)
    => list.where((l) => l.shouldShow(_selectedItems, _selectionActive))
        .map((l) => _legendItem(
          icon: l.icon,
          legend: l.legend
        )).toList();

  List<Widget> _getLeftActions()
    => _itemsToIcons(_leftActions);
  
  List<Widget> _getRightActions()
    => _itemsToIcons(_rightActions);

  List<Widget> _getLeftLegends() => _itemsToLegends(_leftActions);
  List<Widget> _getRightLegends() => _itemsToLegends(_rightActions);

  @override void initState(){
    super.initState();
    _viewCompact = widget.compact ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.of(context).size;
    final width = widget.width ?? viewport.width;
    final height = widget.height ?? viewport.height;
    final itemHeight = width / widget.crossAxisCount;
    final itemWidth  = _viewCompact ? itemHeight : width;
    final dur = const Duration(milliseconds: 300);
    return SliverStickyHeader(
      header: Container(
        color: klr.theme.selectableHeaderBackground,
        child: Column(
          children: [
            Container(
              height: klr.tileHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonBar(
                    children: _getLeftActions(),
                    alignment: MainAxisAlignment.start
                  ),
                  ButtonBar(
                    children: _getRightActions(),
                    alignment: MainAxisAlignment.end,
                  )
                ],
              ),
            ),
            AnimatedContainer(
              duration: dur,
              height: _showHelp ? 2.5 * klr.tileHeightx2 : 0,
              color: klr.theme.selectableHeaderBackground.deltaLightness(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: dur,
                      height: _showHelp ? 1.5 * klr.tileHeightx2 : 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _getLeftLegends(),
                      )
                    ),
                  ),

                  Expanded(
                    child: AnimatedContainer(
                      duration: dur,
                      height: _showHelp ? 1.5 * klr.tileHeightx2 : 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _getRightLegends(),
                      )
                    ),
                  )
                ],
              )
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
          ),
        );
  }
}

class ListItemAction<T> {
  const ListItemAction({
    this.icon,
    this.label,
    this.legend,
    this.onPressed,
    this.shouldShow,
  });

  final Widget icon;
  final Widget label;
  final Widget legend;

  final void Function(List<T>) onPressed;
  final bool Function(List<T>,bool) shouldShow;
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
    final padding = selectionActive ? klr.size(6) : 0;
    final selectedPadding = selectionActive ? padding / 8 : 0;
    return InkWell(
      onLongPress: onLongPress,
      onTap: onPress,
      child: Container(
        color: klr.theme.selectableItemBorder,
        height: height,
        width: width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              color: klr.theme.selectableItemBackground,
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
              height: selectionActive ? height - selectedPadding : height,
              width: selectionActive ? width - selectedPadding : width,
              child: selectionActive 
                ? Icon(
                    selected ? Icons.check_circle_outlined : Icons.circle,
                    color: selected 
                      ? klr.theme.selectableItemIconSelected
                      : klr.theme.selectableItemIcon
                  )
                : null
            )
          ],
        )
      )
    );
  }
}
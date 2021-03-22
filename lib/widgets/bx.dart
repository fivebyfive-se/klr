import 'dart:math';

import 'package:flutter/material.dart';
import 'package:klr/klr.dart';

class BxCol extends StatelessWidget {
  const BxCol({
    Key key,
    @required this.children,
    this.itemWidth,
  }): assert(children != null), 
      super(key: key);

  final List<Widget> children;
  final double itemWidth;

  @override
  Widget build(BuildContext context)
    => BxGrid(
        children: children,
        crossAxisCount: 1,
        itemExtent: itemWidth,
      );
}

class BxRow extends StatelessWidget {
  const BxRow({
    Key key,
    @required this.children,
    this.itemHeight,
  }): assert(children != null), 
      super(key: key);

  final List<Widget> children;
  final double itemHeight;

  @override
  Widget build(BuildContext context)
    => BxGrid(
        children: children,
        mainAxis: Axis.horizontal,
        crossAxisCount: 1,
        itemExtent: itemHeight,
      );
}

class BxGrid extends StatefulWidget {
  const BxGrid({
    Key key, 
    @required this.children,
    this.mainAxis = Axis.vertical, 
    this.crossAxisCount = 1,
    this.itemExtent,
  }): assert(children != null),
      super(key: key);

  final List<Widget> children;
  final int          crossAxisCount;
  final double       itemExtent;
  final Axis         mainAxis;

  @override
  _BxGridState createState() => _BxGridState();
}

class _BxGridState extends State<BxGrid> {
  FlowGridBxDelegate get _flowDelegate
    =>  FlowGridBxDelegate(
          crossAxisCount: _numCols,
          mainAxisCount: _numRows,
          mainAxis: widget.mainAxis,
        );

  int get _numRows 
    => max(1, (widget.children.length / widget.crossAxisCount).ceil());

  int get _numCols => max(1, widget.crossAxisCount);

  double get itemMainAxisExtent
    => widget.itemExtent ?? (
      widget.mainAxis == Axis.vertical
        ? KlrConfig.r(context).height / _numRows
        : KlrConfig.r(context).width / _numRows
    );
  double get itemCrossAxisExtent
    => widget.mainAxis == Axis.vertical
          ? KlrConfig.r(context).width / _numCols
          : KlrConfig.r(context).height / _numCols;

  double get _containerHeight
    => widget.mainAxis == Axis.vertical
          ? itemMainAxisExtent * _numRows
          : itemCrossAxisExtent * _numCols;

  double get _containerWidth
    => widget.mainAxis == Axis.horizontal
          ? itemMainAxisExtent * _numRows
          : itemCrossAxisExtent * _numCols;

  @override
  Widget build(BuildContext context) {
    return Bx(
        width: _containerWidth,
        height: _containerHeight,
        child: Flow(
          children: widget.children,
          clipBehavior: Clip.hardEdge,
          delegate: _flowDelegate,
        )
      );
  }
}

class Bx extends StatelessWidget {
  const Bx({
    Key key,
    @required this.child,
    this.width,
    this.height,
  }): assert(child != null),
      super(key: key);

  final Widget child;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final r = KlrConfig.r(context);

    return Container(
      width:  width  ?? r.width,
      height: height ?? r.height,
      alignment: Alignment.center,
      padding: EdgeInsets.zero,
      child: child,
    );
  }
}


class FlowGridBxDelegate extends FlowDelegate {
  FlowGridBxDelegate({
    this.mainAxis = Axis.vertical,
    this.crossAxisCount = 1,
    this.mainAxisCount = 1
  });

  final Axis mainAxis;
  final int crossAxisCount;
  final int mainAxisCount;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints box) {
    return mainAxis == Axis.vertical 
      ? box.copyWith(
          maxWidth: box.maxWidth / crossAxisCount,
          minWidth: box.minWidth / crossAxisCount,
          maxHeight: box.maxHeight / mainAxisCount,
          minHeight: box.minHeight / mainAxisCount
        )
      : box.copyWith(
          maxWidth: box.maxWidth / mainAxisCount,
          minWidth: box.minWidth / mainAxisCount,
          maxHeight: box.maxHeight / crossAxisCount,
          minHeight: box.minHeight / crossAxisCount
        );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    final numRows = mainAxisCount;
    final v = mainAxis == Axis.vertical;
    final cellSize  = Size(
      context.size.width  / (v ? crossAxisCount : numRows),
      context.size.height / (v ? numRows : crossAxisCount)
    );
    int row = 0;
    int col = 0;

    for (int i = 0; i < context.childCount; i++) {
      if (i > 0 && i % crossAxisCount == 0) {
        row++;
        col = 0;
      }
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          (v ? col : row) * cellSize.width,
          (v ? row : col) * cellSize.height,
          0,
        ),
      );
      col++;
    }
  }

  @override
  bool shouldRepaint(covariant FlowGridBxDelegate old)
    => old.mainAxis != mainAxis ||
       old.crossAxisCount != crossAxisCount;
}


import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:klr/klr.dart';

import 'bx-container.dart';
import 'bx-flow-delegate.dart';

class BxGrid extends StatefulWidget {
  const BxGrid({
    Key key, 
    @required this.children,
    this.mainAxis = Axis.vertical, 
    this.crossAxisCount = 1,

    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,

    this.decoration,
    this.foregroundDecoration,

    this.itemExtent,

    this.animate = false,
    this.animationBuilder,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 333),
  }): assert(children != null),
      assert(animate == false || animationBuilder != null),
      super(key: key);

  final List<Widget> children;
  final int          crossAxisCount;
  final double       itemExtent;
  final Axis         mainAxis;

  final AlignmentGeometry alignment;

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  final Decoration decoration;
  final Decoration foregroundDecoration;

  final bool animate;
  final Curve curve;
  final Duration duration;
  final Widget Function(BuildContext,Widget) animationBuilder;


  @override
  _BxGridState createState() => _BxGridState();
}

class _BxGridState extends State<BxGrid> {
  BxFlowDelegate get _flowDelegate
    =>  BxFlowDelegate(
          crossAxisCount: _numCols,
          mainAxisCount: _numRows,
          mainAxis: widget.mainAxis,
        );

  int get _numRows 
    => math.max(1, (widget.children.length / widget.crossAxisCount).ceil());

  int get _numCols => math.max(1, widget.crossAxisCount);

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
    return BxContainer(
        width: _containerWidth,
        height: _containerHeight,
        child: Flow(
          children: widget.children
            .map((c) => BxContainer(
              child: c,
              alignment: widget.alignment,

              padding: widget.padding,
              margin: widget.margin,

              decoration: widget.decoration,
              foregroundDecoration: widget.foregroundDecoration,

              animate: widget.animate,
              animationBuilder: widget.animationBuilder,
              duration: widget.duration,
              curve: widget.curve,
            ))
            .toList(),
          clipBehavior: Clip.hardEdge,
          delegate: _flowDelegate,
        )
      );
  }
}



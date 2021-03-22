import 'package:flutter/material.dart';

import 'bx-grid.dart';

class BxList extends BxGrid {
  const BxList({

    Key key,
    @required List<Widget> children,
    @required Axis mainAxis,
    
    double itemExtent,

    AlignmentGeometry alignment,

    EdgeInsetsGeometry padding,
    EdgeInsetsGeometry margin,

    Decoration decoration,
    Decoration foregroundDecoration,

    bool animate = false,
    Widget Function(BuildContext, Widget) animationBuilder,
    Curve curve,
    Duration duration,
  }): assert(children != null),
      assert(mainAxis != null), 
      super(
        key: key,
        mainAxis: mainAxis,
        crossAxisCount: 1,
        
        children: children,
        
        itemExtent: itemExtent,

        alignment: alignment,
        padding: padding,
        margin: margin,
        decoration: decoration,
        foregroundDecoration: foregroundDecoration,

        animate: animate,
        animationBuilder: animationBuilder,
        curve: curve,
        duration: duration
      );
}


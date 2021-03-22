import 'package:flutter/material.dart';

import 'bx-list.dart';

class BxCol extends BxList {
  const BxCol({
    Key key,
    
    @required List<Widget> children,
    
    double itemWidth,

    AlignmentGeometry alignment,

    EdgeInsetsGeometry padding,
    EdgeInsetsGeometry margin,

    Decoration decoration,
    Decoration foregroundDecoration,

    bool animate = false,
    Widget Function(BuildContext, Widget) animationBuilder,
    Curve curve,
    Duration duration,
  })
  : assert(children != null), 
    super(
      key: key,

      children: children,

      mainAxis: Axis.vertical,
      itemExtent: itemWidth,

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

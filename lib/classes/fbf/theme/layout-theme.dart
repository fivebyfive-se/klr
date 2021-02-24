import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class FivebyfiveLayoutTheme {
  FivebyfiveLayoutTheme({
    this.baseSize = 8.0,
    this.baseBorderWidth = 2.0
  }) :  this.border = FbfLayoutBorder(baseBorderWidth),
        this.edgeInsets = FbfLayoutEdge(baseSize);

  final double baseSize;
  final double baseBorderWidth;

  final FbfLayoutBorder border;
  final FbfLayoutEdge edgeInsets;

  double size([double factor = 1.0])
    => _normalizeFactor(factor) * baseSize;
  double borderWidth([double factor = 1.0])
    => _normalizeFactor(factor) * baseBorderWidth;

  FbfLayoutEdge get padding => edgeInsets;
  FbfLayoutEdge get margin => edgeInsets;
}

double _normalizeFactor(double factor)
  => (factor * 2.0).roundToDouble() / 2.0;

abstract class _FbfLayoutBase {
  _FbfLayoutBase(this.baseSize);
  final double baseSize;

  T _withSize<T>(double factor, T Function(double) callback) {
    final size = baseSize * _normalizeFactor(factor);
    return callback?.call(size);
  }
  T _withSizes2<T>(double a, double b, T Function(double,double) callback)
    => _withSize<T>(a, 
      (av) => _withSize<T>(b, 
        (bv) => callback?.call(av,bv)));
  
  T _withSizes3<T>(
    double a, double b, double c,
    T Function(double,double,double) callback
  ) => _withSizes2<T>(a, b, 
      (av, bv) => _withSize<T>(c, 
        (cv) => callback?.call(av,bv,cv)));

  T _withSizes4<T>(
    double a, double b, double c, double d,
    T Function(double,double,double,double) callback
  ) => _withSizes2<T>(a,b,
    (na, nb) => _withSizes2<T>(c, d, 
      (nc, nd) => callback?.call(na, nb, nc, nd)));
} 

class FbfLayoutEdge extends _FbfLayoutBase {
  FbfLayoutEdge([double baseSize = 8.0])
    :super(baseSize);

  EdgeInsetsGeometry y([double f = 1.0])
    => _withSize<EdgeInsetsGeometry>(f, (n) => EdgeInsets.symmetric(vertical: n));

  EdgeInsetsGeometry x([double f = 1.0])
    => _withSize<EdgeInsetsGeometry>(f, (n) => EdgeInsets.symmetric(horizontal: n));

  EdgeInsetsGeometry xy([double x = 1.0, double y = 1.0])
    => _withSizes2<EdgeInsetsGeometry>(x, y,
      (nx, ny) => EdgeInsets.symmetric(horizontal: nx, vertical: ny)
    );

  EdgeInsetsGeometry all([double f = 1.0])
    => xy(f, f);

  EdgeInsetsGeometry only({
    double top= 0.0,
    double right= 0.0,
    double bottom= 0.0,
    double left= 0.0
  })  => _withSizes4(
    top, right, bottom, left, 
    (t, r, b, l) => EdgeInsets.only(
      top: t, right: r, bottom: b, left: l));
}

class FbfLayoutBorder extends _FbfLayoutBase {
  FbfLayoutBorder([double baseBorderWidth = 2.0])
    : super(baseBorderWidth);

  BorderSide _side(double width, Color color, [BorderStyle style])
    => BorderSide(
      width: width,
      color: width <= 0 ? Colors.transparent : color,
      style: width <= 0 ? BorderStyle.none : (style ?? BorderStyle.solid)
    );

  BoxBorder x([double xf = 1.0, Color color, BorderStyle style])
    => only(left: xf, right: xf, color: color, style: style);

  BoxBorder y([double yf = 1.0, Color color, BorderStyle style])
    => only(top: yf, bottom: yf, color: color, style: style);

  BoxBorder xy([double xf = 1.0, double yf = 1.0, Color color, BorderStyle style])
    => only(left: xf, right: xf, top: yf, bottom: yf, color: color, style: style);

  BoxBorder all([double f, Color color, BorderStyle style])
    => only(top: f, right: f, bottom: f, left: f, color: color, style: style);

  BoxBorder only({
    Color color,
    BorderStyle style,
    double top= 0.0,
    double right= 0.0,
    double bottom= 0.0,
    double left= 0.0
  })  => _withSizes4(
    top, right, bottom, left, 
    (t, r, b, l) => BorderDirectional(
      top: _side(t, color, style),
      end: _side(r, color, style),
      bottom: _side(b, color, style),
      start: _side(l, color, style)
    ));
}

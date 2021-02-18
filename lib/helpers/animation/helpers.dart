import 'package:flutter/widgets.dart';

Duration parseDuration(int value) => (value < 150) 
  ? Duration(seconds: value) : Duration(milliseconds: value);


Animatable<T> makeAnimatable<T>({
  T begin,
  T end,
  Curve curve = Curves.ease
}) 
=> Tween(begin: begin, end: end)
    .chain(CurveTween(curve: curve));


typedef WidgetMapping = Widget Function(Widget);


Widget chainMappings(Iterable<WidgetMapping> mappings, Widget start) {
  Widget result = start;
  for (var mapping in mappings) {
    result = mapping(result);
  }
  return result;
}


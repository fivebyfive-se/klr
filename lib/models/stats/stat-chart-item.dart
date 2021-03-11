import 'package:charts_painter/chart.dart';
import 'package:flutter/painting.dart';

enum StatChartItemDimensions {
  luma,
  hue,
  saturation,
  lightness
}

String dimensionToString(StatChartItemDimensions dimension)
  => dimension.toString().replaceAll("StatChartItemDimensions.", "");

class StatChartItem {
  StatChartItem({this.name, this.color, this.value});

  final Color  color;
  final String name;
  final double value;

  BubbleValue<StatChartItem> get asBubbleValue
    => BubbleValue.withValue(this, value);
}

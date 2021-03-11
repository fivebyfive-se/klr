import 'dart:ui';

import 'package:flutter/painting.dart';

import 'package:fbf/fbf.dart';

import '../app-state.dart';

import 'simulated-color.dart';
import 'stat-chart-item.dart';

class PaletteColorStat {
  PaletteColorStat(PaletteColor color, [int index = 0, String label])
    : _hslColor = color.color,
      _color = color.color.toColor(),
      _index = index,
      _label = label ?? color.color.toHex();

  PaletteColorStat.fromColor(Color color, [int index = 0, String label])
    : _hslColor = color.toHSL(),
      _color = color,
      _index = index,
      _label = label ?? color.toHex();

  Color    _color;
  HSLColor _hslColor;
  int      _index;
  String   _label;
  double   _luma;

  Map<int,double> _contrasts = <int,double>{};

  SimulatedColor _simulatedColor;

  SimulatedColor get simulatedColor => _simulatedColor ?? (
    _simulatedColor = SimulatedColor(_color)
  );
  
  double contrast(Color other) {
    if (!_contrasts.containsKey(other.value)) {
      _contrasts[other.value] = color.contrast(other);
    }
    return _contrasts[other.value];
  }

  Color simulate(ColorBlindnessType type)
    => simulatedColor.simulate(type);

  PaletteColorStat simulateStat(ColorBlindnessType type)
    => PaletteColorStat.fromColor(simulate(type));

  int    get index      => _index;
  Color  get color      => _color ?? (_color = _hslColor.toColor());
  double get luma       => _luma ?? (_luma = color.luma);
  double get hue        => _hslColor.hue / 360;
  double get saturation => _hslColor.saturation;
  double get lightness  => _hslColor.lightness;
  String get label      => _label;

  double getDimension(StatChartItemDimensions dimension)
    => dimension == StatChartItemDimensions.hue        ? hue
     : dimension == StatChartItemDimensions.lightness  ? lightness
     : dimension == StatChartItemDimensions.luma       ? luma
     : dimension == StatChartItemDimensions.saturation ? saturation
     : 0.0;

  StatChartItem asChartItem(StatChartItemDimensions dimension)
    => StatChartItem(
      name: label,
      color: color,
      value: getDimension(dimension) * 100.0
    ); 
}


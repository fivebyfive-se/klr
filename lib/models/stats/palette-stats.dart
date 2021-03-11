import 'dart:ui';

import 'package:fbf/fbf.dart';
import 'package:klr/models/stats.dart';

import '../app-state.dart';

import 'palette-color-stat.dart';
import 'simulated-color.dart';

class PaletteStats {
  PaletteStats(this.palette);

  final Palette palette;

  List<PaletteColor> _colors;
  List<Color> _transformed;

  List<PaletteColor> get colors => _colors ?? (
    _colors = palette.sortedColors.toList()
  );

  List<Color> get transformed => _transformed ?? (
    _transformed = palette.transformedColors.entries
      .mapReduce(
          (p, e, _) =>  <Color>[
            ...p,
            ...e.value.map((c) => c.toColor())
          ], 
          <Color>[]
      )
  );

  bool get hasTransformed => palette.hasTransformedColors;

  Map<int,double> getContrasts(PaletteColorStat stat, [bool includeTransformed = true]) {
    return Map.fromEntries(
      [...colors, ...(includeTransformed ? transformed : [])]
        .where((c) => c.value != stat.color.value)
        .map((c) => MapEntry<int,double>(c.value, c.contrast(stat.color)))
    );
  }

  List<StatChartItem> getChartItems(
    StatChartItemDimensions dimension, {
      bool includeTransformations = true,
      ColorBlindnessType simulate = ColorBlindnessType.none
    }
  ) => getStats(includeTransformations)
        .map((s) =>
          (simulate != ColorBlindnessType.none 
            ? s.simulateStat(simulate)
            : s
          ).asChartItem(dimension) 
        ).toList();

  List<PaletteColorStat> getSimulatedStats(
    ColorBlindnessType type, [bool includeTransformations = true]
  ) => getStats(includeTransformations)
        .map((s) => s.simulateStat(type))
        .toList();
  

  List<PaletteColorStat> getStats([bool includeTransformations = true])
    => <PaletteColorStat>[
      ...colors.mapIndex(
        (item, idx) => PaletteColorStat(item, idx, item.name)
      ).toListOf<PaletteColorStat>(),
      ...(
        includeTransformations 
          ? transformed
              .mapIndex(
                  (c, i) => PaletteColorStat.fromColor(c, i, c.toString()))
              .toList()
          : []
        ).toListOf<PaletteColorStat>()
    ];
}


import 'package:flutter/material.dart';
import 'package:charts_painter/chart.dart';

import 'package:klr/klr.dart';

import 'package:klr/models/stats.dart';

class StatsChart extends StatelessWidget {
  StatsChart(this.stats, {
    this.overlay,
    this.width = 300
  });

  final List<StatChartItem> stats;
  final List<StatChartItem> overlay;
  final double width;

  List<ChartItem<StatChartItem>> 
  _statsToItems(List<StatChartItem> s)
    => s.map((s) => s.asBubbleValue).toList();

  List<ChartItem<StatChartItem>> get _items 
    => _statsToItems(stats);
  
  ChartData<StatChartItem> get _chartData
    => overlay == null
      ? ChartData.fromList(_items, axisMax: 100.0, axisMin: 0.0)
      : ChartData(
        [_items, _statsToItems(overlay)],
        axisMax: 100.0,
        axisMin: 0.0
      );

  @override
  Widget build(BuildContext context) {
    final klr = KlrConfig.of(context);

    return Chart(
      width: width,

      state: ChartState(
        _chartData,

        itemOptions: BubbleItemOptions(
          colorForKey: 
            (i, _) => (i as ChartItem<StatChartItem>).value.color,
          padding: EdgeInsets.only(top: 30),
          maxBarWidth: 30.0,          
        ),

        backgroundDecorations: [
          HorizontalAxisDecoration(
            showValues: true,
            showLines: true,
            legendFontStyle: klr.textTheme.subtitle2,
            lineColor: klr.theme.cardForeground,
            axisStep: 25.0
          )
        ],

        foregroundDecorations: [
          ValueDecoration(
            alignment: Alignment.bottomCenter,
            textStyle: klr.textTheme.bodyText1
              .copyWith(color: klr.theme.cardForeground),
          )
        ]
      )
    );
  }
}
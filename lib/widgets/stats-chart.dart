import 'package:flutter/material.dart';
import 'package:charts_painter/chart.dart';

import 'package:klr/klr.dart';

import 'package:klr/models/stats.dart';

typedef StatValueSelector = double Function(PaletteColorStat);

class StatsChart extends StatefulWidget {
  StatsChart(this.stats, {
    this.width = 300
  });

  final List<StatChartItem> stats;
  final double width;

  @override
  _StatsChartState createState() => _StatsChartState();
}

class _StatsChartState extends State<StatsChart> {
  List<ChartItem<StatChartItem>> get _items 
    => widget.stats.map((s) => s.asBubbleValue).toList();
  
  double get _width 
    => widget.width;

  @override
  Widget build(BuildContext context) {
    final klr = KlrConfig.of(context);

    return Chart(
      width: _width,

      state: ChartState(
        ChartData.fromList(_items,
          axisMax: 100.0,
          axisMin:   0.0,
        ),

        behaviour: ChartBehaviour(
          isScrollable: false,          
        ),

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
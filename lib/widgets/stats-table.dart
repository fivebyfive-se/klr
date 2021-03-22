import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:klr/klr.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/models/stats.dart';
import 'package:klr/services/palette-stats-service.dart';
import 'package:klr/widgets/expanding-table.dart';
import 'package:klr/widgets/stats-chart.dart';

import 'bx.dart';
import 'editor-tile/popup-menu-tile.dart';

class StatsTable extends StatefulWidget {
  const StatsTable({
    Key key,
    this.palette,
  }) : super(key: key);

  final Palette palette;
  @override
  _StatsTableState createState() => _StatsTableState();
}

class _StatsTableState extends State<StatsTable> {
  PaletteStatsService _statsService = PaletteStatsService.getInstance();
  ColorStatDimension _showDimension = ColorStatDimension.luma;
  ColorBlindnessType _simulateColorBlindness = ColorBlindnessType.none;

  bool _isActive = false;
  bool _includeTransformed = true;

  List<StatChartItem> get _chartItems {
    final stats = _statsService.getStats(widget.palette);
    return stats.getChartItems(_showDimension, 
      includeTransformations: _includeTransformed,
      simulate: _simulateColorBlindness
    );
  }

  @override
  Widget build(BuildContext context) {
    final klr = KlrConfig.of(context);
    final r = KlrConfig.r(context);
    final t = KlrConfig.t(context);
    final headerStyle = klr.textTheme.subtitle1.copyWith(
      color: klr.theme.tableSubHeaderForegroundColor
    );

    final chartPadding = klr.edge.all(2);
  
    return ExpandingTable(
      headerIcon: Icons.bubble_chart_outlined,
      headerLabel: t.stats_title,
      headerBuilder: (c, a) => BxRow(
        children: [
          PopupMenuTile<ColorStatDimension>(
            label: t.stats_dimension,
            items: ColorStatDimension.values,
            onSelected: (v) => setState(() => _showDimension = v),
            value: _showDimension,
            labelStyle: headerStyle,
            fieldStyle: headerStyle,
          ),
          PopupMenuTile<ColorBlindnessType>(
            label: t.stats_colorblindness,
            items: ColorBlindnessType.values,
            onSelected: (v) => setState(() => _simulateColorBlindness = v),
            value: _simulateColorBlindness,
            labelStyle: headerStyle,
            fieldStyle: headerStyle,
          ),
        ]
      ),
      contentBuilder: (c, a) => 
        Container(
          padding: chartPadding,
          child: StatsChart(
            _chartItems,
            width: r.width - chartPadding.horizontal
          ),
        ),
    );
  }
}
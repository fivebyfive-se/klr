import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:klr/klr.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/models/stats.dart';
import 'package:klr/services/palette-stats-service.dart';
import 'package:klr/widgets/stats-chart.dart';

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
    final viewport = MediaQuery.of(context).size;
    final klr = KlrConfig.of(context);
    final duration = const Duration(milliseconds: 400);

    return SliverStickyHeader(
      header: Container(
        height: 64.0,
        width: viewport.width,
        decoration: BoxDecoration(
          color: klr.theme.cardBackground,
          border: klr.border.only(top: 1.0, color: klr.theme.bottomNavBackground)
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ListTile(
                leading: Icon(
                  Icons.bubble_chart_outlined,
                  color: _isActive
                    ? klr.theme.foreground
                    : klr.theme.foregroundDisabled
                ),
                title: Text('Statistics'),
                onTap: () => setState(() => _isActive = !_isActive),
              )
            ),
            Expanded(
              child: AnimatedOpacity(
                duration: duration,
                opacity: _isActive ? 1.0 : 0.0,
                child: PopupMenuTile<ColorStatDimension>(
                  label: 'Dimension',
                  items: ColorStatDimension.values,
                  onSelected: (v) => setState(() => _showDimension = v),
                  value: _showDimension,
                ),
              )
            ),
            Expanded(
              child: AnimatedOpacity(
                duration: duration,
                opacity: _isActive ? 1.0 : 0.0,
                child: PopupMenuTile<ColorBlindnessType>(
                  label: 'Color blindness',
                  items: ColorBlindnessType.values,
                  onSelected: (v) => setState(() => _simulateColorBlindness = v),
                  value: _simulateColorBlindness,
                ),
              )
            )
          ],
        )
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          <Widget>[
            AnimatedContainer(
              duration: duration,
              height: _isActive ? viewport.height / 2.5 : 0,
              child: StatsChart(
                _chartItems,
                width: viewport.width
              )
            )
          ]
        ),
      ),
    );
  }
}
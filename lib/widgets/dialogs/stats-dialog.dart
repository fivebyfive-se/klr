import 'package:flutter/material.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/klr.dart';

import 'package:klr/models/app-state.dart';
import 'package:klr/models/stats.dart';

import 'package:klr/services/palette-stats-service.dart';

import 'package:klr/widgets/stats-chart.dart';
import 'package:klr/widgets/editor-tile/popup-menu-tile.dart';

void showStatsDialog(BuildContext context, Palette palette)
  => showDialog(
    context: context,
    builder: (context) => buildStatsDialog(context, palette)
  );

Widget buildStatsDialog(BuildContext context, Palette palette) {
  final viewportSize = MediaQuery.of(context).size;
  final dialogWidth = viewportSize.width - viewportSize.width / 3;
  final dialogHeight = viewportSize.height - viewportSize.height / 2.5;
  final contentWidth = viewportSize.width - viewportSize.width / 2;
  final chartSize = viewportSize.height / 3;

  final statsService = PaletteStatsService.getInstance();

  bool includeTransformed = true;
  ColorStatDimension showDimension = ColorStatDimension.luma;
  ColorBlindnessType simulateColorBlindness = ColorBlindnessType.none;

  return KlrStatefulBuilder(
    builder: (context, klr, setState) {
      final stats = statsService.getStats(palette);

      final chartItems = stats.getChartItems(showDimension, 
        includeTransformations: includeTransformed,
        simulate: simulateColorBlindness
      );
      
      final divider = ([double h]) 
        => Divider(
          height: klr.size(h ?? 2.0),
          thickness: klr.size(0.5),
        );

      return AlertDialog(
        backgroundColor: klr.theme.dialogBackground,
        actions: [
          FbfBtn.choice("Close", onPressed: () => Navigator.pop(context))
        ],
        title: Text('Statistics'),
        content: Container(
            width: dialogWidth,
            height: dialogHeight,
            padding: klr.edge.all(),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    width: contentWidth,
                    height: chartSize,
                    child: StatsChart(
                      chartItems,
                      width: chartSize
                    ),
                  )
                ),

                SliverToBoxAdapter(
                  child: divider(3.0)
                ),

                SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: PopupMenuTile<ColorStatDimension>(
                              label: 'Show dimension:',
                              value: showDimension,
                              items: ColorStatDimension.values,
                              onSelected: (v) => setState(() => showDimension = v),
                            )
                          ),
                          Expanded(
                            flex: 6,
                            child: PopupMenuTile<ColorBlindnessType>(
                              label: 'Simulate color-blindness:',
                              value: simulateColorBlindness,
                              onSelected: (v) => setState(() => simulateColorBlindness = v),
                              items: ColorBlindnessType.values
                            )
                          )
                        ],
                      ),


                      divider(),

                      CheckboxListTile(
                        value: includeTransformed, 
                        activeColor: stats.hasTransformed 
                          ? klr.theme.secondary
                          : klr.theme.foregroundDisabled,
                        onChanged: 
                          (v) => stats.hasTransformed 
                            ? setState(() => includeTransformed = v)
                            : null,
                        title: Text('Include automatically generated colors'),
                      ),
                    ]
                  ),
                )
              ],
            )
          )

      );
    }
  );
}
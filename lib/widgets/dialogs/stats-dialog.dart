import 'package:flutter/material.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/klr.dart';

import 'package:klr/models/app-state.dart';
import 'package:klr/models/stats.dart';

import 'package:klr/services/palette-stats-service.dart';
import 'package:klr/widgets/stats-chart.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

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
  StatChartItemDimensions showDimension = StatChartItemDimensions.luma;
  ColorBlindnessType      simulateColorBlindness = ColorBlindnessType.none;

  return KlrStatefulBuilder(
    builder: (context, klr, setState) {
      final stats = statsService
        .getStats(palette);
      final chartItems = stats.getChartItems(showDimension, 
          simulate: simulateColorBlindness,
          includeTransformations: includeTransformed
        );
      
      final divider = ([double h]) 
        => Divider(
          height: klr.size(h ?? 2.0),
          thickness: klr.size(0.5),
        );

      final buildDimensionTile = (StatChartItemDimensions dimension)
        => Container(
            width: dialogWidth / 2 - klr.size(2),
            child: RadioListTile(
              groupValue: showDimension,
              value: dimension,
              onChanged: (v) => setState(() => showDimension = v),
              title: Text('Show ' + dimensionToString(dimension)),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: klr.theme.secondary,
            )
          );

      final buildDimensionSelector = ()
        => StatChartItemDimensions.values
            .map((v) => buildDimensionTile(v)).toListOf<Widget>(); 


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
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        spacing: 0,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: buildDimensionSelector()
                      ),

                      divider(),

                      ListTile(
                        title: Text('Simulate color blindness:'),
                        trailing: DropdownButton(
                          icon: Icon(LineAwesomeIcons.glasses),
                          value: simulateColorBlindness,
                          onChanged: (v) => setState(() => simulateColorBlindness = v),
                          items: ColorBlindnessType.values.map(
                              (t) => DropdownMenuItem<ColorBlindnessType>(
                                value: t,
                                child: Text(
                                  colorBlindnessTypeToString(t)
                                ),
                              )
                            ).toList()
                        )
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
import 'package:fbf/ryb.dart';
import 'package:flutter/material.dart';

import 'package:klr/klr.dart';

import 'package:klr/models/generator.dart';
import 'package:klr/models/hsluv/hsluv-color.dart';
import 'package:klr/widgets/tabber.dart';

import 'editor-tile/number-picker-tile.dart';
import 'editor-tile/popup-menu-tile.dart';

class ColorGeneratorConfig extends StatefulWidget {
  const ColorGeneratorConfig({
    Key key,
    this.colorGenerator,
    this.onChanged,
    this.height,
    this.width,
  })
  : super(key: key);

  final ColorGenerator colorGenerator;
  final void Function(ColorGenerator) onChanged;
  final double height;
  final double width;

  @override
  _ColorGeneratorConfigState createState() => _ColorGeneratorConfigState();
}

class _ColorGeneratorConfigState extends State<ColorGeneratorConfig> {
  ColorGenerator get _generator => widget.colorGenerator;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: Tabber(
        height: widget.height,
        width: widget.width,
        tabs: [
          TabberTab(
            label: 'Hue',
            contentBuilder: (_) => ChannelGeneratorConfig(
              channelGenerator: _generator.generators[HSLChannel.hue],
              onChanged: (g) => widget.onChanged(_generator.withGenerator(HSLChannel.hue, g)),
              maxValue: 360.0,
              height: widget.height,
            )
          ),
          TabberTab(
            label: 'Sat.',
            contentBuilder: (_) => ChannelGeneratorConfig(
              channelGenerator: _generator.generators[HSLChannel.saturation],
              onChanged: (g) => widget.onChanged(_generator.withGenerator(HSLChannel.saturation, g)),
              height: widget.height,
            )
          ),
          TabberTab(
            label: 'Light.',
            contentBuilder: (_) => ChannelGeneratorConfig(
              channelGenerator: _generator.generators[HSLChannel.lightness],
              onChanged: (g) => widget.onChanged(_generator.withGenerator(HSLChannel.lightness, g)),
              height: widget.height,
            )
          )
        ],
      )
    );
  }
}

class ChannelGeneratorConfig extends StatelessWidget {
  const ChannelGeneratorConfig({
    Key key,
    this.channelGenerator,
    this.onChanged,
    this.maxValue = 100.0,
    this.height
  })
  : super(key: key);

  final ChannelGenerator channelGenerator;
  final void Function(ChannelGenerator) onChanged;
  final double maxValue;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            PopupMenuTile<GeneratorType>(
              items: GeneratorType.values,
              label: 'Generator',
              value: channelGenerator.type,
              onSelected: (v) => onChanged(channelGenerator.withType(v)),
            ),

            ...(channelGenerator.type == GeneratorType.none
              ? <Widget>[] : <Widget>[
              NumberPickerTile(
                label: 'Start',
                max: maxValue,
                value: channelGenerator.start,
                onChanged: (v) => onChanged(channelGenerator.withStart(v))
              ),
              PopupMenuTile<int>(
                label: 'Steps',
                value: channelGenerator.steps,
                items: [3,4,5,6,7,8],
                onSelected: (v) => onChanged(channelGenerator.withSteps(v))
              ),
            ]),
            ...(
              channelGenerator.type == GeneratorType.curve
              ? <Widget>[
                NumberPickerTile(
                  label: 'End',
                  max: maxValue,
                  value: channelGenerator.end,
                  onChanged: (v) => onChanged(channelGenerator.withEnd(v))
                ),

                PopupMenuTile<CurveType>(
                  label: 'Curve type',
                  value: channelGenerator.curveType,
                  items: CurveType.values,
                  onSelected: (v) => onChanged(channelGenerator.withCurveType(v)),
                ),

                PopupMenuTile<CurveDir>(
                  label: 'Curve direction',
                  value: channelGenerator.curveDir,
                  items: CurveDir.values,
                  onSelected: (v) => onChanged(channelGenerator.withCurveDir(v)),
                )
              ]
              : <Widget>[
                NumberPickerTile(
                  label: 'Step size',
                  value: channelGenerator.delta,
                  step: 1.0,
                  onChanged: (v) => onChanged(channelGenerator.withDelta(v))
                )
              ]
            )
          ],
        ),
      ),
    );
  }
}
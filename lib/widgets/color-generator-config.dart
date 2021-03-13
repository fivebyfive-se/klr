import 'package:flutter/material.dart';

import 'package:klr/klr.dart';

import 'package:klr/services/palette-generator-service.dart';
import 'package:klr/widgets/hsluv/hsluv-color.dart';
import 'package:klr/widgets/tabber.dart';

import 'editor-tile/number-picker-tile.dart';
import 'editor-tile/popup-menu-tile.dart';
import 'editor-tile/text-field-tile.dart';

class ColorGeneratorConfig extends StatefulWidget {
  const ColorGeneratorConfig({
    Key key,
    this.color,
    this.onChanged,
    this.onClose,
    this.width,
    this.height,
  }) : super(key: key);

  final ColorGenerator color;
  final void Function(ColorGenerator) onChanged;
  final void Function() onClose;
  final double width;
  final double height;

  @override
  _ColorGeneratorConfigState createState() => _ColorGeneratorConfigState();
}

class _ColorGeneratorConfigState extends State<ColorGeneratorConfig> {
  static const List<HSLChannel> _channels = [
    HSLChannel.hue, HSLChannel.saturation, HSLChannel.lightness
  ];
  ColorGenerator get _color => widget.color;

  List<HSLuvColor> get _generatedColors => [
    _color.color,
    ..._color.colors
  ];

  Widget _channelConfig(HSLChannel c)
    => ChannelGeneratorConfig(
      generator: _color.getGenerator(c),
      channel: c,
      start: _color.startColor.getChannel(c),
      numSteps: _color.steps,
      onChange: (v) {
        _color.generators[c] = v;
        widget.onChanged(_color);
      },
    );

  @override
  Widget build(BuildContext context)
    => Container(
      width: widget.width,
      height: widget.height,
      alignment: Alignment.topRight,
      child: Column(
        children: [
          Expanded(
            flex: 18,
            child: Tabber(
              height: widget.height - 100,
              width: widget.width,
              tabs: _channels.map(
                (c) => TabberTab(
                  label: _enumToString(c),
                  contentBuilder: (_) => _channelConfig(c)
                )
              ).toList()
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: Text(
                  KlrConfig.t(context).btn_close,
                  style: KlrConfig.of(context).textTheme.subtitle1
                ),
                onPressed: () => widget.onClose?.call(),
              ),
            )
          ),
        ],
      ),
    );
}

class ChannelGeneratorConfig extends StatelessWidget {
  const ChannelGeneratorConfig({
    Key key,
    this.channel,
    this.start,
    this.numSteps,
    this.generator,
    this.onChange,
  })
    : super(key: key);

  final HSLChannel channel;
  final double start;
  final int numSteps;
  final ChannelGenerator generator;
  final void Function(ChannelGenerator) onChange;

  double get maxValue => channel == HSLChannel.hue ? 360.0 : 100.0;

  ChannelGenerator _changeGenType(ChanGenType t)
    => t == ChanGenType.curve  ? CurveChannelGenerator.from(generator)
    :  t == ChanGenType.random ? RandomStepChannelGenerator.from(generator)
    :  t == ChanGenType.step   ? StepChannelGenerator.from(generator)
    : ChannelGenerator.from(generator);

  Widget _channelEditor() => 
    generator.type == ChanGenType.curve 
      ? CurveGeneratorConfig(
          generator: generator is CurveChannelGenerator 
            ? generator
            : CurveChannelGenerator.from(generator),
        maxValue: maxValue,
        onChanged: onChange)
    : generator.type == ChanGenType.step
      ? StepChannelGeneratorConfig(
        generator: generator is StepChannelGenerator
          ? generator
          : StepChannelGenerator.from(generator),
        onChanged: onChange)
    : generator.type == ChanGenType.random
      ? RandomStepChannelGeneratorConfig(
        generator: generator is RandomStepChannelGenerator
          ? generator
          : RandomStepChannelGenerator.from(generator),
        onChanged: onChange)
      : Container();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        PopupMenuTile<ChanGenType>(
          label: 'Generator type',
          items: ChanGenType.values,
          value: generator.type,
          onSelected: (t) {
            if (t != generator.type) {
              onChange?.call(_changeGenType(t));
            }
          },
        ),
        NumberPickerTile(
          label: 'Start value',
          value: generator.start,
          max: maxValue,
          onChanged: (v) => onChange?.call(generator.withStart(v)),
        ),
        _channelEditor()
      ],
    );
  }
}

class CurveGeneratorConfig extends StatelessWidget {
  const CurveGeneratorConfig({
    this.generator,
    this.onChanged,
    this.maxValue = 100.0
  });

  final CurveChannelGenerator generator;
  final double maxValue;
  final void Function(CurveChannelGenerator) onChanged;

  @override
  Widget build(BuildContext context) {
    final fireOnChanged = 
      (CurveChannelGenerator g) => onChanged?.call(g);

    return ListBody(
      children: [
        PopupMenuTile<CurveType>(
          items: CurveType.values,
          label: 'Curve',
          value: generator.curveType,
          onSelected: (t) => fireOnChanged(generator.withCurveType(t)),
        ),
        PopupMenuTile<CurveDir>(
          items: CurveDir.values,
          label: 'Easing',
          value: generator.curveDir,
          onSelected: (t) => fireOnChanged(generator.withCurveDir(t)),
        ),
        NumberPickerTile(
          label: 'End value',
          value: generator.end,
          max: maxValue,
          onChanged: (v) => fireOnChanged(generator.withEnd(v)),
        )
      
      ],
    );
  }
}

class RandomStepChannelGeneratorConfig extends StatelessWidget {
  const RandomStepChannelGeneratorConfig({
    Key key,
    this.generator,
    this.onChanged
  }) : super(key: key);

  final RandomStepChannelGenerator generator;
  final void Function(RandomStepChannelGenerator) onChanged;

  double get _minDelta => generator.minDelta;
  double get _maxDelta => generator.maxDelta;

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: <Widget>[
        NumberPickerTile(
          label: 'Minimum step',
          value: _minDelta,
          onChanged: (v) => onChanged(generator.withMinDelta(v))
        ),
        NumberPickerTile(
          label: 'Maximum step',
          value: _maxDelta,
          onChanged: (v) => onChanged(generator.withMaxDelta(v))
        )
      ],
    );
  }
}

class StepChannelGeneratorConfig extends StatelessWidget {
  const StepChannelGeneratorConfig({
    Key key,
    this.generator,
    this.onChanged,
  }) : super(key: key);

  final StepChannelGenerator generator;
  final void Function(StepChannelGenerator) onChanged;

  double get _delta => generator.delta;

  @override
  Widget build(BuildContext context) {
    return NumberPickerTile(
      label: 'Step',
      value: _delta,
      onChanged: (v) => onChanged?.call(generator.withStepDelta(v))
    );
  }
}

String _enumToString(Object e) {
  final full = e.toString();
  final period = full.indexOf('.');
  return period <= 0 ? full : full.substring(period + 1); 
}

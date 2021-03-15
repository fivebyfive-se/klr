
import 'dart:async';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fbf/fbf.dart';
import 'package:klr/services/color-name-service.dart';

import 'package:klr/models/hsluv/hsluv-color.dart';

class PaletteGeneratorService {
  @protected
  ColorNameService _nameService = ColorNameService.getInstance();

  // ignore: close_sinks
  @protected
  StreamController<List<ColorGenerator>> _streamCtrl 
    = StreamController.broadcast();

  @protected
  List<ColorGenerator> _generators = [];

  @protected
  static Random _rng;

  static Random get rng => _rng ?? (_rng = Random());

  @protected
  void _update([List<ColorGenerator> gens]) {
    _generators = [...(gens ?? _generators)];
    _streamCtrl.add(_generators);
  }

  @protected
  void _upsert(ColorGenerator ng) {
    final int idx = _generators.indexWhere((g) => g.id == ng.id);
    if (idx >= 0) {
      _generators[idx] = _generators[idx].update(ng);
      _update(_generators);
    } else {
      _update([..._generators, ng]);
    }
  }

  @protected
  _remove(ColorGenerator ng)
    => _update(_generators.where((g) => g.id != ng.id).toList());

  @protected
  HSLuvColor _randomColor({double hue, double saturation, double lightness})
    => HSLuvColor.fromAHSL(
          100.0,
          hue ?? rng.nextValue(0.0, 360.0),
          saturation ?? rng.nextValue(50, 90),
          lightness ?? rng.nextValue(40, 60)
        );

  List<ColorGenerator> get snapshot
    => [..._generators];

  Stream<List<ColorGenerator>> get colorStream
    => _streamCtrl.stream;

  Tuple2<String,HSLuvColor> _nameColor(HSLuvColor color)
    => Tuple2(
        _nameService.guessName(color.toColor()),
        color
      );

  Tuple2<String,HSLuvColor> randomNamedColor({
    double hue, double saturation, double lightness
  }) => _nameColor(
    _randomColor(
      hue: hue,
      saturation: saturation,
      lightness: lightness
    ));

  void addColor({HSLuvColor startColor, int numSteps = 5}) {
    final nc = _nameColor(startColor ?? _randomColor());
    _upsert(
      ColorGenerator(
        nc.item2,
        numSteps,
        name: nc.item1
      )
    );
  }

  void updateColor(ColorGenerator color)
    => _upsert(color);

  void removeColor(ColorGenerator color)
    => _remove(color);

  PaletteGeneratorService init() {
    if (_generators.length == 0) {
      final colorA = randomNamedColor();
      final colorB = randomNamedColor();
      _upsert(
        ColorGenerator(colorA.item2, 5,
          name: colorA.item1,
          generators: <HSLChannel,ChannelGenerator>{
            HSLChannel.hue:
              StepChannelGenerator(colorA.item2.hue, 5, 40),
            HSLChannel.saturation:
              ChannelGenerator.fromValue(colorA.item2.hue, 5),
            HSLChannel.lightness:
              StepChannelGenerator(colorA.item2.lightness, 5, 20)
          }
        )
      );
      _upsert(
        ColorGenerator(colorB.item2, 5,
          name: colorB.item1,
          generators: <HSLChannel,ChannelGenerator>{
            HSLChannel.hue:
              CurveChannelGenerator(
                colorB.item2.hue,
                colorB.item2.hue + rng.nextValue(120, 250),
                0,
                CurveType.values.randomElement(),
                CurveDir.values.randomElement()
              ),
            HSLChannel.saturation:
              RandomStepChannelGenerator(
                rng.nextValue(5, 10),
                rng.nextValue(10, 20),
                colorB.item2.saturation,
                5
              ),
            HSLChannel.lightness:
              ChannelGenerator.fromValue(colorA.item2.lightness, 5),
          }
        )
      );
    }
    return this;
  }

  @protected static PaletteGeneratorService _service;
  @protected PaletteGeneratorService();

  static PaletteGeneratorService getInstance()
    => _service ?? (_service = PaletteGeneratorService());
}

class ColorGenerator {
  ColorGenerator(this.startColor, this.steps, {
    Map<HSLChannel, ChannelGenerator> generators,
    String name,
    String id 
  })
    : id = id ?? Uuid.v4(),
      name = name ?? startColor.toShortString(),
      generators = generators ?? {
        HSLChannel.hue: ChannelGenerator.fromValue(startColor.hue, steps),
        HSLChannel.saturation: ChannelGenerator.fromValue(startColor.saturation, steps),
        HSLChannel.lightness: ChannelGenerator.fromValue(startColor.lightness, steps)
      };

  static ColorGenerator random(
    HSLuvColor start,
    int steps,
    String name
  ) {
    final _rng = PaletteGeneratorService.rng;
    final _randChanGen = (double startValue, double endValue) {
      final r1 = _rng.nextInt(3);
      return r1 == 0 ? CurveChannelGenerator(
          startValue,
          endValue,
          steps,
          CurveType.values.randomElement(),
          CurveDir.values.randomElement() )
        : r1 == 1 ? StepChannelGenerator(
            startValue,
            steps,
            _rng.nextValue(5.0, 15.0))
        : RandomStepChannelGenerator(5.0, 15.0, startValue, steps);
    };
    final rs = _rng.nextBool();
    final rl = !rs || (_rng.nextInt(3) > 1);
    final rh = rs != rl && _rng.nextBool();

    final gs = <HSLChannel, ChannelGenerator>{
      HSLChannel.hue: 
        rh ? _randChanGen(start.hue, start.hue + _rng.nextValue(90, 250))
           : ChannelGenerator.fromValue(start.hue, steps),
      HSLChannel.saturation: 
        rs ? _randChanGen(start.saturation, start.saturation + _rng.nextValue(10, 50)) 
           : ChannelGenerator.fromValue(start.saturation, steps),
      HSLChannel.lightness:
        rl ? _randChanGen(start.lightness, start.lightness + _rng.nextValue(10, 50))
           : ChannelGenerator.fromValue(start.lightness, steps)
    };
    return ColorGenerator(start, steps, name: name, generators: gs);
  }

  final String id;
  final String name;
  final HSLuvColor startColor;
  final int steps;

  ColorGenerator withName(String n)
    => ColorGenerator(
      startColor, 
      steps, 
      generators: generators,
      name: n
    );

  ColorGenerator withNumSteps(int s)
    => ColorGenerator(
      startColor, 
      s, 
      generators: generators,
      name: name
    );

  ColorGenerator withStartColor(HSLuvColor s)
    => ColorGenerator(
      s, 
      steps, 
      generators: generators,
      name: name
    );

  ColorGenerator update(ColorGenerator other)
    => ColorGenerator(
      other.startColor ?? startColor,
      other.steps  ?? steps,
      generators: other.generators ?? generators,
      id: other.id ?? id
    );

  final Map<HSLChannel, ChannelGenerator> generators;

  /// Base color
  HSLuvColor get color => colorAtStep(0);

  /// Generated colors (not including [color])
  List<HSLuvColor> get colors => colorsIterable().toList();

  Iterable<HSLuvColor> colorsIterable([int start = 1]) sync* {
    if (start < steps) {
      yield colorAtStep(start);
      yield* colorsIterable(start + 1);
    }
  }

  HSLuvColor colorAtStep(int step)
   => HSLuvColor.fromAHSL(
        startColor.alpha,
        channelAtStep(HSLChannel.hue, step),
        channelAtStep(HSLChannel.saturation, step),
        channelAtStep(HSLChannel.lightness, step),
      );

  double channelAtStep(HSLChannel channel, int step)
    => getGenerator(channel)?.valueAtStep(step) ?? 0.0;

  ChannelGenerator getGenerator(HSLChannel channel)
    => generators.containsKey(channel)
        ? generators[channel]
        : ChannelGenerator.fromValue(
            startColor.getChannel(channel),
            steps
          );

  void randomGenerator(HSLChannel channel, double minDelta, double maxDelta)
    => generators[channel] = RandomStepChannelGenerator(
          minDelta,
          maxDelta,
          startColor.getChannel(channel),
          steps,
      );

  void curveGenerator(HSLChannel channel, CurveType type, CurveDir dir, double end)
    => generators[channel] = CurveChannelGenerator(
          startColor.getChannel(channel),
          startColor.getChannel(channel),
          steps,
          type,
          dir
      );

  void stepGenerator(HSLChannel channel, double step)
    => generators[channel] = StepChannelGenerator(
          startColor.getChannel(channel),
          steps,
          step
      );
}

enum ChanGenType {
  none,
  random,
  curve,
  step
}

abstract class ChannelGenerator {
  const ChannelGenerator(
    this.start,
    this.end,
    this.steps,
    this.delta,
    this.type
  );

  factory ChannelGenerator.from(ChannelGenerator g)
    => ChannelGenerator.noop(g.start, g.end, g.steps, g.delta, g.type);

  factory ChannelGenerator.fromValue(double value, int steps)
    => ChannelGenerator.noop(value, value, steps);

  factory ChannelGenerator.noop([
    double start = 0,
    double end = 0,
    int steps = 0,
    double delta = 0,
    ChanGenType type = ChanGenType.none
  ])
    => _ChannelGenerator(start, end, steps, delta, type);

  final ChanGenType type;

  final double start;
  final double end;
  final int steps;
  final double delta;

  ChannelGenerator withStart(double s)
    => ChannelGenerator.noop(s, end, steps, delta, type);

  ChannelGenerator withEnd(double e)
    => ChannelGenerator.noop(start, e, steps, delta, type);

  ChannelGenerator withSteps(int s)
    => ChannelGenerator.noop(start, end, s, delta, type);

  ChannelGenerator withDelta(double d)
    => ChannelGenerator.noop(start, end, steps, d, type);

  double safeValue(double value) => value % end;

  double valueAtStep(int step);
}

class _ChannelGenerator extends ChannelGenerator {
  const _ChannelGenerator(
    double start, double end, int step, double delta, ChanGenType type
  ) : super(start, end, step, delta, type);

  @override
  double valueAtStep(int step) => start;
}

class RandomStepChannelGenerator extends ChannelGenerator {
  const RandomStepChannelGenerator(
    this.minDelta,
    this.maxDelta,
    double start,
    int steps
  ) : super(start, start, steps, 0, ChanGenType.random);

  factory RandomStepChannelGenerator.from(
    ChannelGenerator g,
    [double min = 0.0, double max = 0.0]
  )
    => g is RandomStepChannelGenerator
        ? g 
        : RandomStepChannelGenerator(
            min, max,
            g.start, g.steps,
          );

  final double minDelta;
  final double maxDelta;

  RandomStepChannelGenerator withMinDelta(double d)
    => RandomStepChannelGenerator(d, maxDelta, start, steps);

  RandomStepChannelGenerator withMaxDelta(double d)
    => RandomStepChannelGenerator(minDelta, d, start, steps);

  static Random get rng => PaletteGeneratorService.rng;

  @override
  double valueAtStep(int step) {
    return safeValue(
      start + rng.nextValue(
        step * minDelta,
        step * maxDelta
      )
    );
  }
}

enum CurveType {
  normal,
  cubic,
  quadratic,
  quintic,
  circ,
  expo,
  back
}

enum CurveDir {
  easeIn,
  easeOut,
  easeInOut
}

class CurveChannelGenerator extends ChannelGenerator {
  const CurveChannelGenerator(
    double start,
    double end,
    int steps,
    this.curveType,
    this.curveDir,
  ) : super(start, end, steps, 0, ChanGenType.curve);

  factory CurveChannelGenerator.from(ChannelGenerator g, [
    double end, 
    CurveType type = CurveType.normal,
    CurveDir dir = CurveDir.easeInOut 
  ])
    => (g is CurveChannelGenerator) 
        ? g 
        : CurveChannelGenerator(
            g.start,
            g.end,
            g.steps, 
            type,
            dir
          );

  final CurveType curveType;
  final CurveDir curveDir;

  CurveChannelGenerator withCurveType(CurveType t)
    => CurveChannelGenerator(start, end, steps, t, curveDir);

  CurveChannelGenerator withCurveDir(CurveDir d)
    => CurveChannelGenerator(start, end, steps, curveType, d);

  CurveChannelGenerator withEnd(double e)
    => CurveChannelGenerator(start, e, steps, curveType, curveDir);


  Curve get curve => curveFrom(curveType, curveDir);

  static Curve curveFrom(CurveType type, CurveDir direction) {
    if (curves.containsKey(type) && curves[type].containsKey(direction)) {
      return curves[type][direction];
    }
    return Curves.ease;
  }

  static List<CurveType> get curveTypes => CurveType.values;

  static const Map<CurveType,Map<CurveDir,Curve>> curves = {
    CurveType.normal: {
      CurveDir.easeInOut: Curves.ease,
      CurveDir.easeIn: Curves.easeIn,
      CurveDir.easeOut: Curves.easeOut,
    },
    CurveType.cubic: {
      CurveDir.easeInOut: Curves.easeInOutCubic,
      CurveDir.easeIn: Curves.easeInCubic,
      CurveDir.easeOut: Curves.easeOutCubic,
    },
    CurveType.quadratic: {
      CurveDir.easeInOut: Curves.easeInOutQuad,
      CurveDir.easeIn: Curves.easeInQuad,
      CurveDir.easeOut: Curves.easeOutQuad,
    },
    CurveType.quintic: {
      CurveDir.easeInOut: Curves.easeInOutQuint,
      CurveDir.easeIn: Curves.easeInQuint,
      CurveDir.easeOut: Curves.easeOutQuint,
    },
    CurveType.circ: {
      CurveDir.easeInOut: Curves.easeInOutCirc,
      CurveDir.easeIn: Curves.easeInCirc,
      CurveDir.easeOut: Curves.easeOutCirc,
    },
    CurveType.expo: {
      CurveDir.easeInOut: Curves.easeInOutExpo,
      CurveDir.easeIn: Curves.easeInExpo,
      CurveDir.easeOut: Curves.easeOutExpo,
    },
    CurveType.back: {
      CurveDir.easeInOut: Curves.easeInOutBack,
      CurveDir.easeIn: Curves.easeInBack,
      CurveDir.easeOut: Curves.easeOutBack,
    },
  };

  @override
  double valueAtStep(int step)
    => curve
        .transform((step / steps).clamp(0, 1))
        .lerp(start, end);
}

class StepChannelGenerator extends ChannelGenerator{
  const StepChannelGenerator(
    double start,
    int steps,
    double delta
  )
    : super(start, start, steps, delta, ChanGenType.step);

  factory StepChannelGenerator.from(ChannelGenerator g, [double delta = 1.0])
    => (g is StepChannelGenerator) ? g : StepChannelGenerator(g.start, g.steps, delta);

  StepChannelGenerator withStepDelta(double d)
    => StepChannelGenerator(start, steps, d);

  @override
  double valueAtStep(int step)
    => safeValue(start + (delta * step));
}
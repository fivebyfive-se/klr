import 'package:flutter/animation.dart';

import 'package:fbf/fbf.dart';

enum GeneratorType {
  none,
  step,
  curve
}

class ChannelGenerator {
  const ChannelGenerator(this.type, {
    this.start,
    this.end,
    this.delta,
    this.steps
  });

  factory ChannelGenerator.none([double start]) 
    => ChannelGenerator(GeneratorType.none, start: start);

  final GeneratorType type;
  final double start;
  final double end;
  final double delta;
  final int steps;

  double valueAtStep(int step)
    => start;
}

class StepChannelGenerator extends ChannelGenerator {
  const StepChannelGenerator(double start, double delta)
    : super(GeneratorType.step, start: start, delta: delta);

  @override
  double valueAtStep(int step)
    => start + (step * delta);
}

class CurveChannelGenerator extends ChannelGenerator {
  const CurveChannelGenerator(this.curve, double start, double end, int steps)
    : super(GeneratorType.curve, start: start, end: end, steps: steps);

  final Curve curve;

  @override
  double valueAtStep(int step)
    => curve.transform(step / steps).lerp(start, end);
}

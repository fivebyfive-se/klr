import 'package:flutter/animation.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/models/app-state/models/color-transform.model.dart';
import 'package:klr/models/hsluv.dart';

import 'channel-generator.dart';

class ColorGenerator {
  const ColorGenerator(this.start, this.steps, this.generators); 

  factory ColorGenerator.curveTo(
    HSLuvColor start,
    HSLuvColor end, 
    Curve curve, 
    int steps
  ) {
    final curveOrNoop = (double a, double b)
      => (a - b).abs() < 1.5 
            ? ChannelGenerator.none()
            : CurveChannelGenerator(curve, a, b, steps);

    return ColorGenerator(
      start,
      steps,
      {
        HSLChannel.hue: curveOrNoop(start.hue, end.hue),
        HSLChannel.saturation: curveOrNoop(start.saturation, end.saturation),
        HSLChannel.lightness: curveOrNoop(start.lightness, end.lightness),
      }
    );
  }

  factory ColorGenerator.stepTo(HSLuvColor start, HSLuvColor end, int steps) {
    final stepOrNoop = (double a, double b)
      => (a - b).abs() < 1.5
            ? ChannelGenerator.none(a)
            : StepChannelGenerator(a, (a - b) / steps);
    return ColorGenerator(start, steps, {
      HSLChannel.hue: stepOrNoop(start.hue, end.hue),
      HSLChannel.saturation: stepOrNoop(start.saturation, end.saturation),
      HSLChannel.lightness: stepOrNoop(start.lightness, end.lightness),
    });
  }

  final HSLuvColor start;
  final int steps;
  final Map<HSLChannel, ChannelGenerator> generators;

  HSLuvColor colorAtStep(int step) {
    return HSLuvColor.fromAHSL(
      start.alpha,
      generators[HSLChannel.hue].valueAtStep(step),
      generators[HSLChannel.saturation].valueAtStep(step),
      generators[HSLChannel.lightness].valueAtStep(step),
    );
  }

  Iterable<ColorTransform> toColorTransforms([int n = 0]) sync* {
    if (n < steps) {
      yield ColorTransform.fromDelta(start, colorAtStep(n));
      yield* toColorTransforms(n + 1);
    }
  }

  Harmony toHarmony(String name) {
    return Harmony(
      name: name,
      transformations: ColorTransform.listOf(
        toColorTransforms().toList()
      )
    );
  }
}

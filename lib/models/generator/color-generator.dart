import 'package:flutter/animation.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/models/app-state.dart';
import 'package:klr/models/app-state/models/color-transform.model.dart';
import 'package:klr/models/hsluv.dart';

import 'channel-generator.dart';

class ColorGenerator {
  const ColorGenerator(this.generators); 

  factory ColorGenerator.curveTo(
    HSLuvColor start,
    HSLuvColor end, 
    CurveType curveType,
    CurveDir curveDir, 
    int steps
  ) {
    final curveOrNoop = (double a, double b)
      => (a - b).abs() < 1.5 
            ? ChannelGenerator.none(a)
            : ChannelGenerator.curve(a, b, steps, curveType, curveDir);

    return ColorGenerator(
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
            : ChannelGenerator.step(a, steps, (a - b) / steps);

    return ColorGenerator({
      HSLChannel.hue: stepOrNoop(start.hue, end.hue),
      HSLChannel.saturation: stepOrNoop(start.saturation, end.saturation),
      HSLChannel.lightness: stepOrNoop(start.lightness, end.lightness),
    });
  }

  final Map<HSLChannel, ChannelGenerator> generators;

  HSLuvColor get start => HSLuvColor.fromAHSL(
    100.0,
    generators[HSLChannel.hue].start,
    generators[HSLChannel.saturation].start,
    generators[HSLChannel.lightness].start,
  );
  int get steps => generators.entries.map((e) => e.value.steps ?? 0).max();


  ColorGenerator withGenerator(HSLChannel channel, ChannelGenerator gen)
    => ColorGenerator(Map.fromEntries([
      ...generators.entries,
      MapEntry(channel, gen)
    ]));

  HSLuvColor colorAtStep(int step) {
    return HSLuvColor.fromAHSL(
      100.0,
      generators[HSLChannel.hue].valueAtStep(step),
      generators[HSLChannel.saturation].valueAtStep(step),
      generators[HSLChannel.lightness].valueAtStep(step),
    );
  }

  Iterable<HSLuvColor> toColors([int n = 0]) sync* {
    if (n < steps) {
      yield colorAtStep(n);
      yield* toColors(n + 1);
    }
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

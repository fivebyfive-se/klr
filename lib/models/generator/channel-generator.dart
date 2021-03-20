import 'package:flutter/animation.dart';

import 'package:fbf/fbf.dart';
import 'package:klr/services/palette-generator-service.dart';

enum GeneratorType {
  none,
  step,
  curve
}

class ChannelGenerator {
  const ChannelGenerator(this.type, {
    this.curveType = CurveType.normal,
    this.curveDir = CurveDir.easeInOut,
    this.start = 0,
    this.end = 100,
    this.delta = 10,
    this.steps = 5
  });

  factory ChannelGenerator.from(ChannelGenerator chanGen, {
    GeneratorType type,
    CurveType curveType,
    CurveDir curveDir,
    double start,
    double end,
    double delta,
    int steps
  }) => ChannelGenerator(
    type ?? chanGen.type, 
    curveType: curveType ?? chanGen.curveType,
    curveDir: curveDir ?? chanGen.curveDir,
    start: start ?? chanGen.start,
    end: end ?? chanGen.end,
    delta: delta ?? chanGen.delta,
    steps: steps ?? chanGen.steps,
  );

  factory ChannelGenerator.none([double start]) 
    => ChannelGenerator(GeneratorType.none, start: start);

  factory ChannelGenerator.curve([
    double start, 
    double end, 
    int steps,
    CurveType curveType,
    CurveDir curveDir
  ]) => ChannelGenerator(GeneratorType.curve,
    start: start,
    end: end,
    steps: steps,
    curveType: curveType,
    curveDir: curveDir
  );

  factory ChannelGenerator.step(
    double start,
    int steps,
    double delta,
  ) => ChannelGenerator(GeneratorType.step, start: start, steps: steps, delta: delta);

  final GeneratorType type;
  final CurveType curveType;
  final CurveDir curveDir;
  final double start;
  final double end;
  final double delta;
  final int steps;
  Curve get curve => curveType == null || curveDir == null 
    ? Curves.linear 
    : GeneratorCurves.curves[curveType][curveDir];

  ChannelGenerator withStart(double s)
    => ChannelGenerator.from(this, start: s);

  ChannelGenerator withEnd(double e)
    => ChannelGenerator.from(this, end: e);
  
  ChannelGenerator withDelta(double d)
    => ChannelGenerator.from(this, delta: d);

  ChannelGenerator withSteps(int s)
    => ChannelGenerator.from(this, steps: s);

  ChannelGenerator withType(GeneratorType type)
    => ChannelGenerator.from(this, type: type);

  ChannelGenerator withCurveType(CurveType curveType)
    => ChannelGenerator.from(this, curveType: curveType);

  ChannelGenerator withCurveDir(CurveDir curveDir)
    => ChannelGenerator.from(this, curveDir: curveDir);

  double valueAtStep(int step)
    => type == GeneratorType.step ? start + (step * delta)
     : type == GeneratorType.curve ? curve.transform(step / steps).lerp(start, end)
     : start;
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

class GeneratorCurves {
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
}


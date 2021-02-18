import 'dart:math';

import 'package:flutter/painting.dart';
import './helpers.dart';


/// [Color]
extension ColorExtensions on Color {
  String toHex({bool includeHash = false, bool includeAlpha = false}) {
    final toHex = (int n) => n.toRadixString(16).padLeft(2, "0"); 
    return (includeHash ? '#' : '') + 
      toHex(this.red) + 
        toHex(this.green) + 
          toHex(this.blue) +
            (includeAlpha ? toHex(this.alpha) : "");
  }
  HSLColor toHSL() => HSLColor.fromColor(this);

  Color deltaHue(double degrees, { bool ryb = false })
    => this.toHSL().deltaHue(degrees, ryb: ryb).toColor();

  Color deltaSaturation(double delta)
    => this.toHSL().deltaSaturation(delta).toColor();

  Color deltaLightness(double delta)
    => this.toHSL().deltaSaturation(delta).toColor();

  LinearGradient gradientTo(Color other, {Axis axis = Axis.vertical})
    => LinearGradient(
      begin: axis == Axis.vertical ? Alignment.topCenter : Alignment.centerLeft,
      end:   axis == Axis.vertical ? Alignment.bottomCenter : Alignment.centerRight,
      colors: [this, other]
    );
}


/// [HSLColor]
extension HSLColorExtensions on HSLColor {
  HSLColor deltaHue(double degrees, {bool ryb = false}) {
    final hue = ryb ? hslToRyb(this.hue) : this.hue;
    final newHue = rotateValue(hue, degrees, 360);
    return this.withHue(ryb ? rybToHsl(newHue) : newHue);
  }

  HSLColor deltaLightness(double delta)
    => this.withLightness(deltaRatio(this.lightness, delta));

  HSLColor deltaSaturation(double delta)
    => this.withSaturation(deltaRatio(this.saturation, delta));

  HSLColor deltaAlpha(double delta)
    => this.withAlpha(deltaRatio(this.alpha, delta));

  /// HSLA
  List<double> toList()
    => [this.hue, this.saturation, this.lightness, this.alpha];

  String toCss({bool hex = true}) 
    => hex ? this.toColor().toHex(includeHash: true) 
      : "hsla(${this.hue}, ${this.saturation}, ${this.lightness}, ${this.alpha})";
}

double deltaRatio(double value, double delta)
  => max(min(value * 100 + delta, 100.0), 0); 

double rotateValue(double value, double delta, double max, {double min = 0}) {
  final res = value + delta;

  return (res < min) ? res + (max - min)
    : (res > max) ? res - max
      : res;
}


/// [Gradient]
extension GradientExtensions on Gradient {
  LinearGradient toLinear() => (this as LinearGradient);
  Gradient reverse()  => this.toLinear().reverse();
}

extension LinearGradientExtensions on LinearGradient {
  BoxDecoration toDeco() => BoxDecoration(gradient:  this);

  LinearGradient reverse() 
    => LinearGradient(begin: end, end: begin, colors: colors);

  LinearGradient withBegin(AlignmentGeometry begin)
    => this.copyWith(begin: begin);

  LinearGradient withEnd(AlignmentGeometry end)
    => this.copyWith(end: end);

  LinearGradient withColors(List<Color> colors)
    => this.copyWith(colors: colors);

  LinearGradient withStops(List<double> stops)
    => this.copyWith(stops: stops);
  

  LinearGradient copyWith({
    AlignmentGeometry begin,
    AlignmentGeometry end,
    List<Color> colors,
    List<double> stops
  }) => LinearGradient(
    begin: begin ?? this.begin,
    end:   end   ?? this.end,
    colors: colors ?? this.colors,
    stops: stops ?? this.stops
  );
}
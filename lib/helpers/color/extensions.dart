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

  Color invert()
    => Color.fromARGB(
      this.alpha,
      0xff - this.red,
      0xff - this.green,
      0xff - this.blue
    );

  Color deltaHue(double degrees, { bool ryb = false })
    => this.toHSL().deltaHue(degrees, ryb: ryb).toColor();

  Color deltaSaturation(double delta)
    => this.toHSL().deltaSaturation(delta).toColor();

  Color deltaLightness(double delta)
    => this.toHSL().deltaLightness(delta).toColor();

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

  HSLColor deltaLightness(double delta) {
    final deltaL = delta / 100.0;
    var newLightness = this.lightness + deltaL;
    var deltaS = (newLightness > 1.0)
      ? -(newLightness - 1.0)
        : (newLightness < 0.0)
          ? newLightness.abs() : 0;

    return this.deltaSaturation(deltaS * 100.0) 
            .withLightness(deltaRatio(this.lightness, delta));
  }

  HSLColor deltaSaturation(double delta)
    => this.withSaturation(deltaRatio(this.saturation, delta));

  HSLColor deltaAlpha(double delta)
    => this.withAlpha(deltaRatio(this.alpha, delta));

  /// HSLA
  List<double> toList()
    => [this.hue, this.saturation, this.lightness, this.alpha];

  String toHex({bool includeHash = false})
    => this.toColor().toHex(includeHash: includeHash);

  String toCss({bool hex = true}) 
    => hex ? this.toHex(includeHash: true) 
      : ["hsla(", [
          min(this.hue.roundToDouble(),359),
          this.saturation,
          this.lightness,
          this.alpha
        ].map((d) => d.toStringAsFixed(1))
          .toList().join(","),
        ")"].join("");
}

double deltaRatio(double value, double delta)
  => max(min(value + (delta / 100.0), 1.0), 0); 

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
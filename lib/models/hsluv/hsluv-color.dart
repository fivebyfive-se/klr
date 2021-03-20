import 'dart:ui';

import 'package:fbf/ryb.dart';
import 'package:flutter/painting.dart';

import 'package:fbf/fbf.dart';

import 'contrast.dart';
import 'hsluv.dart';

enum HSLChannel {
  alpha,
  hue,
  saturation,
  lightness,
}

class HSLuvColor {
  /// Create a new [HSLuvColor]
  const HSLuvColor.fromAHSL(
    this.alpha,
    this.hue,
    this.saturation,
    this.lightness
  );

  /// Creates an [HSLuvColor] from an RGB [Color].
  ///
  /// This constructor does not necessarily round-trip with [toColor] because
  /// of floating-point imprecision.
  factory HSLuvColor.fromColor(Color color) {
    final double alpha = color.alpha / 0xFF;
    final double red = color.red / 0xFF;
    final double green = color.green / 0xFF;
    final double blue = color.blue / 0xFF;

    final List<double> luv = Hsluv.rgbToHsluv([red, green, blue]);

    final double hue = luv[0].roundToDouble();
    final double saturation = luv[1].roundToDouble();
    final double lightness = luv[2].roundToDouble();

    return HSLuvColor.fromAHSL(alpha * 100, hue, saturation, lightness);
  }

  /// Creates an instance of [HSLuvColor] from a [RYBColor]
  factory HSLuvColor.fromRYBColor(RYBColor color) {
    return HSLuvColor.fromColor(color.toColor());
  }

  /// Creates an [HSLuvColor] from a list of doubles in the order
  /// Alpha, Hue, Saturation, Lightness.
  factory HSLuvColor.fromList(List<double> list) {
    return HSLuvColor.fromAHSL(list[0], list[1], list[2], list[3]);
  }

  /// Alpha value, from 0.0 to 100.0
  final double alpha;

  /// Hue, from 0.0 to 360.0. Describes which color of the spectrum is
  /// represented. A value of 0.0 represents red, as does 360.0. Values in
  /// between go through all the hues representable in RGB. You can think of
  /// this as selecting which color filter is placed over a light.
  final double hue;

  /// Saturation, from 0.0 to 100.0. This describes how colorful the color is.
  /// 0.0 implies a shade of grey (i.e. no pigment), and 100.0 implies a color as
  /// vibrant as that hue gets. You can think of this as the purity of the
  /// color filter over the light.
  final double saturation;

  /// Lightness, from 0.0 to 100.0. The lightness of a color describes how bright
  /// a color is. A value of 0.0 indicates black, and 100.0 indicates white.
  final double lightness;

  /// Return a copy with the the channel [channel] set to [value]
  HSLuvColor withChannel(HSLChannel channel, double value)
    => channel == HSLChannel.alpha ? withAlpha(value)
     : channel == HSLChannel.hue   ? withHue(value)
     : channel == HSLChannel.saturation ? withSaturation(value)
     : channel == HSLChannel.lightness ? withLightness(value)
     : this;

  /// Return the value of the channel [channel]
  double getChannel(HSLChannel channel)
    => channel == HSLChannel.alpha ? alpha
     : channel == HSLChannel.hue   ? hue
     : channel == HSLChannel.saturation ? saturation
     : channel == HSLChannel.lightness ? lightness
     : 0.0;

  /// Return a clone of this instance with the [alpha] channel set to the
  /// supplied value
  HSLuvColor withAlpha(double a)
    => HSLuvColor.fromAHSL(a, hue, saturation, lightness);

  /// Return a clone of this instance with the [hue] channel set to the
  /// supplied value
  HSLuvColor withHue(double h)
    => HSLuvColor.fromAHSL(alpha, h, saturation, lightness);
  
  /// Return a clone of this instance with the [saturation] channel set to the
  /// supplied value
  HSLuvColor withSaturation(double s)
    => HSLuvColor.fromAHSL(alpha, hue, s, lightness);
  
  /// Return a clone of this instance with the [lightness] channel set to the
  /// supplied value
  HSLuvColor withLightness(double l)
    => HSLuvColor.fromAHSL(alpha, hue, saturation, l);

  /// Return a copy of this instance with [alpha] changed by [da]
  /// (clamped to 0.0 <= alpha <= 100).
  HSLuvColor deltaAlpha(double da)
    => withAlpha((alpha + da).clamp(0, 100.0));

  /// Return a copy of this instance with [hue] changed by [dh]
  /// (the resulting hue angle will be wrapped to 0 <= hue <= 360).
  /// If [ryb] is true, the hue is rotated in an RYB color wheel.
  HSLuvColor deltaHue(double dh, {bool ryb = false}) {
    double newHue = ryb 
      ? rybToHsl(hslToRyb(hue) + dh)
      : hue + dh;

    while (newHue < 0) {
      newHue += 360;
    }
    return withHue(newHue % 360);
  }

  /// Return a copy of this instance with [saturation] changed by [ds]
  /// (clamped to 0.0 <= saturation <= 100).
  HSLuvColor deltaSaturation(double ds)
    => withSaturation((saturation + ds).clamp(0, 100.0));

  /// Return a copy of this instance with [lightness] changed by [dl]
  /// (clamped to 0.0 <= lightness <= 100).
  HSLuvColor deltaLightness(double dl)
    => withLightness((lightness + dl).clamp(0, 100.0));

  /// Return a copy with [hue] rotated 180 degrees.
  HSLuvColor complementary()
    => withHue(hue + 180.0);

  double contrastWith(HSLuvColor other)
    => lightness > other.lightness 
      ? Contrast.contrastRatio(lightness, other.lightness)
      : Contrast.contrastRatio(other.lightness, lightness);

  /// Return a copy with lightness inverted to contrast 
  /// with this color
  HSLuvColor invertLightness([double minRatio = Contrast.W3C_CONTRAST_TEXT]) {
    final bool goLighter = lightness < 50;
    final double step = goLighter ? 1.0 : -1.0;
    double candidate = goLighter 
    ? Contrast.lighterMinL(minRatio) 
      : Contrast.darkerMaxL(minRatio, lightness);

    while (
      candidate < 100 && candidate > 0.0 
      && Contrast.contrastRatio(candidate, lightness) < minRatio
    ) {
      candidate += step;
    }
    return withLightness(candidate.clamp(0.0, 100.0));
  }

  /// Return a copy with lightness inverted to contrast 
  /// with this color
  HSLuvColor invertLightnessGreyscale()
    => invertLightness().withSaturation(0.0);

  /// Return a copy of this instance with [channel] set to the 
  /// value of that channel in [color] converted to [HSLuvColor]
  HSLuvColor withChannelFrom(Color color, HSLChannel channel) {
    final c = HSLuvColor.fromColor(color);
    return withChannel(channel, c.getChannel(channel));
  }

  /// Get hue from [color] and return a copy of this [HSLuvColor]
  /// instance with that hue
  HSLuvColor withHueFrom(Color color)
    => withChannelFrom(color, HSLChannel.hue);

  /// Return a copy of this color with its channels replaced with
  /// those in [c] that differ more than [threshold] from the
  /// original values
  HSLuvColor apply(HSLuvColor c, [double threshold = 2.5]) {
    final bd = (double a, double b) => (a - b).abs() >= threshold ? b : a;
    return HSLuvColor.fromAHSL(
      bd(alpha, c.alpha),
      bd(hue, c.hue),
      bd(saturation, c.saturation),
      bd(lightness, c.lightness)
    );
  } 

  /// Return a copy of this [HSLuvColor] with channels set
  /// to those of [color] converted to [HSLuvColor] if they
  /// differ enough from those in this instance.
  HSLuvColor applyColor(Color color, [double threshold = 2.5])
    => apply(HSLuvColor.fromColor(color), threshold);

  /// Returns this HSL color in RGB.
  Color toColor() {
    final rgb = Hsluv.hsluvToRgb([hue, saturation, lightness]);
    return Color.fromARGB(
      ((alpha / 100) * 255).toInt(),
      (rgb[0] * 255).toInt(),
      (rgb[1] * 255).toInt(),
      (rgb[2] * 255).toInt()
    );
  }

  /// Returns this [HSLuvColor] as a "regular" [HSLColor]
  HSLColor toHSLColor()
    => HSLColor.fromColor(toColor());

  List<double> toList()
    => <double>[alpha, hue, saturation, lightness];

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    return (other is HSLuvColor) &&
        other.hue == hue &&
        other.saturation == saturation &&
        other.lightness == lightness &&
        other.alpha == alpha;
  }

  @override
  int get hashCode => hashValues(alpha, hue, saturation, lightness);

  @override
  String toString() => 'A:$alpha H:$hue S:$saturation L:$lightness';

  String toShortString() 
    => 'HSLuv($hue, $saturation, $lightness)';

  String toHex() => toColor().toHex();
}
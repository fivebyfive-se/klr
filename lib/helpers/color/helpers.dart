import 'dart:ui';

import 'package:flutter/painting.dart';

import 'package:klr/classes/range.dart';

double rybToHsl(double rybHue)
    => rybToHslMap.apply(rybHue);

double hslToRyb(double hslHue)
    => rybToHslMap.apply(hslHue, reverse: true);

Color colorFromHex(String hex) {
    String normHex = hex.replaceAll('#', '');
    if (normHex.length == 3) {
      normHex = normHex[0] + normHex[0] +
        normHex[1] + normHex[1] +
        normHex[2] + normHex[2];
    }
    final getPart = (int n, {int fallback = 0})
      => normHex.length >= n+2
        ? int.tryParse(
            normHex.substring(n, n+2),
            radix: 16
          ) ?? fallback
        : fallback;

    final r = getPart(0);
    final g = getPart(2);
    final b = getPart(4);
    final a = getPart(6, fallback: 255);

    return Color.fromARGB(a, r, g, b); 
}

HSLColor hslColorFromHex(String hex)
  => HSLColor.fromColor(colorFromHex(hex));

/// Order: H, S, L, A
HSLColor hslColorFromList(List<double> channels) {
  final c = (n) => getChannel(n, channels);
  return HSLColor.fromAHSL(c(3), c(0), c(1), c(2));
}

double getChannel(int n, List<double> channels)
  => n < channels.length ? channels[n] : 0;

final RangeMapping rybToHslMap = RangeMapping([
    [ 60, 35],
    [122, 60],
    [165, 120],
    [218, 180],
    [275, 240],
    [330, 300],
    [420, 395],
  ]);


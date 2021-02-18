import 'package:flutter/painting.dart';

import '../app-state.dart';

typedef HarmonyFunction = Iterable<HSLColor> Function(HSLColor); 

class Harmonies  {
  static Iterable<String> get names
    => _definitions.keys.toList();

  static Iterable<Harmony> get  allHarmonies
    => names.map((n) => getHarmony(n)).toList();

  static Harmony getHarmony(String name)
   => _converted[name] ?? (
        _converted[name] = 
          Harmony(
            name: name,
            transformations: 
              _definitions[name].map((d) {
                  if (d is num) {
                    return HSLColor.fromAHSL(1.0, d.toDouble(), 0.0, 0.0);
                  } else if (d is List<double>) {
                    return HSLColor.fromAHSL(
                      d.length > 3 ? d[3] : 0.0,
                      d.length > 0 ? d[0] : 0.0,
                      d.length > 1 ? d[1] : 0.0,
                      d.length > 2 ? d[2] : 0.0,
                    );
                  }
                  return null;
                })
                .where((c) => c != null)
                .map((c) => ColorTransform.fromHSL(c))
          )
        );

  static Map<String,Harmony> _converted = {};

  static const Map<String, List<dynamic>> _definitions = {
    'Complementary': [180, [0,10,-30], [0,-10,0], [180,-20,30]],
    'Split Complementary': [150, 320, [150,-10,10], [300,10,-20] ],
    'Split Compl. (clockwise)': [150, 300, [150, -5], [300, 5]],
    'Split Compl. (counter-cw)': [60, 210],
    
    'Triadic': [120, 240],
    'Clash': [90, 270],
    'Tetradic': [90, 180, 270],
    
    'Four Tone (clockwise)': [60, 180, 240],
    'Four Tone (counter-cw)': [120, 180, 300],
    
    'Five Tone A': [115, 155, 205, 245],
    'Five Tone B': [40, 90, 130, 245],
    'Five Tone C': [50, 90, 205, 320],
    'Five Tone D': [40, 155, 270, 310],
    'Five Tone E': [115, 230, 270, 320],
    
    'neutral': [15, 30, 45, 60],
    'analogous': [30, 60, 90, 120],

    'sixties': [60, 120, 180, 240, 300],
  };
}
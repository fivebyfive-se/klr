import 'package:flutter/painting.dart';

typedef HarmonyFunction = Iterable<HSLColor> Function(HSLColor); 

class Harmonies  {
  static Iterable<String> get names
    => _definitions.keys.toList();

  static List<dynamic> getHarmony(String name)
    => _definitions[name];

  static const Map<String, List<dynamic>> _definitions = {
    'Complementary': [180, [0,10,-30], [0,-10,0], [180,-20,30]],
    'Split Complementary': [150, 320, [150,-10,10], [300,10,-20] ],
    'Split Compl. (clockwise)': [150, 300, [150,-5,10], [300,5,-10]],
    'Split Compl. (counter-cw)': [60, 210, [60,-10,10], [210,10,-10]],
    
    'Triadic': [120, 240, [120,-5,10], [240,5,-10]],
    'Clash': [90, 270, [90,10,-5], [270,-5,10]],
    'Tetradic': [90, 180, 270],
    
    'Four Tone (clockwise)': [60, 180, 240],
    'Four Tone (counter-cw)': [120, 180, 300],
    
    'Five Tone A': [115, 155, 205, 245],
    'Five Tone B': [40, 90, 130, 245],
    'Five Tone C': [50, 90, 205, 320],
    'Five Tone D': [40, 155, 270, 310],
    'Five Tone E': [115, 230, 270, 320],
    
    'Neutral': [15, 30, 45, 60, 75, 90],
    'Analogous': [30, 60, 90, 120, 150, 180],

    'Sixties': [60, 120, 180, 240, 300],
    'Fourties': [40, 80, 120, 160, 200, 240],
  };
}
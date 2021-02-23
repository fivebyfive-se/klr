import 'package:flutter/material.dart';

class NamedColor {
  NamedColor(this.r, this.g, this.b, this.name, this.isGood);

  final int r;
  final int g;
  final int b;
  final String name;
  final bool isGood;

  Map<String,dynamic> _pointMap;

  Map<String,dynamic> get point => _pointMap ?? (
    _pointMap = {'r': r, 'g': g, 'b': b, 'name': name }
  );

  Color get color => Color.fromARGB(0xff, r, g, b); 
}

class NameSuggestions {
  NameSuggestions(this.color, this.distances);
  final Color color;
  final Map<String,int> distances;

  String get suggestion {
    int best;
    String name;
    for (var d in distances.entries) {
      if (best == null || d.value < best) {
        best = d.value;
        name = d.key;
      }
    }
    return name;
  }
}

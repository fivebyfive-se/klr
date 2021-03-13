import 'dart:html' show HttpRequest;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:kdtree/kdtree.dart';
import 'package:klr/models/named-color.dart';

class ColorNameService {
  Map<String,NamedColor> _namedColors = {};
  KDTree _colorTree;

  static int distance(Map a, Map b)
    => pow(a['r'] - b['r'], 2) +
       pow(a['g'] - b['g'], 2) +
       pow(a['b'] - b['b'], 2);

  Future<List<List<dynamic>>> readCsv(String path) async {
    final content = await HttpRequest.getString(path);
    return CsvToListConverter(shouldParseNumbers: false).convert(content);
  }

  Future<void> init() async {
    final csv = (await readCsv('data/colornames.csv')).skip(1);
    final points = <Map>[];

    for (var line in csv) {
      final name = line[0];
      final hex = line[1];
      final isGood = line.length > 2 && line[2] == 'x';
      final r = int.parse(hex.substring(1,3), radix: 16);
      final g = int.parse(hex.substring(3,5), radix: 16);
      final b = int.parse(hex.substring(5,7), radix: 16);
      try {
      _namedColors[name] = NamedColor(r,g,b, name, isGood);

      points.add(_namedColors[name].point);
      } catch(e) {
        print(e);
        print(name);
      }
    }
    _colorTree = KDTree(points, distance, ['r', 'g', 'b']);
  }

  NameSuggestions suggestName(Color color, {int numSuggestions = 5}) {
    final point = { 'r': color.red, 'g': color.green, 'b': color.blue };
    final nearest = _colorTree.nearest(point, numSuggestions);
    final distances = Map.fromEntries(nearest.map((nr) {
      final point = nr[0];
      final distance = nr[1];
      return MapEntry<String,int>(point['name'], distance);
    }));
    return NameSuggestions(color, distances);
  }

  String guessName(Color color)
    => suggestName(color, numSuggestions: 1).suggestion;

  static ColorNameService _instance;

  static ColorNameService getInstance()
    => _instance ?? (_instance = ColorNameService());
}

ColorNameService colorNameService()
  => ColorNameService.getInstance();
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hive/hive.dart';

import 'package:klr/helpers/color.dart';
import 'package:klr/helpers/iterable.dart';

import './color-transform.model.dart';
import '_base-model.dart';

@HiveType()
class PaletteColor extends BaseModel {
  static const String boxPath = "_paletteColor";
  final String boxName = boxPath;

  PaletteColor({
    this.name = "",
    this.color,
    this.transformations,
    this.shadeDeltas,
    this.displayIndex = 0,
    this.harmony
  }) : super();

  PaletteColor.fromAdapter(
    String uuid,
    String name,
    List<double> channels,
    HiveList<ColorTransform> transformations,
    List<double> shadeDeltas,
    int displayIndex,
    String harmony,
  ) : name = name,
      color = hslColorFromList(channels),
      transformations = transformations,
      shadeDeltas = shadeDeltas ?? <double>[],
      displayIndex = displayIndex ?? 0,
      harmony = harmony,
      super.fromAdapter(uuid);

  @HiveField(1)
  String name;

  @HiveField(2)
  HSLColor color;

  @HiveField(3)
  HiveList<ColorTransform> transformations;

  @HiveField(4)
  List<double> shadeDeltas;

  @HiveField(5)
  int displayIndex;

  @HiveField(6)
  String harmony; 

  List<HSLColor> get shades
    => [0, ...shadeDeltas]
      .order<double>((a, b) => a.compareTo(b))
      .map((d) => color.deltaLightness(d)).toList();

  List<HSLColor> get transformedColors
    => transformations.map((t) => t.applyTo(color)).toList();

  @override int compareTo(BaseModel other)
    => (other is PaletteColor) 
      ? displayIndex.compareTo(other.displayIndex)
      : super.compareTo(other);

  static Future<Box<PaletteColor>> ensureBoxOf() async {
    if (Hive.isBoxOpen(boxPath)) {
      return boxOf();
    }
    return await Hive.openBox<PaletteColor>(boxPath);
  }
  static Box<PaletteColor> boxOf()
    => Hive.box<PaletteColor>(boxPath);

  static HiveList<PaletteColor> listOf()
    => HiveList<PaletteColor>(boxOf(), objects: []);

  static PaletteColor scaffold({String name, Color fromColor})
    => PaletteColor(
      name: name ?? "New color",
      color: HSLColor.fromColor(fromColor ?? Colors.grey),
      shadeDeltas: <double>[-12.5, 12.5],
      transformations: ColorTransform.listOf()
    );

  static Future<PaletteColor> scaffoldAndSave({String name, Color fromColor}) async {
    final p = scaffold(name: name, fromColor: fromColor);
    await boxOf().put(p.uuid, p);
    await p.save();
    return p;
  }
}
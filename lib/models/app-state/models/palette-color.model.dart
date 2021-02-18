import 'package:flutter/painting.dart';
import 'package:hive/hive.dart';

import 'package:klr/helpers/color.dart';

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
  }) : super();

  PaletteColor.fromAdapter(
    String uuid,
    String name,
    List<double> channels,
    HiveList<ColorTransform> transformations,
    List<double> shadeDeltas,
    int displayIndex,
  ) : name = name,
      color = hslColorFromList(channels),
      transformations = transformations,
      shadeDeltas = shadeDeltas,
      displayIndex = displayIndex,
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

  List<HSLColor> get shades
    => shadeDeltas.map((d) => color.deltaLightness(d)).toList();

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

  static PaletteColor scaffold({String name})
    => PaletteColor(
      name: name ?? "New color",
      color: HSLColor.fromAHSL(0, 0, 0, 0),
      shadeDeltas: <double>[],
      transformations: ColorTransform.listOf()
    );
}
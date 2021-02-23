import 'package:flutter/painting.dart';
import 'package:hive/hive.dart';

import 'package:klr/helpers/iterable.dart';

import './palette-color.model.dart';
import '_base-model.dart';

@HiveType()
class Palette extends BaseModel {
  static const String boxPath = "_palette";
  final String boxName = boxPath;

  Palette({
    this.name = "",
    this.colors,
    this.displayIndex = 0
  }) : super();

  Palette.fromAdapter(
    String uuid,
    String name,
    HiveList<PaletteColor> colors,
    int displayIndex,
  ) : name = name,
      colors = colors,
      displayIndex = displayIndex,
      super.fromAdapter(uuid);

  /// Unique Id
  @HiveField(1)
  String name;

  @HiveField(2)
  HiveList<PaletteColor> colors;

  @HiveField(3)
  int displayIndex;

  List<PaletteColor> get sortedColors
    => colors
        .order<PaletteColor>((a,b) => a.displayIndex.compareTo(b.displayIndex))
        .toList();

  Map<String,List<HSLColor>> get transformedColors
    => Map.fromEntries(
          sortedColors.map(
            (c) => MapEntry<String,List<HSLColor>>(c.uuid,c.transformedColors)
          )
        );

  @override int compareTo(BaseModel other)
    => (other is Palette) 
      ? displayIndex.compareTo(other.displayIndex)
      : super.compareTo(other);
  

  static Future<Box<Palette>> ensureBoxOf() async {
    if (Hive.isBoxOpen(boxPath)) {
      return boxOf();
    }
    return await Hive.openBox<Palette>(boxPath);
  }

  static Box<Palette> boxOf()
    => Hive.box<Palette>(boxPath);

  static HiveList<Palette> listOf({List<Palette> objects})
    => HiveList<Palette>(boxOf(), objects: objects ?? []);

  static Palette scaffold({String name, List<PaletteColor> colors})
    => Palette(
      name: name ?? "New palette",
      colors: PaletteColor.listOf(objects: colors)
    );

  static Future<Palette> scaffoldAndSave({
    String name,
    List<PaletteColor> colors
  }) async {
    final p = scaffold(name: name, colors: colors);
    await boxOf().put(p.uuid, p);
    await p.save();
    return p;
  }
}
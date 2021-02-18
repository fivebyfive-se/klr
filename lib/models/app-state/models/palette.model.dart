import 'package:hive/hive.dart';

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

  static HiveList<Palette> listOf()
    => HiveList<Palette>(boxOf());

  static Palette scaffold({String name})
    => Palette(
      name: name ?? "New palette",
      colors: PaletteColor.listOf()
    );
}
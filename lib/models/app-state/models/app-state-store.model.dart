import 'package:hive/hive.dart';

import '_base-model.dart';

@HiveType()
class AppStateStore extends BaseModel {
  static const String boxPath = "_appState";
  final String boxName = boxPath;

  AppStateStore() : super();

  AppStateStore.fromAdapter(
    String uuid,
    String currPalette,
    String currColor,
    DateTime lastUpdate,
  )
    : this.currentPalette = currPalette,
      this.currentColor = currColor,
      this.lastUpdate = lastUpdate,
      super.fromAdapter(uuid);

  @HiveField(1)
  String currentPalette;

  @HiveField(2)
  String currentColor;

  DateTime lastUpdate;

  static Future<Box<AppStateStore>> ensureBoxOf() async {
    if (Hive.isBoxOpen(boxPath)) {
      return boxOf();
    }
    return await Hive.openBox<AppStateStore>(boxPath);
  }
  static Box<AppStateStore> boxOf()
    => Hive.box<AppStateStore>(boxPath);

}


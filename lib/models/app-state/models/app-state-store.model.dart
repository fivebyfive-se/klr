import 'package:hive/hive.dart';

import '_base-model.dart';

@HiveType()
class AppStateStore extends BaseModel {
  static const String boxPath = "_appState";
  final String boxName = boxPath;

  AppStateStore() : super();

  AppStateStore.fromAdapter(String uuid, String currPalette)
    : this.currentPalette = currPalette,
      super.fromAdapter(uuid);

  @HiveField(1)
  String currentPalette;

  static Future<Box<AppStateStore>> ensureBoxOf() async {
    if (Hive.isBoxOpen(boxPath)) {
      return boxOf();
    }
    return await Hive.openBox<AppStateStore>(boxPath);
  }
  static Box<AppStateStore> boxOf()
    => Hive.box<AppStateStore>(boxPath);

}


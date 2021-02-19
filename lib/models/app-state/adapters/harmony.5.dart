import 'package:hive/hive.dart';

import '../models.dart';

class HarmonyAdapter extends TypeAdapter<Harmony> {
  @override final int typeId = 5;
  
  @override
  Harmony read(BinaryReader reader) {
    return Harmony.fromAdapter(
      reader.readString(),
      reader.readString(),
      reader.readHiveList().castHiveList<ColorTransform>()
    );
  }

  @override
  void write(BinaryWriter writer, Harmony obj) {
    writer.writeString(obj.uuid);
    writer.writeString(obj.name);
    
    writer.writeHiveList(obj.transformations);
  }
}

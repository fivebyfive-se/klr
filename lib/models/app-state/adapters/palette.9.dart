import 'package:hive/hive.dart';

import '../models.dart';

class PaletteAdapter extends TypeAdapter<Palette> {
  @override final int typeId = 9;

  @override
  Palette read(BinaryReader reader) {
    return Palette.fromAdapter(
      reader.readString(),
      reader.readString(),
      reader.readHiveList().castHiveList<PaletteColor>(),
      reader.readInt()
    );
  }

  @override
  void write(BinaryWriter writer, Palette obj) {
    writer.writeString(obj.uuid);
    writer.writeString(obj.name);
    writer.writeHiveList(obj.colors);
    writer.writeInt(obj.displayIndex);
  }
}
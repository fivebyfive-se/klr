import 'package:hive/hive.dart';

import 'package:fbf/flutter_color.dart';

import '../models.dart';

class PaletteColorAdapter extends TypeAdapter<PaletteColor> {
  @override final int typeId = 7;
  
  @override
  PaletteColor read(BinaryReader reader) {
    return PaletteColor.fromAdapter(
      reader.readString(),
      reader.readString(),

      reader.readDoubleList(),

      reader.readHiveList().castHiveList<ColorTransform>(),

      reader.readDoubleList(),
      reader.readInt(),
      reader.readString()
    );
  }

  @override
  void write(BinaryWriter writer, PaletteColor obj) {
    writer.writeString(obj.uuid);
    writer.writeString(obj.name);

    writer.writeDoubleList(obj.color?.toList() ?? [0.0, 0.0, 0.0, 0.0]);

    writer.writeHiveList(obj.transformations);

    writer.writeDoubleList(obj.shadeDeltas);
    writer.writeInt(obj.displayIndex);
    writer.writeString(obj.harmony ?? "");
  }
}

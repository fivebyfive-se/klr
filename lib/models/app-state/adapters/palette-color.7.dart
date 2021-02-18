import 'package:hive/hive.dart';

import 'package:klr/helpers/color.dart';

import '../models.dart';

class PaletteColorAdapter extends TypeAdapter<PaletteColor> {
  @override final int typeId = 7;
  
  @override
  PaletteColor read(BinaryReader reader) {
    return PaletteColor.fromAdapter(
      reader.readString(),
      reader.readString(),

      reader.readDoubleList(),

      reader.readHiveList(),

      reader.readDoubleList(),
      reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, PaletteColor obj) {
    writer.writeString(obj.uuid);
    writer.writeString(obj.name);

    writer.writeDoubleList(obj.color.toList());

    writer.writeHiveList(obj.transformations);

    writer.writeDoubleList(obj.shadeDeltas);

    writer.writeInt(obj.displayIndex);
  }
}

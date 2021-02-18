import 'package:hive/hive.dart';

import '../models.dart';

class ColorTransformAdapter extends TypeAdapter<ColorTransform> {
  @override final int typeId = 3;
  
  @override
  ColorTransform read(BinaryReader reader) {
    return ColorTransform.fromAdapter(
      reader.readString(),
      
      reader.readDouble(),
      reader.readDouble(),
      reader.readDouble(),
      reader.readDouble(),

      reader.readBool()
    );
  }

  @override
  void write(BinaryWriter writer, ColorTransform obj) {
    writer.writeString(obj.uuid);
    
    writer.writeDouble(obj.deltaHue);
    writer.writeDouble(obj.deltaSaturation);
    writer.writeDouble(obj.deltaLightness);
    writer.writeDouble(obj.deltaAlpha);

    writer.writeBool(obj.moveHueInRYB);
  }
}
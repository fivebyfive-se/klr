import 'package:hive/hive.dart';
import 'package:klr/models/app-state.dart';

class AppStateStoreAdapter extends TypeAdapter<AppStateStore> {
  @override int get typeId => 11;


  @override AppStateStore read(BinaryReader reader)
    => AppStateStore
      .fromAdapter(reader.readString(), reader.readString());

  @override void write(BinaryWriter writer, AppStateStore obj) {
    writer.writeString(obj.uuid);
    writer.writeString(obj.currentPalette);
  }

}
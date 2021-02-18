
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

abstract class BaseModel
extends HiveObject 
implements Comparable<BaseModel> {
  final String boxName = "none";

  /// Unique Id
  @HiveField(0)
  final String uuid;

  BaseModel()
    : uuid = Uuid().v4();

  BaseModel.fromAdapter(String uuid)
    : uuid = uuid;

  int compareTo(BaseModel other)
    => uuid.compareTo(other.uuid);
}



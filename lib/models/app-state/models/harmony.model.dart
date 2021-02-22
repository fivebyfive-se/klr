import 'package:flutter/painting.dart';
import 'package:hive/hive.dart';

import 'color-transform.model.dart';
import '_base-model.dart';

@HiveType()
class Harmony extends BaseModel {
  static const String boxPath = "_harmony";
  final String boxName = boxPath;

  Harmony({this.name, this.transformations}) : super();

  Harmony.fromAdapter(
    String uuid,
    String name,
    HiveList<ColorTransform> transformations
  ) : name = name,
      transformations = transformations,
      super.fromAdapter(uuid);

  /// Unique Id
  @HiveField(1)
  String name;

  @HiveField(2)
  HiveList<ColorTransform> transformations;

  List<HSLColor> applyTo(HSLColor source)
    => transformations.map((t) => t.applyTo(source)).toList();


  static Future<Box<Harmony>> ensureBoxOf() async {
    if (Hive.isBoxOpen(boxPath)) {
      return boxOf();
    }
    return await Hive.openBox<Harmony>(boxPath);
  }

  static Box<Harmony> boxOf()
    => Hive.box<Harmony>(boxPath);

  static HiveList<Harmony> listOf()
    => HiveList<Harmony>(boxOf());

  static Harmony scaffold({String name})
    => Harmony(
      name: name ?? "New harmony",
      transformations: ColorTransform.listOf()
    );

  static Future<Harmony> scaffoldAndSave({String name}) async {
    final p = scaffold(name: name);
    await boxOf().put(p.uuid, p);
    await p.save();
    return p;
  }
}

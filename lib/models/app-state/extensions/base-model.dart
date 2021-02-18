import 'dart:async';

import 'package:hive/hive.dart';

import '../models.dart';


extension BaseModelExtensions on BaseModel {
  Future<Box<T>> ensureBox<T>() async {
    if (Hive.isBoxOpen(this.boxName)) {
      return Hive.box<T>(this.boxName);
    }
    return await Hive.openBox<T>(this.boxName);
  }

  Future<T> addOrSave<T extends BaseModel>() async {   
    if (this.isInBox) {
      this.save();
    } else {
      (await this.ensureBox<T>())
        .put(this.uuid, this);
    }
    return this;
  }
}

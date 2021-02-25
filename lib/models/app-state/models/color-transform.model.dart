import 'package:flutter/painting.dart';
import 'package:hive/hive.dart';

import 'package:fbf/flutter_color.dart';

import '_base-model.dart';


@HiveType()
class ColorTransform extends BaseModel {
  static const String boxPath = "_colorTransform";
  final String boxName = boxPath;

  ColorTransform({
    this.deltaHue = 0,
    this.deltaSaturation = 0,
    this.deltaLightness = 0,
    this.deltaAlpha = 0,
    this.moveHueInRYB = false
  }) : super();

  ColorTransform.fromAdapter(
    String uuid,
    double deltaHue,
    double deltaSaturation,
    double deltaLightness,
    double deltaAlpha,
    bool moveHueInRYB
  ) : deltaHue = deltaHue,
      deltaSaturation = deltaSaturation,
      deltaLightness = deltaLightness,
      deltaAlpha = deltaAlpha,
      moveHueInRYB = moveHueInRYB,
      super.fromAdapter(uuid);

  ColorTransform.fromHSL(HSLColor color)
    : deltaHue = color.hue,
      deltaSaturation = color.saturation,
      deltaLightness = color.lightness,
      deltaAlpha = color.alpha,
      super();

  /// Add this value to hue (0-360)
  @HiveField(1)
  double deltaHue;

  /// Add this value to saturation (0-100)
  @HiveField(2)
  double deltaSaturation;

  /// Add this value to lightness (0-100)
  @HiveField(3)
  double deltaLightness;

  /// Add this value to alpha (0-100)
  @HiveField(4)
  double deltaAlpha;

  /// Whether to convert hue to RYB
  /// color-space before rotating it
  /// (the resunt is converted back to RGB).
  /// Defaults to false
  @HiveField(5)
  bool moveHueInRYB;

  HSLColor applyTo(HSLColor color)
    => color.deltaHue(deltaHue, ryb: moveHueInRYB)
            .deltaSaturation(deltaSaturation)
            .deltaLightness(deltaLightness)
            .deltaAlpha(deltaAlpha);

  static Future<Box<ColorTransform>> ensureBoxOf() async {
    if (Hive.isBoxOpen(boxPath)) {
      return boxOf();
    }
    return await Hive.openBox<ColorTransform>(boxPath);
  }
  static Box<ColorTransform> boxOf()
    => Hive.box<ColorTransform>(boxPath);

  static HiveList<ColorTransform> listOf()
    => HiveList<ColorTransform>(boxOf(), objects: []);

  static ColorTransform scaffold()
    => ColorTransform();

  static Future<ColorTransform> scaffoldAndSave() async {
    final p = scaffold();
    await boxOf().put(p.uuid, p);
    await p.save();
    return p;
  }
}


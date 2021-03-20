import 'package:fbf/hsluv.dart';

import 'package:klr/models/app-state.dart';
import 'package:klr/services/app-state-service.dart';

import 'harmonies.dart';
import 'palettes.dart';

export 'harmonies.dart';
export 'palettes.dart';

class BuiltinBuilder {
  static AppStateService _service = appStateService();

  static Future<Palette> buildPalette() async {
    _service.beginTransaction();
    int i = 0;
    final palette = await Palette.scaffoldAndSave(name: 'VHS-60');
    for (var e in Palettes.vhs60.entries) {
      final c = await PaletteColor.scaffoldAndSave(name: e.key);
      c.color = e.value.toHSLuvColor();
      c.displayIndex = i++;
      await c.save();
      palette.colors.add(c);
    }
    await palette.save();
    _service.endTransaction();
    return palette;
  }

  static Future<void> buildHarmonies() async {
    if (Harmony.boxOf().isNotEmpty) {
      return;
    }
    _service.beginTransaction();
    for (var n in Harmonies.names) {
      final transforms = Harmonies.getHarmony(n);
      final harmony = await Harmony.scaffoldAndSave(name: n);

      for (var d in transforms) {
        final transform = await ColorTransform.scaffoldAndSave();
        if (d is num) {
          transform.deltaHue = d;
        } else if (d is List<num>) {
            transform.deltaHue = d.length > 0 ? d[0] : 0;
            transform.deltaSaturation = d.length > 1 ? d[1] : 0;
            transform.deltaLightness = d.length > 2 ? d[2] : 0;
            transform.deltaAlpha = d.length > 3 ? d[3] : 0;
        }
        await transform.save();
        harmony.transformations.add(transform);
      }
      await harmony.save();
    }
    _service.endTransaction();
  }
}
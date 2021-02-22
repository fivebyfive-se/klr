import 'package:klr/models/app-state.dart';
import 'package:klr/helpers/color.dart';

import 'harmonies.dart';
import 'palettes.dart';

export 'harmonies.dart';
export 'palettes.dart';

class BuiltinBuilder {
  static Future<Palette> buildPalette() async {
    final p = Palette.scaffold(name: "vhs60");
    
    for (var e in Palettes.vhs60.entries) {
      final c = PaletteColor.scaffold(name: e.key);
      c.color = e.value.toHSL();
      PaletteColor.boxOf().put(c.uuid, c);
      p.colors.add(c);
      await c.save();
    }
    Palette.boxOf().put(p.uuid, p);
    await p.save();

    return p;
  }

  static Future<void> buildHarmonies() async {
    if (Harmony.boxOf().isNotEmpty) {
      return;
    }
    for (var n in Harmonies.names) {
      final transforms = Harmonies.getHarmony(n);
      final harmony = Harmony.scaffold(name: n);
      Harmony.boxOf().put(harmony.uuid, harmony);

      for (var d in transforms) {
        final transform = ColorTransform.scaffold();
        if (d is num) {
          transform.deltaHue = d;
        } else if (d is List<double>) {
          if (d.length > 0) {
            transform.deltaHue = d[0];
            if (d.length > 1) {
              transform.deltaSaturation = d[1];
              if (d.length > 2) {
                transform.deltaLightness = d[2];
                if (d.length > 3) {
                  transform.deltaAlpha = d[3];
                }
              }
            }
          }
        }
        ColorTransform.boxOf().put(transform.uuid, transform);
        await transform.save();
        harmony.transformations.add(transform);
        await harmony.save();
      }
    }
  }
}
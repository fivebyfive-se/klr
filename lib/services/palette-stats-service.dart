import 'package:flutter/material.dart';

import 'package:klr/models/app-state.dart';
import 'package:klr/models/stats.dart';

class PaletteStatsService {
  @protected
  Map<String, PaletteStats> _stats = <String,PaletteStats>{};

  PaletteStats getStats(Palette p) {
    if (!_stats.containsKey(p.uuid)) {
      _stats[p.uuid] = PaletteStats(p);
    }
    return _stats[p.uuid];
  }

  //#region Singleton
  @protected
  PaletteStatsService();

  @protected
  static PaletteStatsService _instance;

  static PaletteStatsService getInstance()
    => _instance ?? (_instance = PaletteStatsService());
  //#endregion
}


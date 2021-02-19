import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:klr/app/klr.dart';

import 'package:klr/models/app-state.dart';
import 'package:klr/widgets/bottom-sheet-menu.dart';

class AppStateService {
  static const String rootKey = "klrState";

  @protected
  StreamController<AppState> _streamController = StreamController.broadcast();

  @protected
  AppState _currentAppState;

  @protected AppState _loadState()
    => _currentAppState = AppState(
      palettes: Palette.boxOf().values.toList(),
      harmonies: Harmony.boxOf().values.toList(),
      stateStore: AppStateStore.boxOf()
        .get(rootKey, defaultValue: AppStateStore())
    );

  @protected void _update()
    => _streamController.add(_loadState());

  AppState get snapshot => _currentAppState ?? (_currentAppState = _loadState());
  Stream<AppState> get appStateStream => _streamController.stream;

  Future<void> init() async {
    Hive.registerAdapter(ColorTransformAdapter());
    Hive.registerAdapter(HarmonyAdapter());
    Hive.registerAdapter(PaletteColorAdapter());
    Hive.registerAdapter(PaletteAdapter());
    Hive.registerAdapter(AppStateStoreAdapter());

    await Hive.initFlutter();

    final onBoxEvent = (BoxEvent ev) {
      print(ev.key);
      _update();
    };
    (await ColorTransform.ensureBoxOf()).listen(onBoxEvent);
    (await Harmony.ensureBoxOf()).listen(onBoxEvent);
    (await PaletteColor.ensureBoxOf()).listen(onBoxEvent);
    (await Palette.ensureBoxOf()).listen(onBoxEvent);
    (await AppStateStore.ensureBoxOf()).listen(onBoxEvent);
  }

  Future<ColorTransform> createColorTransform() async
    => await ColorTransform.scaffold().addOrSave();

  Future<Palette> createPalette() async
    => await Palette.scaffold().addOrSave();

  Future<PaletteColor> createColor() async
    => await PaletteColor.scaffold().addOrSave();

  Future<Harmony> createHarmony() async 
    => await Harmony.scaffold().addOrSave();

  Future<void> setCurrentPalette(Palette p) async {
    snapshot.stateStore.currentPalette = p.uuid;
    await snapshot.stateStore.save();
  }

  void dispose() {
    if (!_streamController.isClosed) {
      _streamController.close();
    }
  }

  @protected
  static AppStateService _instance;

  static AppStateService getInstance()
    => _instance ?? (_instance = AppStateService());
}

AppStateService appStateService() 
  => AppStateService.getInstance();


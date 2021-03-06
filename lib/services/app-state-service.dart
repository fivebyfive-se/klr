import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:fbf/fbf.dart';
import 'package:fbf/hsluv.dart';

import 'package:klr/models/app-state.dart';
import 'package:klr/services/color-name-service.dart';

class AppStateService {
  static const String rootKey = "klrState";

  Random _rng = Random();

  bool get _inTransaction => _transactionCount > 0;

  int _transactionCount = 0;

  @protected
  ColorNameService get _nameService => ColorNameService.getInstance();

  @protected
  StreamController<AppState> _streamController = StreamController.broadcast();

  @protected
  AppState _currentAppState;

  @protected AppState _loadState()
    => _currentAppState = AppState(
      palettes: Palette.boxOf().values
        .order<Palette>((a,b) => a.displayIndex.compareTo(b.displayIndex)).toList(),
      harmonies: Harmony.boxOf().values.toList(),
      stateStore: AppStateStore.boxOf()
        .get(rootKey, defaultValue: AppStateStore())
    );

  @protected void _update() {
    if (!_inTransaction) {
      _streamController.add(_loadState());
    }
  }

  AppState 
  get snapshot 
    => _currentAppState ?? (_currentAppState = _loadState());

  Stream<AppState> 
  get appStateStream 
    => _streamController.stream;

  Future<void> init() async {
    Hive.registerAdapter(ColorTransformAdapter());
    Hive.registerAdapter(HarmonyAdapter());
    Hive.registerAdapter(PaletteColorAdapter());
    Hive.registerAdapter(PaletteAdapter());
    Hive.registerAdapter(AppStateStoreAdapter());

    await Hive.initFlutter();

    final onBoxEvent = (BoxEvent ev) {
      if (!_inTransaction) {
        _update();
      }
    };
    (await ColorTransform.ensureBoxOf()).listen(onBoxEvent);
    (await Harmony.ensureBoxOf()).listen(onBoxEvent);
    (await PaletteColor.ensureBoxOf()).listen(onBoxEvent);
    (await Palette.ensureBoxOf()).listen(onBoxEvent);
    (await AppStateStore.ensureBoxOf()).listen(onBoxEvent);

    if (Harmony.boxOf().isEmpty) {
      await BuiltinBuilder.buildHarmonies();
    }
  }

  void beginTransaction() => _transactionCount++;
  void endTransaction() {
    _transactionCount--;
    _update();
  }

  Future<ColorTransform> createColorTransform() async
    => await ColorTransform.scaffold().addOrSave();

  Future<Palette> createPalette() async
    => await Palette.scaffold(name: "Palette #${snapshot.numPalettes + 1}").addOrSave();

  Future<void> setCurrentColor(PaletteColor pc) async {
    snapshot.stateStore.currentColor = pc?.uuid;
    await snapshot.stateStore.save();
  }

  Future<PaletteColor> createColor() async
    =>  await PaletteColor.scaffold().addOrSave();

  Future<PaletteColor> createRandomColor([double hue]) async {
    final col = HSLuvColor.fromAHSL(
        100,
        hue ?? _rng.nextValue(0, 359),
        _rng.nextValue(45, 95),
        _rng.nextValue(50, 75)
      );
    final c = await PaletteColor.scaffoldAndSave(
      fromColor: col,
      name: _nameService.guessName(col.toColor()) 
    );
    return c;
  }

  Future<Harmony> createHarmony() async 
    => await Harmony.scaffold().addOrSave();

  Future<void> setCurrentPalette(Palette p) async {
    snapshot.stateStore.currentPalette = p.uuid;
    await snapshot.stateStore.save();
  }

  Future<Palette> createBuiltinPalette() async {
    final p = await BuiltinBuilder.buildPalette();
    await setCurrentPalette(p);
    return p;
  }

  Future<Palette> createDefaultPalette() async {
    final p = await Palette.scaffoldAndSave(name: 'KLR-60');
    var c = await createRandomColor();
    for (int i = 0; i < 5; i++) {
      p.colors.add(c);
      c = await createRandomColor((c.color.hue + 60) % 360);
    }
    await p.save();
    return p;
  }

  Future<void> deleteColor(PaletteColor pc) async {
    if (snapshot.currentPalette != null) {
      snapshot.currentPalette.colors.remove(pc);
      await snapshot.currentPalette.save();
    }
    await pc.delete();
  }

  Future<void> deletePalette(Palette p) async {
    beginTransaction();
    for (final c in p.colors) {
      await c.delete();
    }
    await p.delete();
    endTransaction();
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


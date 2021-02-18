
import 'package:klr/models/app-state.dart';

import 'harmony.model.dart';
import 'palette.model.dart';

class AppState {
  AppState({
    List<Palette> palettes,
    List<Harmony> harmonies,
    AppStateStore stateStore,
  })
    : palettes = palettes ?? [],
      harmonies = harmonies ?? [],
      stateStore = stateStore;

  final List<Palette> palettes;
  final List<Harmony> harmonies;
  final AppStateStore stateStore;

  Palette get currentPalette 
    => stateStore.currentPalette == null || palettes == null || palettes.isEmpty 
      ? null
      : palettes.firstWhere(
          (p) => p.uuid == stateStore.currentPalette,
          orElse: () => null
        );
}

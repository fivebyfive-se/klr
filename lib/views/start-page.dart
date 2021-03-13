import 'package:flutter/material.dart';
import 'package:klr/widgets/dialogs/palette-generator-dialog.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/klr.dart';
import 'package:klr/app/klr/colors.dart';

import 'package:klr/models/app-state.dart';
import 'package:klr/models/app-state/models/app-state.dart';

import 'package:klr/services/app-state-service.dart';

import 'package:klr/widgets/dialogs/image-picker-dialog.dart';

import 'page-data/start-page-data.dart';
import 'palette-page.dart';

class StartPage extends FbfPage<StartPageData> {
  static Color pageAccent = KlrColors.getInstance().pink95;
  static Color onPageAccent = KlrColors.getInstance().grey05; 
  static const String routeName = '/start';
  static const String title = 'dashboard';

  static bool mounted = false;

  StartPage() : super();

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with KlrConfigMixin {
  AppStateService _appStateService = AppStateService.getInstance();
  AppState get _appState => _appStateService.snapshot;

  static const String menuClearPalettes = "clear-all-palettes";
  static const String menuClearAll      = "clear-everything";
  static const String menuCancel        = "cancel";

  List<FbfFabMenuItem> get _menuItems => [
    FbfFabMenuItem(
      icon: Icon(LineAwesomeIcons.alternate_trash, color: klr.theme.tertiaryAccent),
      title: t.start_fabMenu_clear,
      subtitle: t.start_fabMenu_clearDesc,
      value: menuClearPalettes
    ),
    FbfFabMenuItem(
      icon: Icon(LineAwesomeIcons.alternate_trash, color: klr.theme.tertiaryAccent),
      title: t.start_fabMenu_clearAll,
      subtitle: t.start_fabMenu_clearAllDesc,
      value: menuClearAll
    ),
    FbfFabMenuItem(
      icon: Icon(Icons.cancel_outlined, color: klr.theme.secondaryAccent),
      title: t.fabMenu_close,
      subtitle: t.fabMenu_closeDesc,
      value: menuCancel
    )
  ];

  Future<void> _createPalette() async {
    showGeneratorDialog(context);
      // final p = await _appStateService.createBuiltinPalette();
  }
  Future<void> _clearPalettes() async {
    await Palette.boxOf().clear();
  }
  Future<void> _clearAll() async {
    await _appStateService.setCurrentPalette(null);
    await Palette.boxOf().clear();
    await PaletteColor.boxOf().clear();
    await Harmony.boxOf().clear();
    await ColorTransform.boxOf().clear();
  }

  Future<void> _showExtractDialog() async {
    showImagePickerDialog(context);
  }

  void _onMenuSelect(String value) {
    if (value == menuClearPalettes) {
      _clearPalettes();
    } else if (value == menuClearAll) {
      _clearAll();
    }
  }

  Future<void> _selectPalette(Palette p) async {
    await _appStateService.setCurrentPalette(p);
    Navigator.pushNamed(context, PalettePage.routeName);
  }

  bool _isPaletteSelected(Palette p) {
    return (_appState.currentPalette != null && _appState.currentPalette.uuid == p.uuid);
  }

  @override
  void initState() {
    super.initState();
    StartPage.mounted = true;
  }

  @override
  Widget build(BuildContext context) {   
    return FbfStreamBuilder<KlrConfig, AppState>(
      stream: _appStateService.appStateStream,
      initialData: _appStateService.snapshot,
      builder: (context, config, snapshot) 
        => FbfScaffold<KlrConfig,StartPageData>(
              context: context,
              pageData: StartPageData(
                fabMenuConfig: FabMenuConfig(
                  fabIcon: Icons.arrow_upward,
                  menuItems: _menuItems,
                  onSelect: _onMenuSelect,
                  title: t.start_fabMenu_title,
                  titleIcon: Icons.dashboard
                ),
                appState: snapshot
              ),
              builder: (context, klr, pageData) => CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: FbfTile.heading<KlrConfig>(
                      icon: LineAwesomeIcons.palette,
                      title: t.start_palettes_title,
                      subtitle: t.start_palettes_subtitle
                    )
                  ),
                  listToGrid<KlrConfig>(
                    snapshot.palettes.map((p) => FbfTile.choice(
                      icon: Icons.palette_outlined,
                      title: p.name,
                      subtitle: t.start_palettes_item(p.colors.length),
                      onTap: () {
                        _selectPalette(p);
                      },
                      selected: _isPaletteSelected(p)  
                    )).toList()
                  ),
                  sliverSpacer<KlrConfig>(),
                  SliverToBoxAdapter(
                    child: FbfTile.heading(
                      title: t.start_createPalette_title,
                      subtitle: t.start_createPalette_subtitle,
                      icon: LineAwesomeIcons.plus_circle
                    ),
                  ),
                  listToGrid<KlrConfig>([                                
                    FbfTile.action<KlrConfig>(
                      icon:LineAwesomeIcons.palette,
                      title: t.start_createPalette_tpl_title,
                      subtitle: t.start_createPalette_tpl_subtitle,
                      onTap: () => _createPalette(),
                    ),
                    FbfTile.action<KlrConfig>(
                      icon: LineAwesomeIcons.image_1,
                      title: t.start_createPalette_img_title,
                      subtitle: t.start_createPalette_img_subtitle,
                      onTap: () => _showExtractDialog(),
                    )
                  ])
                ],
              )
        )
      
    );
  }
}



import 'package:flutter/material.dart';
import 'package:klr/app/klr.dart';
import 'package:klr/models/app-state.dart';

import 'package:klr/models/app-state/models/app-state.dart';
import 'package:klr/services/app-state-service.dart';

import 'package:klr/views/base/page-arguments.dart';
import 'package:klr/views/palette-page.dart';
import 'package:klr/widgets/bottom-navigation.dart';
import 'package:klr/widgets/bottom-sheet-menu.dart';
import 'package:klr/widgets/btn.dart';
import 'package:klr/widgets/dialogs/image-picker-dialog.dart';
import 'package:klr/widgets/tile.dart';
import 'package:klr/widgets/txt.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'base/_page-base.dart';
import 'splash-page.dart';

class StartPage extends PageBase<StartPageConfig> {
  static Color pageAccent = Klr.colors.pink95;
  static Color onPageAccent = Klr.colors.grey05; 
  static const String routeName = '/start';
  static const String title = 'dashboard';

  static bool mounted = false;

  static BottomNavigationPage makeNavigationPage(AppState state)
    => BottomNavigationPage(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
      routeName: routeName,
      disabled: false
    );

  StartPage() : super(routeName);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  AppStateService _appStateService = AppStateService.getInstance();
  AppState get _appState => _appStateService.snapshot;

  static const String menuClearPalettes = "clear-all-palettes";
  static const String menuClearAll      = "clear-everything";
  static const String menuCancel        = "cancel";

  List<BottomSheetMenuItem<String>> get _menuItems => [
    BottomSheetMenuItem<String>(
      icon: Icon(LineAwesomeIcons.alternate_trash, color: colorRemove()),
      title: "Clear",
      subtitle: "Clear all palettes",
      value: menuClearPalettes
    ),
    BottomSheetMenuItem<String>(
      icon: Icon(LineAwesomeIcons.alternate_trash, color: colorRemove()),
      title: "Clear everything",
      subtitle: "Clear all saved data",
      value: menuClearAll
    ),
    BottomSheetMenuItem<String>(
      icon: Icon(Icons.cancel_outlined, color: colorChoice()),
      title: "Cancel",
      subtitle: "Close this menu",
      value: menuCancel
    )
  ];

  Future<void> _createPalette() async {
      final p = await _appStateService.createBuiltinPalette();
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
    Navigator.pop(context);
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
    final args = PageArguments.of<StartPageArguments>(context);
    
    return StreamBuilder<AppState>(
      stream: _appStateService.appStateStream,
      initialData: _appStateService.snapshot,
      builder: (context, snapshot) => scaffold<StartPageConfig,StartPageArguments>(
        context: context,
        config: StartPageConfig(
          appStateSnapshot: snapshot.data,
          fabMenuItems: _menuItems,
          fabOnSelect: _onMenuSelect,
        ),
        builder: (context, data, _) => Column(
            children: [
              Expanded(
                flex: 11,
                child: ListView(
                  children: <Widget>[
                    titleTile(
                      icon: LineAwesomeIcons.palette,
                      title: 'Palettes',
                      subtitle: 'Your saved color schemes'
                    ),
                    ...snapshot.data.palettes.map(
                        (p) => choiceTile(
                          icon: Icons.palette_outlined,
                          title: p.name,
                          subtitle: "${p.colors.length} colors",
                          onTap: () {
                            _selectPalette(p);
                          },
                          selected: _isPaletteSelected(p)  
                        )).toList(),
                    Divider(),
                    titleTile(
                      title: 'Create',
                      icon: LineAwesomeIcons.plus_circle
                    ),
                    actionTile(
                      icon:LineAwesomeIcons.palette,
                      title: "Create from template",
                      subtitle: "Create an example palette",
                      onTap: () => _createPalette(),
                    ),
                    actionTile(
                      icon: LineAwesomeIcons.image_1,
                      title: 'Create from image',
                      subtitle: 'Extract palette from an image file',
                      onTap: () => _showExtractDialog(),
                    )
                  ],
                )
              )
            ],
          )
        )
    );
  }
}

class StartPageArguments extends PageArguments {}

class StartPageConfig extends DefaultPageConfig<StartPageArguments> {
  StartPageConfig({
    AppState appStateSnapshot,
    List<BottomSheetMenuItem<String>> fabMenuItems,
    void Function(String) fabOnSelect,
  }) : super(
    appStateSnapshot: appStateSnapshot,
    fabMenuItems: fabMenuItems,
    fabOnSelect: fabOnSelect,
    fabBackgroundColor: StartPage.pageAccent,
    fabIconColor: StartPage.onPageAccent,
    fabTitle: 'Dashboard actions',
    fabTitleIcon: Icons.dashboard,
    pageTitle: StartPage.title
  );
}


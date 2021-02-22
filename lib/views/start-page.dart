import 'package:flutter/material.dart';
import 'package:klr/app/klr.dart';
import 'package:klr/models/app-state.dart';

import 'package:klr/models/app-state/models/app-state.dart';
import 'package:klr/services/app-state-service.dart';

import 'package:klr/views/base/page-arguments.dart';
import 'package:klr/views/palette-page.dart';
import 'package:klr/widgets/bottom-navigation.dart';
import 'package:klr/widgets/bottom-sheet-menu.dart';
import 'package:klr/widgets/dialogs/image-picker-dialog.dart';
import 'package:klr/widgets/txt.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'base/_page-base.dart';

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
      icon: Icon(LineAwesomeIcons.alternate_trash, color: Klr.theme.primaryAccent),
      title: "Clear",
      subtitle: "Clear all palettes",
      value: menuClearPalettes
    ),
    BottomSheetMenuItem<String>(
      icon: Icon(LineAwesomeIcons.alternate_trash, color: Klr.theme.primaryAccent),
      title: "Clear everything",
      subtitle: "Clear all saved data",
      value: menuClearAll
    ),
    BottomSheetMenuItem<String>(
      icon: Icon(Icons.cancel_outlined, color: Klr.theme.secondaryAccent),
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
                flex: 1,
                child: Txt.title(StartPage.title)
              ),
              Expanded(
                flex: 11,
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(LineAwesomeIcons.paint_brush),
                      title: Txt.subtitle1('Palettes'),
                      subtitle: Text('Your saved palettes')
                    ),
                    ...snapshot.data.palettes.map((p) => ListTile(
                      leading: Icon(Icons.palette_outlined),
                      title: Text(p.name),
                      subtitle: Text("${p.colors.length} colors"),
                      trailing: Icon(Icons.edit),
                      onTap: () {
                        _selectPalette(p);
                      },
                      tileColor: _isPaletteSelected(p)  
                        ? Klr.theme.tertiaryAccent
                        : Klr.theme.cardBackground,
                    )).toList(),
                    Divider(),
                    ListTile(
                      leading: Icon(LineAwesomeIcons.plus_square),
                      title: Txt.subtitle2('Create new...'),
                      subtitle: Text('')
                    ),
                    ListTile(
                      leading: Icon(
                        LineAwesomeIcons.palette,
                        color: Klr.theme.primaryAccent
                      ),
                      title: Text("Create from template"),
                      subtitle: Text("Create an example palette"),
                      onTap: () {
                        _createPalette();
                      },
                      tileColor: Klr.theme.cardBackground,
                    ),
                    ListTile(
                      leading: Icon(LineAwesomeIcons.image_1,
                        color: Klr.theme.secondaryAccent),
                      title: Text('Create from image'),
                      subtitle: Text('Extract palette from image file'),
                      onTap: () {
                        _showExtractDialog();
                      },
                      tileColor: Klr.theme.cardBackground,
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


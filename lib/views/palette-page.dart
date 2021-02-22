import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:klr/klr.dart';
import 'package:klr/helpers/color.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/services/app-state-service.dart';
import 'package:klr/views/views.dart';
import 'package:klr/widgets/bottom-navigation.dart';
import 'package:klr/widgets/bottom-sheet-menu.dart';
import 'package:klr/widgets/dialogs/palette-color-dialog.dart';
import 'package:klr/widgets/palette-color-widget.dart';
import 'package:klr/widgets/togglable-text-editor.dart';
import 'package:klr/widgets/txt.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class PalettePage extends PageBase<PalettePageConfig> {
  static Color pageAccent = Klr.colors.orange99;
  static Color onPageAccent = Klr.colors.grey05; 

  static const String routeName = '/palette';
  static const String title = 'palette';

  static BottomNavigationPage makeNavigationPage(AppState state)
    => BottomNavigationPage(
      icon: Icons.palette_outlined,
      activeIcon: Icons.palette,
      label: 'Palette',
      routeName: routeName,
      disabled: state.currentPalette == null
    );

  PalettePage() : super(routeName);

  @override
  _PalettePageState createState() => _PalettePageState();
}

class _PalettePageState extends State<PalettePage> {
  AppStateService _appStateService = AppStateService.getInstance();
  Palette get _currPalette => _appStateService.snapshot.currentPalette;
 
  List<BottomSheetMenuItem<String>> get _menuItems => [
    BottomSheetMenuItem<String>(
      icon: Icon(Icons.add_box_outlined, color: Klr.theme.tertiaryAccent),
      title: "New color",
      subtitle: "Create a new color in this palette",
      value: "Create"
    ),
    BottomSheetMenuItem<String>(
      icon: Icon(Icons.delete_forever, color: Klr.colors.red70),
      title: "Delete palette",
      subtitle: "Remove this palette",
      value: "Delete"
    ),
    BottomSheetMenuItem<String>(
      icon: Icon(Icons.cancel_outlined, color: Klr.theme.secondaryAccent),
      title: "Cancel",
      subtitle: "Close this menu",
      value: "Cancel"
    )
  ];

  Future<void> _createColor() async {
    final color = await _appStateService.createColor();
    _currPalette.colors.add(color);
    await _currPalette.save();
  }
  Future<void> _deletePalette() async {
    await _currPalette.delete();
    Navigator.pushNamed(context, StartPage.routeName);
  }

  Future<void> _selectHarmony(PaletteColor c, Harmony h) async {
    c.harmony = (h == null) ? null : h.uuid;
    c.transformations.clear();
    if (h != null) {
      c.transformations.addAll(h.transformations.toList());
    }
    await c.save();
  }

  void _onMenuSelect(String value) {
    if (value == "Create") {
      _createColor();
    } else if (value == "Delete") {
      _deletePalette();
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = PageArguments.of<PalettePageArguments>(context);

    return StreamBuilder<AppState>(
      stream: _appStateService.appStateStream,
      initialData: _appStateService.snapshot,
      builder: (context, snapshot) => scaffold<PalettePageConfig,PalettePageArguments>(
        context: context,
        config: PalettePageConfig(
          appStateSnapshot: snapshot.data,
          fabMenuItems: _menuItems,
          fabOnSelect: _onMenuSelect
        ),
        builder: (context, data, _) => _currPalette == null ? null : Column(
          children: [
            Expanded(
              flex: 1,
              child: TogglableTextEditor(
                initalText: _currPalette.name,
                onChanged: (v) {
                  _currPalette.name = v;
                  _currPalette.save();
                },
              )
            ),
            Expanded(
              flex: 10,
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(5),
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                children: <Widget>[                   
                  ..._currPalette.colors.map(
                    (c) => PaletteColorWidget(
                      paletteColor: c,
                      onPressed: () {
                        showPaletteColorDialog(context, c);
                      },
                      size: viewportSize.width / 10
                    )
                  ).toList()
                ]
              )
            )
          ],
        )
      )
    );
  }
}

class PalettePageArguments extends PageArguments {}
class PalettePageConfig extends DefaultPageConfig<PalettePageArguments> 
{
  PalettePageConfig({
    AppState appStateSnapshot,
    List<BottomSheetMenuItem<String>> fabMenuItems,
    void Function(String) fabOnSelect,
  }) : super(
    appStateSnapshot: appStateSnapshot,
    fabMenuItems: fabMenuItems,
    fabOnSelect: fabOnSelect,
    fabBackgroundColor: PalettePage.pageAccent,
    fabIconColor: PalettePage.onPageAccent,
    fabTitle: 'Palette actions',
    fabTitleIcon: Icons.palette,
    pageTitle: PalettePage.title
  );
}



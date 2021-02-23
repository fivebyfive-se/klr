import 'package:flutter/material.dart';
import 'package:klr/klr.dart';
import 'package:klr/helpers/color.dart';
import 'package:klr/helpers/iterable.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/services/app-state-service.dart';
import 'package:klr/views/views.dart';
import 'package:klr/widgets/bottom-navigation.dart';
import 'package:klr/widgets/bottom-sheet-menu.dart';
import 'package:klr/widgets/btn.dart';
import 'package:klr/widgets/dialogs/css-dialog.dart';
import 'package:klr/widgets/layout.dart';
import 'package:klr/widgets/palette-color-editor.dart';
import 'package:klr/widgets/palette-color-widget.dart';
import 'package:klr/widgets/tile.dart';
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
  PaletteColor _selectedColor;

  bool _showGenerated = true;
  static const String menuCreateColor = "create";
  static const String menuDeletePalette = "delete";
  static const String menuCancel = "cancel";
 
  List<BottomSheetMenuItem<String>> get _menuItems => [
    BottomSheetMenuItem<String>(
      icon: Icon(Icons.add_box_outlined, color: colorAction()),
      title: "New color",
      subtitle: "Create a new color in this palette",
      value: menuCreateColor
    ),
    BottomSheetMenuItem<String>(
      icon: Icon(Icons.cancel_outlined, color: colorChoice()),
      title: "Cancel",
      subtitle: "Close this menu",
      value: menuCancel
    )
  ];


  Future<void> _promoteColor(HSLColor color) async {
    _appStateService.beginTransaction();
    final newPaletteColor = await PaletteColor.scaffoldAndSave(
      name: color.toHex(),
      fromColor: color.toColor()
    );
    newPaletteColor.displayIndex = _currPalette.colors.map((c) => c.displayIndex).max() + 1;
    _currPalette.colors.add(newPaletteColor);
    await _currPalette.save();
    _appStateService.endTransaction();
  }

  Future<void> _createColor() async {
    final color = await _appStateService.createColor();

    _currPalette.colors.add(color);
    await color.save();
    await _currPalette.save();
  }

  Future<void> _deletePalette() async {
    await _currPalette.delete();
    Navigator.pushNamed(context, StartPage.routeName);
  }

  void _onMenuSelect(String value) {
    if (value == menuCreateColor) {
      _createColor();
    } else if (value == menuDeletePalette) {
      _deletePalette();
    }
  }

  Widget _colorBox({
    Color color,
    Function() onPressed,
    bool chosen = false,
    Color mark
  }) {
    final textColor = color.computeLuminance() <= 0.45 
      ? Klr.theme.foreground
      : Klr.theme.background;
    final chosenBorder = BorderSide(
        width: 4.0, 
        color: Klr.theme.cardForeground
      );
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: chosen ? BorderDirectional(
            bottom: chosenBorder,
            top: chosenBorder
          ) : null,
          boxShadow: mark != null ? [
            BoxShadow(color: mark.withAlpha(0x80), blurRadius: 1.0, spreadRadius: 5.0)
          ] : []
        ),
        child: btn(
          color.toHex(includeHash: true),
          backgroundColor: color,
          onPressed: onPressed,
          style: Klr.textTheme.bodyText1.copyWith(color: textColor)
        )
    );
  }

  @override
  Widget build(BuildContext context) {
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
        builder: (context, data, _) 
          => _currPalette == null
            ? null 
            : CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: ListTile(
                    leading: Icon(LineAwesomeIcons.palette),
                    title: TogglableTextEditor(
                      initalText: _currPalette.name,
                      onChanged: (v) {
                        _currPalette.name = v;
                        _currPalette.save();
                      },
                    )
                  )
                ),

              // sliverSpacer(),

              listToGrid(
                  <Widget>[                   
                  ..._currPalette
                      .sortedColors
                      .map(
                        (c) => _colorBox(
                          color: c.color.toColor(), 
                          onPressed: () => setState(() => _selectedColor = c),
                          chosen: _selectedColor?.uuid == c.uuid,
                          mark: _showGenerated && c.transformations.isNotEmpty 
                            ? c.color.toColor() : null
                        )).toList(),
                ],
                crossAxisCount: 7,
                mainAxisExtent: null,
                crossAxisSpacing: defaultPaddingLength() / 4
              ),
              ...(_showGenerated 
                ? _currPalette.transformedColors.entries.map(
                    (entry) {
                      final pc = _currPalette.colors
                        .firstWhere((c) => c.uuid == entry.key);
                      return listToGrid(
                        entry.value.map((col) => _colorBox(
                          color: col.toColor(),
                          onPressed: () => _promoteColor(col),
                          mark: pc.color.toColor(),
                        )).toList(),
                        crossAxisCount: 7,
                        mainAxisExtent: 64.0,
                        crossAxisSpacing: defaultPaddingLength() / 4
                      );
                    }).toList()
                : []),
              
              sliverSpacer(),

              SliverToBoxAdapter(
                child: Container(
                  alignment: Alignment.center,
                  child: btnIcon(
                    'New',
                    icon: LineAwesomeIcons.plus,
                    backgroundColor: colorAction(darker: true),
                    onPressed: () => _createColor()
                  )
                )
              ),

              sliverSpacer(),

              listToList([
                PaletteColorEditor(
                  paletteColor: _selectedColor,
                  onDelete: () => setState(() => _selectedColor = null),
                )
              ]),

              sliverSpacer(size: 128.0),

              listToGrid(<Widget>[
                checkboxTile(
                  value: _showGenerated,
                  onChange: (v) => setState(() => _showGenerated = v),
                  title: 'Show generated colors',
                  subtitle: '(automatic shades/harmonies)'
                ),
                actionTile(
                  icon: LineAwesomeIcons.css_3_logo,
                  title: 'Show CSS',
                  subtitle: 'Generate and view CSS for this palette',
                  onTap: () => showCssDialog(context, _currPalette),
                )
              ]),

              sliverSpacer(),

              listToList(<Widget>[
                titleTile(
                  icon: LineAwesomeIcons.info,
                  title: 'Help'
                ),
                infoTile(
                  icon: LineAwesomeIcons.paint_roller,
                  title: 'Colors',
                  subtitle: 'To edit a color, click on it in the grid above'
                    'Any smaller boxes are *generated colors*, which are not'
                    'editable by default, but can be made so by tapping them'
                    
                )
              ]),

              sliverSpacer()
            
              
        ]))  
    );
  }
}

enum PalettePageMenuAction {
  cancel,
  createColor,
  deletePalette
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



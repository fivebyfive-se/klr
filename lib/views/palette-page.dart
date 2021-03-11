import 'package:flutter/material.dart';
import 'package:klr/views/page-data/splash-page-data.dart';
import 'package:klr/widgets/dialogs/stats-dialog.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/app/klr.dart';
import 'package:klr/app/klr/colors.dart';

import 'package:klr/models/app-state.dart';
import 'package:klr/services/app-state-service.dart';
import 'package:klr/views/views.dart';

import 'package:klr/widgets/togglable-text-editor.dart';
import 'package:klr/widgets/dialogs/css-dialog.dart';
import 'package:klr/widgets/palette-color-editor.dart';

import 'page-data/palette-page-data.dart';

class PalettePage extends FbfPage<PalettePageData> {
  static Color pageAccent = KlrColors.getInstance().orange99;
  static Color onPageAccent = KlrColors.getInstance().grey05; 

  static const String routeName = '/palette';
  static const String title = 'palette';

  PalettePage() : super();

  @override
  _PalettePageState createState() => _PalettePageState();
}

class _PalettePageState extends State<PalettePage> with KlrConfigMixin {
  AppStateService _appStateService = AppStateService.getInstance();
  Palette get _currPalette => _appStateService.snapshot.currentPalette;
  PaletteColor _selectedColor;

  bool _showGenerated = true;
  static const String menuCreateColor = "create";
  static const String menuDeletePalette = "delete";
  static const String menuCancel = "cancel";
 
  List<FbfFabMenuItem<String>> get _menuItems => [
    FbfFabMenuItem<String>(
      icon: Icon(Icons.add_box_outlined, color: klr.theme.primary),
      title: "New color",
      subtitle: "Create a new color in this palette",
      value: menuCreateColor
    ),
    FbfFabMenuItem<String>(
      icon: Icon(Icons.cancel_outlined, color: klr.theme.secondary),
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
      ? klr.theme.foreground
      : klr.theme.background;
    return Container(
      padding: klr.edge.all(1),
        decoration: BoxDecoration(
          border: chosen ? klr.border.y(2, klr.theme.cardForeground) : null,
          boxShadow: mark != null ? [
            BoxShadow(color: mark.withAlpha(0x80), 
              blurRadius: klr.borderWidth(1),
              spreadRadius: klr.borderWidth(2)
            )
          ] : []
        ),
        child: FbfBtn(
          color.toHex(includeHash: true),
          backgroundColor: color,
          onPressed: onPressed,
          style: klr.textTheme.bodyText1.copyWith(color: textColor),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return FbfStreamBuilder<KlrConfig, AppState>(
      stream: _appStateService.appStateStream,
      initialData: _appStateService.snapshot,
      builder: (context, config, snapshot)
        => FbfScaffold<KlrConfig,PalettePageData>(
            context: context,
            pageData: PalettePageData(
              appState: snapshot,
              fabMenuConfig: FabMenuConfig<String>(
                fabIcon: Icons.arrow_upward,
                menuItems: _menuItems,
                onSelect: _onMenuSelect,
                title: 'Actions',
                titleIcon: Icons.palette
              )
            ),
            builder: (context, klr, pageData) 
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
                    mainAxisExtent: klr.size(14),
                    crossAxisSpacing: klr.borderWidth()
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
                            mainAxisExtent: klr.size(7),
                            crossAxisSpacing: klr.borderWidth()
                          );
                        }).toList()
                    : []),
                  
                  sliverSpacer(),

                  SliverToBoxAdapter(
                    child: Container(
                      alignment: Alignment.center,
                      child: FbfBtn.icon(
                        'New',
                        icon: LineAwesomeIcons.plus,
                        backgroundColor: klr.theme.secondary,
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

                  sliverSpacer(size: klr.size(8)),

                  listToGrid(<Widget>[
                    FbfTile.checkbox(
                      value: _showGenerated,
                      onChange: (v) => setState(() => _showGenerated = v),
                      title: 'Show generated colors',
                      subtitle: '(automatic shades/harmonies)'
                    ),
                    FbfTile.action(
                      icon: LineAwesomeIcons.css_3_logo,
                      title: 'Show CSS',
                      subtitle: 'Generate and view CSS for this palette',
                      onTap: () => showCssDialog(context, _currPalette),
                    ),
                    FbfTile.action(
                      icon: LineAwesomeIcons.line_chart,
                      title: 'Show stats',
                      subtitle: 'Show statistics about this palette',
                      onTap: () => showStatsDialog(context, _currPalette),
                    )
                  ]),

                  sliverSpacer(),

                  listToList(<Widget>[
                    FbfTile.heading(
                      icon: LineAwesomeIcons.info,
                      title: 'Help'
                    ),
                    FbfTile.info(
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


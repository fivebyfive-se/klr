import 'package:flutter/material.dart';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:klr/widgets/contrast-table.dart';
import 'package:klr/widgets/css-table.dart';
import 'package:klr/widgets/stats-table.dart';


import 'package:klr/widgets/color-editor.dart';
import 'package:klr/widgets/selectable.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/app/klr.dart';
import 'package:klr/app/klr/colors.dart';

import 'package:klr/models/app-state.dart';
import 'package:klr/models/hsluv.dart';
import 'package:klr/services/app-state-service.dart';

import 'package:klr/widgets/togglable-text-editor.dart';

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

  bool _contrastActive = false;
  ColorItem  _contrastBackground;

  List<ColorItem> get _colors => _currPalette.sortedColors
    .map((c) => ColorItem(id: c.uuid, name: c.name, color: c.color)).toList();

  List<ColorItem> get _derived => _currPalette.transformedColors.entries
    .mapReduce<MapEntry<String,List<HSLuvColor>>,List<ColorItem>>(
      (prev, entry, _) => [
        ...prev,
        ...entry.value.map(
          (c) => ColorItem(
            parentId: entry.key,
            color: c
          )
        ).toList()],
        <ColorItem>[]
    ).toList();

  String _activeColor;

  PaletteColor _colorById(String id)
    => _currPalette?.colors?.firstWhere(
        (c) => c.uuid == id,
        orElse: null
      );

  Future<void> _promoteSelected(List<ColorItem> selected) async {
    final derived = selected.where((c) => c.isDerived).toList();
    _appStateService.beginTransaction();
    for (final ci in derived) {
      final newPaletteColor = await PaletteColor.scaffoldAndSave(
        fromColor: ci.color,
        name: ci.color.toHex()
      );
      _currPalette.colors.add(newPaletteColor);
    }
    await _currPalette.save();
    _appStateService.endTransaction();
  }

  Future<void> _createColor() async {
    final color = await _appStateService.createColor();

    _currPalette.colors.add(color);
    await color.save();
    await _currPalette.save();
    await _appStateService.setCurrentColor(color);
  }

  Future<void> _deleteSelected(List<ColorItem> selected) async {
    final colors = selected.where((ci) => !ci.isDerived).toList();
    for (final col in colors) {
      final palCol = _colorById(col.id);
      if (palCol != null) {
        _currPalette.colors.remove(palCol);
        await palCol.delete();
      }
    }
    await _currPalette.save();
  }

  Widget _colorTile(ColorItem pc, bool selected, bool showDetails) {
    final isActive = !pc.isDerived && pc.id == _activeColor;
    final color = pc.color.toColor();
    final invColor = pc.color.invertLightness().withSaturation(0).toColor();
    final titleStyle = klr.textTheme.subtitle1.withColor(invColor);
    final subtitleStyle = klr.textTheme.subtitle2.withColor(invColor);
    final derivedFrom = pc.isDerived ? _colorById(pc.parentId) : null;

    return Padding(
      padding: pc.isDerived 
        ? klr.edge.all(3) 
        : EdgeInsets.zero,
      child: Container(
        height: klr.tileHeightx2 * 3,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          border: isActive ? BorderDirectional(
            bottom: BorderSide(color: klr.theme.foreground, width: 2.0),
            top: BorderSide(color: klr.theme.foreground, width: 2.0),
          ) : null,
          boxShadow: pc.isDerived ? [BoxShadow(
            color: derivedFrom.color.toColor(),
            spreadRadius: klr.size(0.5),
          )] : <BoxShadow>[]
        ),
        child: ListTile(
          tileColor: color,
          title: Text(pc.label, style: titleStyle),
          subtitle: showDetails 
            ? Text(pc.color.toHex(), style: subtitleStyle)
            : null,
        )
      )
    );
  }

  void _tapColor(ColorItem ci) {
    if (!ci.isDerived) {
      _showColorEditor(ci);
    }
  }

  void _showColorEditor(ColorItem ci) {
    final paletteColor = _colorById(ci.id);
    final size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.hardEdge,
        content: ColorEditor(
          color: paletteColor,
          height: size.height * 0.9,
          width: size.width,
        )
      )
    );
  }

  @override
  void initState() {
    super.initState();
    _contrastBackground = _colors.first;
  }

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.of(context).size;

    return FbfStreamBuilder<KlrConfig, AppState>(
      stream: _appStateService.appStateStream,
      initialData: _appStateService.snapshot,
      builder: (context, config, snapshot)
        => FbfScaffold<KlrConfig,PalettePageData>(
            context: context,
            pageData: PalettePageData(
              appState: snapshot,
              pageTitle: t.palette_title
            ),
            builder: (context, klr, pageData) 
              => _currPalette == null
                ? null 
                : CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Container(
                        height: klr.tileHeight,
                        child: ListTile(
                          leading: Icon(LineAwesomeIcons.palette),
                          title: TogglableTextEditor(
                            initalText: _currPalette.name,
                            onChanged: (v) {
                              _currPalette.name = v;
                              _currPalette.save();
                            },
                            style: klr.textTheme.subtitle1,
                          )
                        )
                      )
                    ),
                    SelectableList<ColorItem>(
                      compact: true,
                      crossAxisCount: 6,
                      height: viewport.height - klr.tileHeight,
                      items: [..._colors, ..._derived],
                      widgetBuilder: _colorTile,
                      onPressed: (pc) => _tapColor(pc),
                      actions: [
                        ListItemAction(
                          icon: Icon(LineAwesomeIcons.plus_circle),
                          onPressed: (_) => _createColor()
                        )
                      ],
                      selectedActions: [
                        ListItemAction(
                          icon: Icon(LineAwesomeIcons.trash),
                          onPressed: (selected) => _deleteSelected(selected)
                        ),
                        ListItemAction(
                          icon: Icon(LineAwesomeIcons.alternate_level_up),
                          onPressed: (selected) => _promoteSelected(selected)
                        )
                      ],
                    ),

                  sliverSpacer(size: klr.tileHeight),

                  ContrastTable(colors: [..._colors, ..._derived]),

                  StatsTable(palette: _currPalette),

                  CssTable(palette: _currPalette),

                  sliverSpacer(),
        ]))  
    );
  }
}

class ColorItem {
  const ColorItem({this.id, this.name, this.parentId, this.color});

  final String id;
  final String name;
  final String parentId;
  final HSLuvColor color;

  String get label => name ?? color.toHex();
  bool get isDerived => parentId != null;
}

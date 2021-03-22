import 'package:flutter/material.dart';
import 'package:klr/services/color-name-service.dart';
import 'package:klr/widgets/expanding-table.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:fbf/fbf.dart';
import 'package:fbf/hsluv.dart';

import 'package:klr/klr.dart';
import 'package:klr/app/klr/colors.dart';

import 'package:klr/models/app-state.dart';
import 'package:klr/services/app-state-service.dart';

import 'package:klr/widgets/contrast-table.dart';
import 'package:klr/widgets/css-table.dart';
import 'package:klr/widgets/stats-table.dart';

import 'package:klr/widgets/color-editor.dart';
import 'package:klr/widgets/selectable.dart';
import 'package:klr/widgets/togglable-text-editor.dart';
import 'package:klr/widgets/page/page-title.dart';

import 'page-data/palette-page-data.dart';

class PalettePage extends FbfPage<PalettePageData> {
  static Color pageAccent = KlrColors.getInstance().orange99;
  static Color onPageAccent = KlrColors.getInstance().grey05; 

  static const String routeName = '/palette';

  PalettePage() : super();

  @override
  _PalettePageState createState() => _PalettePageState();
}

class _PalettePageState extends State<PalettePage> with KlrConfigMixin {
  AppStateService _appStateService = AppStateService.getInstance();
  ColorNameService _nameService = ColorNameService.getInstance();

  Palette get _currPalette => _appStateService.snapshot.currentPalette;

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

  Future<void> _setPaletteName(String name) async {
    _currPalette.name = name;
    await _currPalette.save();
  } 

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
        name: _nameService.guessName(ci.color.toColor())
      );
      _currPalette.colors.add(newPaletteColor);
    }
    await _currPalette.save();
    _appStateService.endTransaction();
  }

  Future<void> _removeHarmony(List<ColorItem> selected) async {
    final colors = selected.where((c) => !c.isDerived).toList();
    _appStateService.beginTransaction();

    for (final ci in colors) {
      final pc = _currPalette.colors.firstWhere(
        (c) => c.uuid == ci.id,
        orElse: () => null
      );
      if (pc != null) {
        pc.harmony = null;
        pc.transformations.clear();
        await pc.save();
      }
    }
    _appStateService.endTransaction();
  }

  Future<void> _createColor() async {
    final color = await _appStateService.createRandomColor();

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

  Future<void> _setColor(ColorItem ci) async {
    if (ci.id == null) {
      await _promoteSelected([ci]);
    } else {
      final color = _currPalette.colors.firstWhere(
        (c) => c.uuid == ci.id,
        orElse: () => null
      );
      if (color != null) {
        color.color = ci.color;
        color.name = _nameService.guessName(ci.color.toColor());
        await color.save();
      }
    }
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
        height: klr.tileHeightLG * 3,
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
    
    showMaterialModalBottomSheet(
      context: context,
      enableDrag: true,
      expand: true,
      backgroundColor: klr.theme.dialogBackground,
      builder: (context) => SizedBox.expand(
        child: SingleChildScrollView(
          child: ColorEditor(
            color: paletteColor,
            width: size.width,
            height: size.height
          )
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = KlrConfig.r(context);
    final liIcon = (IconData i, [Color col]) 
      => Icon(i, color: col ?? klr.theme.primaryAccent);

    return FbfStreamBuilder<KlrConfig, AppState>(
      stream: _appStateService.appStateStream,
      initialData: _appStateService.snapshot,
      builder: (context, config, snapshot)
        => FbfScaffold<KlrConfig,PalettePageData>(
            context: context,
            pageData: PalettePageData(
              appState: snapshot,
              pageTitle: t.palette_title,
              context: context,
            ),
            builder: (context, klr, pageData) 
              => _currPalette == null
                ? null 
                : CustomScrollView(
                  slivers: <Widget>[
                    PageTitle(
                      icon: Icon(Icons.palette_outlined),
                      title: TogglableTextEditor(
                        initalText: _currPalette.name,
                        onChanged: (n) => _setPaletteName(n),
                      ),
                      subtitle: Text(
                        t.palette_subtitle(_currPalette.colors.length)
                      ),
                    ),
                    SelectableList<ColorItem>(
                      compact: true,
                      crossAxisCount: r.lte<int>(
                        ViewportSize.sm,
                        () => 4,
                        () => 8
                      ),
                      height: r.height - klr.tileHeightSM,
                      items: [..._colors, ..._derived],
                      widgetBuilder: _colorTile,
                      onPressed: (pc) => _tapColor(pc),
                      rightActions: [
                        ListItemAction(
                          icon: liIcon(LineAwesomeIcons.plus_circle),
                          onPressed: (_) => _createColor(),
                          shouldShow: (_, selectionActive) => !selectionActive,
                          legend: Text('Add a color')
                        ),
                        ListItemAction(
                          icon: liIcon(LineAwesomeIcons.trash, klr.theme.tertiaryAccent),
                          onPressed: (selected) => _deleteSelected(selected),
                          shouldShow: (selected, selectionActive) 
                            => selectionActive && selected.any((i) => !i.isDerived),
                          legend: Text('Remove selected colors')
                        ),
                        ListItemAction(
                          icon: liIcon(LineAwesomeIcons.alternate_level_up),
                          onPressed: (selected) => _promoteSelected(selected),
                          shouldShow: (selected, selectionActive) 
                            => selectionActive && selected.any((i) => i.isDerived),
                          legend: Text('Promote selected generated colors')
                        ),
                        ListItemAction(
                          icon: liIcon(LineAwesomeIcons.alternate_level_down),
                          onPressed: (selected) => _removeHarmony(selected),
                          shouldShow: (selected, selectionActive) 
                            => selectionActive && selected.any(
                              (i) => !i.isDerived && _currPalette.colors
                                .any((c) => c.uuid == i.id && c.harmony != null)
                            ),
                          legend: Text('Remove harmonies from selected')
                        )
                      ],
                    ),

                  sliverSpacer(size: klr.tileHeightSM),

                  ContrastTable(
                    colors: [..._colors, ..._derived],
                    onChanged: (ci) => _setColor(ci),
                  ),

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

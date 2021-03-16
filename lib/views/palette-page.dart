import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:klr/models/hsluv/contrast.dart';
import 'package:klr/widgets/richer-text.dart';
import 'package:klr/widgets/text-with-icon.dart';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:klr/widgets/color-editor.dart';
import 'package:klr/widgets/dialogs/stats-dialog.dart';
import 'package:klr/widgets/editor-tile/list-selector-tile.dart';
import 'package:klr/widgets/selectable.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/app/klr.dart';
import 'package:klr/app/klr/colors.dart';

import 'package:klr/models/app-state.dart';
import 'package:klr/models/hsluv.dart';
import 'package:klr/services/app-state-service.dart';

import 'package:klr/widgets/togglable-text-editor.dart';
import 'package:klr/widgets/dialogs/css-dialog.dart';

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
  _ColorItem  _contrastBackground;

  List<_ColorItem> get _colors => _currPalette.sortedColors
    .map((c) => _ColorItem(id: c.uuid, name: c.name, color: c.color)).toList();

  List<_ColorItem> get _derived => _currPalette.transformedColors.entries
    .mapReduce<MapEntry<String,List<HSLuvColor>>,List<_ColorItem>>(
      (prev, entry, _) => [
        ...prev,
        ...entry.value.map(
          (c) => _ColorItem(
            parentId: entry.key,
            color: c
          )
        ).toList()],
        <_ColorItem>[]
    ).toList();

  String _activeColor;

  PaletteColor _colorById(String id)
    => _currPalette?.colors?.firstWhere(
        (c) => c.uuid == id,
        orElse: null
      );

  Future<void> _promoteSelected(List<_ColorItem> selected) async {
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

  Future<void> _deleteSelected(List<_ColorItem> selected) async {
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

  Widget _colorTile(_ColorItem pc, bool selected, bool showDetails) {
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
        height: 300,
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

  void _tapColor(_ColorItem ci) {
    if (!ci.isDerived) {
      _showColorEditor(ci);
    }
  }

  void _showColorEditor(_ColorItem ci) {
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
    final klr = KlrConfig.of(context);
    final viewport = MediaQuery.of(context).size;
    final contrastDuration = const Duration(milliseconds: 400);
    final tsLarge = klr.textTheme.subtitle1.copyWith(fontSize: 24);
    final tsNormal = klr.textTheme.bodyText2;


    return FbfStreamBuilder<KlrConfig, AppState>(
      stream: _appStateService.appStateStream,
      initialData: _appStateService.snapshot,
      builder: (context, config, snapshot)
        => FbfScaffold<KlrConfig,PalettePageData>(
            context: context,
            pageData: PalettePageData(
              appState: snapshot,
              pageTitle: 'Palette'
            ),
            builder: (context, klr, pageData) 
              => _currPalette == null
                ? null 
                : CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Container(
                        height: 64,
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
                    SelectableList<_ColorItem>(
                      compact: true,
                      crossAxisCount: 6,
                      height: viewport.height - 50,
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

                  sliverSpacer(size: klr.size(8)),

                  SliverStickyHeader(
                    header: Container(
                      height: 64,
                      width: viewport.width,
                      color: klr.theme.cardBackground,
                      child: Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              leading: Icon(
                                _contrastActive
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward
                              ),
                              title: Text('Contrast', style: klr.textTheme.subtitle1),
                              onTap: () => setState(() => _contrastActive = !_contrastActive),
                            ),
                          ),
                          Expanded(
                            child: AnimatedOpacity(
                              duration: contrastDuration,
                              opacity: _contrastActive ? 1.0 : 0.0,
                              child: ListSelectorTile<_ColorItem>(
                                itemWidgetBuilder: (ci) => TextWithIcon(
                                  icon: Icon(Icons.circle, color: ci.color.toColor()),
                                  text: Text(ci.label, style: klr.textTheme.subtitle1)
                                ),
                                items: [..._colors, ..._derived],
                                label: 'Background color',
                                onSelected: (v) => setState(() => _contrastBackground = v),
                                value: _contrastBackground,
                              ),
                            ),
                          )
                        ],
                      )
                    ),
                    sliver:
                     SliverList(
                        delegate: SliverChildListDelegate(
                          [...([..._colors, ..._derived]
                          .where((c) => c.color != _contrastBackground.color)
                          .map((c) {
                            final contrast = _contrastBackground.color
                              .contrastWith(c.color);
                            final isGood = contrast >= Contrast.W3C_CONTRAST_TEXT;
                            final isOK = contrast >= Contrast.W3C_CONTRAST_LARGE_TEXT;

                            return AnimatedContainer(
                              height: _contrastActive ? 100.0 : 0,
                              duration: contrastDuration,
                              width: viewport.width,
                              decoration: _contrastActive 
                                ? BoxDecoration(
                                  border: klr.border.only(
                                    bottom: 1.0,
                                    color: klr.theme.cardBackground
                                  )
                                )
                                : null,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                Expanded(
                                  child: Container(
                                    padding: klr.edge.all(2),
                                    color: klr.theme.dialogBackground,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            c.label,
                                            style: tsLarge
                                          )
                                        ),
                                        Expanded(
                                          child: Text(
                                            contrast.toStringAsFixed(1),
                                            style: tsLarge.withColor(
                                            isGood ? klr.theme.foreground
                                              : isOK ? klr.theme.warning
                                                : klr.theme.error
                                            )
                                          ),
                                        )
                                      ]
                                    ),
                                  )
                                ),
                                Expanded(
                                  child: Container(
                                    color: _contrastBackground.color.toColor(),
                                    padding: klr.edge.all(2),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Large text\n", 
                                            style: tsLarge.withColor(c.color.toColor())
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Smaller text", 
                                            style: tsNormal.withColor(c.color.toColor())
                                          ),
                                        ),
                                      ]
                                    ),
                                  ),
                                )
                              ]),
                            );
                          }).toList()),
                          AnimatedContainer(
                            duration: contrastDuration,
                            height: _contrastActive ? 100 : 0,
                            color: klr.theme.cardBackground,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Icon(Icons.info_outline),
                                ),
                                Expanded(
                                  flex: 11,
                                  child: Container(
                                    padding: klr.edge.xy(2, 1),
                                    child: RicherText.from([
                                        "WCAG requires a contrast of at least 4.5 "
                                        "between text and background.\n",
                                        "To compare colors along other axes, ",
                                        [
                                          "see them in a chart",
                                          () => showStatsDialog(context, _currPalette)
                                        ]
                                      ], 
                                      baseStyle: tsNormal
                                        .withColor(klr.theme.cardForeground)
                                    ),
                                  )
                                )
                              ]
                            )
                          )
                        ])
                    )
                  ),

                  sliverSpacer(size: klr.size(8)),

                  listToGrid(<Widget>[
                    FbfTile.action(
                      icon: LineAwesomeIcons.css_3_logo,
                      title: 'Show CSS',
                      subtitle: 'Generate and view CSS for this palette',
                      onTap: () => showCssDialog(context, _currPalette),
                    ),
                    FbfTile.action(
                      icon: LineAwesomeIcons.line_chart,
                      title: 'Show chart',
                      subtitle: 
                        'Check how your palette\'s colors relate to '
                        'each other and simulate color blindness'
                      ,
                      onTap: () => showStatsDialog(context, _currPalette),
                    )
                  ]),

                  sliverSpacer()
        ]))  
    );
  }
}

class _ColorItem {
  const _ColorItem({this.id, this.name, this.parentId, this.color});

  final String id;
  final String name;
  final String parentId;
  final HSLuvColor color;

  String get label => name ?? color.toHex();
  bool get isDerived => parentId != null;
}

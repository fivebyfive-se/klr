import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:fbf/fbf.dart';
import 'package:fbf/ryb.dart';
import 'package:fbf/hsluv.dart';

import 'package:klr/klr.dart';

import 'package:klr/models/app-state.dart';

import 'package:klr/services/app-state-service.dart';
import 'package:klr/services/color-name-service.dart';

import 'package:klr/widgets/color-picker/color-picker.dart';
import 'package:klr/widgets/editor-tile/popup-menu-tile.dart';
import 'package:klr/widgets/editor-tile/text-field-tile.dart';
import 'package:klr/widgets/editor-tile/custom-editor-tile.dart';
import 'package:klr/widgets/tabber.dart';

import 'color-picker/color-wheel.dart';

class ColorEditor extends StatefulWidget {
  const ColorEditor({
    Key key,
    @required this.color,
    this.width, this.height
  }): assert(color != null),
      super(key: key);

  final PaletteColor color;
  final double width;
  final double height;

  static void openModalEditor(
    BuildContext context,
    PaletteColor color,
    double width,
    double height
  )
    => showModalBottomSheet<void>(
      context: context, 
      builder: (context) => ColorEditor(
        color: color,
        width: width,
        height: height,
      )
    );

  @override
  _ColorEditorState createState() => _ColorEditorState();
}

class _ColorEditorState extends State<ColorEditor> {
  AppStateService get _appStateService => AppStateService.getInstance();
  ColorNameService get _nameService => ColorNameService.getInstance();

  PaletteColor get _paletteColor => widget.color;
  Color get _color => _paletteColor.color.toColor();
  Color get _invColor => _paletteColor.color.invertLightness().toColor();

  List<Harmony> get _harmonies => _appStateService.snapshot.harmonies
            .order<Harmony>((a, b) => a.name.compareTo(b.name))
            .toList();

  List<String> get _suggestedNames {
    return _nameService.suggestName(_color).distances
      .keys.where((n) => n != _paletteColor.name).toList();
  }

  Harmony _harmonyById(String id) 
    => _harmonies.firstWhere((h) => h.uuid == id);

  String _harmonyNameById(String id)
    => id == null || id == "" 
      ? 'None' 
      : _harmonyById(id).name;

  Future<void> _updateColor() async {
    await _paletteColor.save();
    if (this.mounted) {
      setState(() {});
    }
  }

  Future<void> _setName(String newName) async {
    _paletteColor.name = newName;
    await _updateColor();
  } 

  Future<void> _setHarmony(String uuid) async {
    _paletteColor.harmony = uuid;
    _paletteColor.transformations.clear();
    if (uuid != null && uuid != "") {
      final h = _harmonyById(uuid);
      _paletteColor.transformations.addAll(
        h.transformations.toList()
      );
    }
    await _updateColor();
  } 

  Future<void> _setColor(HSLuvColor color) async {
    _paletteColor.color = color;
    await _updateColor();
  }

  @override
  Widget build(BuildContext context) {
    final klr  = KlrConfig.of(context);
    final t = KlrConfig.t(context);
    final containerHeight = widget.height;
    
    final tileHeight = klr.tileHeightSM;
    final editorHeight = containerHeight - tileHeight * 6;
    final editorWidth = widget.width ?? MediaQuery.of(context).size.width;

    final btnStyle = ([Color bg, Color fg])
      => ButtonStyle(
        backgroundColor: MaterialStateProperty
          .all(bg ?? klr.theme.primaryBackground),
        foregroundColor: MaterialStateProperty
          .all(fg ?? klr.theme.onPrimary),
        minimumSize: MaterialStateProperty
          .all(Size(tileHeight * 3, tileHeight - klr.baseSize)),
        textStyle: MaterialStateProperty
          .all(klr.textTheme.subtitle1.withFontWeight(FontWeight.normal)) 
      );

    return Container(
      height: containerHeight,
      width: widget.width,
      decoration: BoxDecoration(
        color: klr.theme.dialogBackground,
        boxShadow: [
          BoxShadow(
            color: klr.theme.background,
            offset: Offset(0, -5),
            blurRadius: 5
          )
        ]
      ),
      child: CustomScrollView(
        slivers: [
          SliverStickyHeader(
            header: Container(
              height: tileHeight,
              color: _color,
              alignment: Alignment.centerLeft,
              child: ListTile(
                title: Text(
                  _paletteColor.name ?? _paletteColor.color.toHex(),
                  style: klr.textTheme.subtitle1.withColor(_invColor)
                ),
                trailing: IconButton(
                  icon: Icon(LineAwesomeIcons.window_close, color: _invColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  Container(
                    height: tileHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextFieldTile(
                            label: t.color_name,
                            value: _paletteColor.name ?? "",
                            onChanged: (v) => _setName(v),
                          ),
                        ),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, box) => ElevatedButton.icon(
                            style: btnStyle(
                              klr.theme.tertiaryBackground,
                              klr.theme.onTertiary
                            ),
                            onPressed: () async {
                              final selected = await showMenu(
                                context: context,
                                position: RelativeRect.fromLTRB(
                                  editorWidth / 2,
                                  0.0, 
                                  tileHeight,
                                  editorHeight + tileHeight * 2
                                ),
                                initialValue: _paletteColor.name ?? "",
                                
                                items: <PopupMenuEntry<String>>[
                                  PopupMenuItem(
                                    child: Text(_paletteColor.name ?? ""),
                                    value: _paletteColor.name ?? ""
                                  ),
                                  PopupMenuDivider(),
                                  ..._suggestedNames.map((n) => PopupMenuItem(
                                    child: Text(n),
                                    value: n,
                                  )).toList()
                                ]
                              );
                              if (selected != null) {
                                _setName(selected);
                              }
                            },
                            icon: Icon(Icons.auto_awesome),
                            label: Text(
                              t.color_suggestName,
                              style: klr.textTheme.subtitle1
                            )
                          )
                         )
                        )
                      ]
                    )
                  ),
                  Container(
                    height: tileHeight,
                    child: PopupMenuTile<String>(
                      value: _paletteColor.harmony ?? "",
                      itemNameBuilder: (id) => _harmonyNameById(id),
                      items: [
                        "",
                        ..._harmonies.map((h) => h.uuid).toList()
                      ],
                      onSelected: (id) => _setHarmony(id),
                      label: t.color_harmony,
                    ),
                  ),
                  Container(
                    height: tileHeight * 2,
                    child: CustomEditorTile(
                      childBuilder: (context, klr) => Wrap(
                        runSpacing: klr.size(0.5),
                        spacing: klr.size(0.5),
                        children: <Widget>[
                          ..._paletteColor.transformedColors.map(
                            (c) => Chip(
                              backgroundColor: c.toColor(),
                              label: Text(
                                c.toHex(),
                                style: klr.textTheme.caption.withColor(
                                  c.invertLightness().toColor()
                                )
                              )
                            )
                          ).toList()
                        ],
                      )
                    )
                  ),
                  Tabber(
                    height: editorHeight,
                    initialTab: 0,
                    tabs: [
                        TabberTab(
                          icon: Icons.replay_circle_filled,
                          label: t.color_edit_wheel,
                          contentBuilder: (_) => RYBWheelColorPicker(
                            color: _paletteColor.color,
                            onChanged: (c) => _setColor(c),
                            width: editorWidth,
                            height: editorHeight 
                          )
                        ),
                        TabberTab(
                          icon: Icons.color_lens,
                          label: t.color_channels_hsl,
                          contentBuilder: (_) => HSLColorEditor(
                            height: editorHeight,
                            width: editorWidth,
                            color: _paletteColor.color,
                            onChanged: (c) => _setColor(c),
                          )
                        ),

                        TabberTab(
                          icon: Icons.color_lens,
                          label: t.color_channels_rgb,
                          contentBuilder: (_) => RGBColorEditor(
                            height: editorHeight,
                            width: editorWidth,
                            color: _color,
                            onChanged: (c) {
                              _setColor(HSLuvColor.fromColor(c));
                            },
                          )
                        ),

                        TabberTab(
                          icon: Icons.color_lens,
                          label: t.colorWheel_mode_ryb,
                          contentBuilder: (_) => RYBColorEditor(
                            height: editorHeight,
                            width: editorWidth,
                            color: RYBColor.fromColor(_color),
                            onChanged: (c) {
                              _setColor(HSLuvColor.fromRYBColor(c));
                            },
                          ),
                        ),
                    ],
                  ),

                  Container(
                    height: tileHeight,
                    padding: klr.edge.all(1),
                    child: ListTile(
                      leading: TextButton.icon(
                        onPressed: () => print("delete"),
                        icon: Icon(LineAwesomeIcons.backspace),
                        label: Text(t.btn_delete)
                      ),
                      trailing: ElevatedButton(
                        style: btnStyle(),
                        onPressed: () => Navigator.pop(context),
                        child: Text(t.btn_close)
                      ),
                    ),
                  ),
                ]
              ),
            ),
          ),
          

                  
        ]
      ),
    );
  }
}

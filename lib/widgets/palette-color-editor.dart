import 'package:fbf/ryb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:klr/widgets/tabber.dart';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/klr.dart';

import 'package:klr/models/app-state.dart';
import 'package:klr/services/app-state-service.dart';

import 'togglable-text-editor.dart';
import 'txt.dart';

class PaletteColorEditor extends StatefulWidget {
  PaletteColorEditor({this.paletteColor, this.onDelete});

  final PaletteColor paletteColor;
  final Function() onDelete;

  @override
  _PaletteColorEditorState createState() => _PaletteColorEditorState();
}

class _PaletteColorEditorState extends State<PaletteColorEditor> with KlrConfigMixin {
  PaletteColor get _paletteColor => widget.paletteColor;
  Palette get _currentPalette => appStateService().snapshot.currentPalette;
  List<Harmony> get _harmonies => appStateService().snapshot.harmonies
            .order<Harmony>((a, b) => a.name.compareTo(b.name))
            .toList();

  Harmony _harmonyById(String id) 
    => _harmonies.firstWhere((h) => h.uuid == id);

  String _harmonyNameById(String id)
    => id == null || id == "" 
      ? 'None' 
      : _harmonyById(id).name;

  Future<void> _saveColor() async {
    await _paletteColor.save();
    setState(() {});
  }

  Future<void> _deleteColor() async {
    _currentPalette.colors.remove(_paletteColor);
    await _currentPalette.save();
    await _paletteColor.delete();
    widget.onDelete?.call();
    setState(() {});
  }

  void _setColor(Color col) {
    _paletteColor.color = col.toHSL();
    _saveColor();
  }

  void _selectHarmony(String uuid) {
    _paletteColor.harmony = uuid;
    _paletteColor.transformations.clear();
    if (uuid != null && uuid != "") {
      final h = _harmonyById(uuid);
      _paletteColor.transformations.addAll(
        h.transformations.toList()
      );
    }
    _saveColor();
  }

  @override
  Widget build(BuildContext context) {
    final vp = MediaQuery.of(context).size;

    return _paletteColor == null ? Container() : Container(
      height: 420.0,
      width: vp.width,
      color: klr.theme.cardBackground.deltaLightness(-5),
      margin: klr.edge.y(2),
      child: Column(
        children: <Widget>[
          Container(
            height: 40.0,
            padding: klr.edge.all(1),
            alignment: Alignment.center,
            child: Text('Edit color', style: klr.textTheme.subtitle2)
          ),
          Container(
            height: 60.0,
            width: vp.width,
            color: klr.theme.dialogBackground,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ListTile(
                    leading: Text('Name'),
                    title: TogglableTextEditor(
                      alignment: Alignment.centerLeft,
                      initalText: _paletteColor.name,
                      onChanged: (v) {
                        _paletteColor.name = v;
                        _saveColor();
                      },
                      style: TextStyle(
                        fontSize: klr.textTheme.bodyText1.fontSize,
                      )
                    )
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: ListTile(
                    leading: Text('Harmony'),
                    title: PopupMenuButton<String>(
                      initialValue: _paletteColor.harmony,
                      child: Txt.subtitle4(_harmonyNameById(_paletteColor.harmony)),
                      onSelected: _selectHarmony,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: "",
                          child: Text('None')
                        ),
                        PopupMenuDivider(),
                        ..._harmonies.map((h) => PopupMenuItem(
                          child: Text(h.name),
                          value: h.uuid
                        )).toList(),
                    ]),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ListTile(
                    leading: Icon(LineAwesomeIcons.backspace, color: klr.theme.tertiary),
                    title: Text('Remove color', style: TextStyle(color: klr.theme.tertiary)),
                    onTap: () => _deleteColor(),
                  ),
                )
              ],
            )
          ),
          Expanded(
            child: Tabber(
              initialTab: 0,
              tabs: [
                TabberTab(
                  icon: Icons.color_lens_outlined,
                  label: 'RYB',
                  contentBuilder: (_) => RYBColorPicker(
                    initialColor: _paletteColor.color.toColor(),
                    onChange: _setColor,
                  )
                ),
                TabberTab(
                  icon: Icons.color_lens,
                  label: 'HSL',
                  contentBuilder: (_) => ColorPicker(
                    pickerColor: _paletteColor.color.toColor(),
                    onColorChanged: _setColor,
                    enableAlpha: true,
                    displayThumbColor: false,
                    labelTextStyle: klr.textTheme.bodyText1,
                    showLabel: true,
                    paletteType: PaletteType.hsl,
                    pickerAreaBorderRadius: const BorderRadius.only(
                      topLeft:  const Radius.circular(4.0),
                      topRight: const Radius.circular(4.0),
                    ),
                  )
                )
              ],
            ),
          ),
        ]
      )
    );
  }
}
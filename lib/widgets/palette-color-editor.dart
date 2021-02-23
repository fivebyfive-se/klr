import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:klr/app/klr.dart';
import 'package:klr/helpers/color.dart';
import 'package:klr/helpers/iterable.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/services/app-state-service.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'btn.dart';
import 'togglable-text-editor.dart';
import 'txt.dart';

class PaletteColorEditor extends StatefulWidget {
  PaletteColorEditor({this.paletteColor, this.onDelete});

  final PaletteColor paletteColor;
  final Function() onDelete;

  @override
  _PaletteColorEditorState createState() => _PaletteColorEditorState();
}

class _PaletteColorEditorState extends State<PaletteColorEditor> {
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _paletteColor == null ? Container() : Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: ColorPicker(
              pickerColor: _paletteColor.color.toColor(),
              onColorChanged: _setColor,
              enableAlpha: true,
              displayThumbColor: false,
              labelTextStyle: Klr.textTheme.bodyText1,
              showLabel: true,
              paletteType: PaletteType.hsl,
              pickerAreaBorderRadius: const BorderRadius.only(
                topLeft: const Radius.circular(4.0),
                topRight: const Radius.circular(4.0),
              ),
            ),
          ),
          Expanded(flex: 4,
            child: ListView(
              children: [
                ListTile(
                  leading: Text('Name'),
                  title: TogglableTextEditor(
                    initalText: _paletteColor.name,
                    onChanged: (v) {
                      _paletteColor.name = v;
                      _saveColor();
                    },
                    style: TextStyle(
                      fontSize: Klr.textTheme.bodyText1.fontSize,
                    )
                  )
                ),
                ListTile(
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
                ListTile(
                  trailing: Icon(LineAwesomeIcons.backspace, color: colorRemove()),
                  title: Text('Remove color', style: styleColorRemove()),
                  onTap: _deleteColor,
                )
              
              
              ],
            )
          ),

          
        ]
      )
    );
  }
}
import 'package:fbf/ryb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:klr/widgets/hsluv-picker.dart';
import 'package:klr/widgets/tabber.dart';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/klr.dart';

import 'package:klr/models/app-state.dart';
import 'package:klr/models/hsluv.dart';

import 'package:klr/services/app-state-service.dart';

import 'togglable-text-editor.dart';
import 'txt.dart';

class PaletteColorEditor extends StatefulWidget {
  PaletteColorEditor({this.onDelete});

  final Function() onDelete;

  @override
  _PaletteColorEditorState createState() => _PaletteColorEditorState();
}

class _PaletteColorEditorState extends State<PaletteColorEditor> with KlrConfigMixin {
  AppStateService get _appStateService => appStateService();

  List<Harmony> get _harmonies => appStateService().snapshot.harmonies
            .order<Harmony>((a, b) => a.name.compareTo(b.name))
            .toList();

  Harmony _harmonyById(String id) 
    => _harmonies.firstWhere((h) => h.uuid == id);

  String _harmonyNameById(String id)
    => id == null || id == "" 
      ? 'None' 
      : _harmonyById(id).name;

  Future<void> _saveColor(PaletteColor pc) async {
    await pc.save();
    setState(() {});
  }

  Future<void> _deleteColor(Palette p, PaletteColor pc) async {
    p.colors.remove(pc);
    await p.save();
    await p.delete();
    widget.onDelete?.call();
    setState(() {});
  }

  void _setColor(PaletteColor pc, HSLuvColor col) {
    pc.color = col;
    _saveColor(pc);
  }

  void _selectHarmony(PaletteColor pc, String uuid) {
    pc.harmony = uuid;
    pc.transformations.clear();
    if (uuid != null && uuid != "") {
      final h = _harmonyById(uuid);
      pc.transformations.addAll(
        h.transformations.toList()
      );
    }
    _saveColor(pc);
  }

  @override
  Widget build(BuildContext context) {
    final vp = MediaQuery.of(context).size;

    return StreamBuilder<AppState>(
        initialData: _appStateService.snapshot,
        stream: _appStateService.appStateStream,
        builder: (context, snapshot) {
          final currentPalette = snapshot.data.currentPalette;
          final currentColor = snapshot.data.currentColor;

          return currentColor == null 
            ? Container() 
            : Container(
                height: 500.0,
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
                                initalText: currentColor.name,
                                onChanged: (v) {
                                  currentColor.name = v;
                                  _saveColor(currentColor);
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
                                initialValue: currentColor.harmony,
                                child: Txt.subtitle4(_harmonyNameById(currentColor.harmony)),
                                onSelected: (h) => _selectHarmony(currentColor, h),
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
                              onTap: () => _deleteColor(currentPalette, currentColor),
                            ),
                          )
                        ],
                      )
                    ),
                    Container(
                      height: 350,
                      child: Tabber(
                        title: 'Color picker:',
                        initialTab: 0,
                        tabs: [
                          TabberTab(
                            icon: Icons.color_lens_outlined,
                            label: 'RYB',
                            contentBuilder: (_) => RYBColorPicker(
                              initialColor: currentColor.color.toColor(),
                              onChange: (c) => _setColor(currentColor, HSLuvColor.fromColor(c)),
                            )
                          ),
                          TabberTab(
                            icon: Icons.adjust,
                            label: 'HSLuv',
                            contentBuilder: (_) => HSLuvPicker(
                              color: currentColor.color,
                              onChange: (c) => _setColor(currentColor, c),
                              height: 250
                            )
                          ),
                          // TabberTab(
                          //   icon: Icons.color_lens,
                          //   label: 'HSL',
                          //   contentBuilder: (_) => ColorPicker(
                          //     pickerColor: currentColor.color.toColor(),
                          //     onColorChanged: (c) => _setColor(currentColor, c),
                          //     enableAlpha: true,
                          //     displayThumbColor: false,
                          //     labelTextStyle: klr.textTheme.bodyText1,
                          //     showLabel: true,
                          //     paletteType: PaletteType.hsl,
                          //     pickerAreaBorderRadius: const BorderRadius.only(
                          //       topLeft:  const Radius.circular(4.0),
                          //       topRight: const Radius.circular(4.0),
                          //     ),
                          //   )
                          // )
                        ],
                      ),
                    ),
                  ]
                )
              );
      });
  }
}
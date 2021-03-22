import 'package:flutter/material.dart';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/klr.dart';
import 'package:klr/app/klr/colors.dart';

import 'package:klr/models/app-state.dart';

import 'package:klr/services/app-state-service.dart';

import 'package:klr/widgets/dialogs/image-picker-dialog.dart';
import 'package:klr/widgets/dialogs/palette-generator-dialog.dart';
import 'package:klr/widgets/richer-text.dart';
import 'package:klr/widgets/selectable.dart';


import 'page-data/start-page-data.dart';
import 'palette-page.dart';

class StartPage extends FbfPage<StartPageData> {
  static Color pageAccent = KlrColors.getInstance().pink95;
  static Color onPageAccent = KlrColors.getInstance().grey05; 
  static const String routeName = '/start';

  StartPage() : super();

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with KlrConfigMixin {
  AppStateService _appStateService = AppStateService.getInstance();

  Future<void> _createPalette() async {
    await _appStateService.createDefaultPalette();
    setState(() {});
  }

  Future<void> _showExtractDialog() async {
    showImagePickerDialog(context);
  }
  Future<void> _showGenerateDialog() async {
    showGeneratorDialog(context);
  }

  Future<void> _showPalette(Palette p) async {
    await _appStateService.setCurrentPalette(p);
    Navigator.pushNamed(context, PalettePage.routeName);
  }

  Future<void> _deleteSelected(List<Palette> selected) async {
    _appStateService.beginTransaction();
    for (final p in selected) {
      await _appStateService.deletePalette(p);
    }
    _appStateService.endTransaction();
  }


  Widget _paletteTile(Palette p, bool selected, bool showDetails) {
    final txt = (String text, TextStyle style)
      => Text(
        text ?? "", 
        style: style.withColor(
          selected 
            ? klr.theme.onPrimary
            : klr.theme.foreground
          )
    );

    final clrs = showDetails
      ? p.sortedColors.map(
          (e) => Icon(
            LineAwesomeIcons.square_full,
            color: e.color.toColor(),
            size: klr.size(4),
          )
        ).toList()
      : <Widget>[];
      

    return ListTile(
      leading: Icon(Icons.palette_outlined),
      title: txt(p.name, klr.textTheme.subtitle1),
      subtitle: txt(
        t.start_palettes_item(p.colors.length),
        klr.textTheme.subtitle2
      ),
      trailing: Wrap(
        alignment: WrapAlignment.end,
        children: clrs,
        spacing: klr.size(0.5),
        runSpacing: klr.size(0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = KlrConfig.r(context);

    return FbfStreamBuilder<KlrConfig, AppState>(
      stream: _appStateService.appStateStream,
      initialData: _appStateService.snapshot,
      builder: (context, config, snapshot) 
        => FbfScaffold<KlrConfig,StartPageData>(
              context: context,
              pageData: StartPageData(
                appState: snapshot,
                pageTitle: t.start_title,
                context: context,
              ),
              builder: (context, klr, pageData) => Container(
                child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Container(
                      height: klr.tileHeightSM,
                      child: ListTile(
                        title: Text(t.start_palettes_title, style: klr.textTheme.subtitle1),
                        subtitle: Text(t.start_palettes_subtitle, style: klr.textTheme.subtitle2)
                      )
                    )
                  ),

                  SelectableList<Palette>(
                    items: snapshot.palettes,

                    onPressed: (p) => _showPalette(p),

                    itemExtent: klr.tileHeightLG,

                    width: r.width,

                    noItems: RicherText.from(
                      [
                        t.start_noPalettes_intro,
                        [
                          t.start_noPalettes_tpl,
                          () => _createPalette()
                        ],
                        t.start_noPalettes_tpl_suffix,
                        [
                          t.start_noPalettes_gen,
                          () => _showGenerateDialog()
                        ],
                        t.start_noPalettes_gen_suffix,
                        [
                          t.start_noPalettes_img,
                          () => _showExtractDialog()
                        ],
                        t.start_noPalettes_img_suffix
                      ], 
                      baseStyle: klr.textTheme.subtitle1.copyWith(
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    crossAxisCount: 4,

                    rightActions: [
                      ListItemAction(
                        icon: Icon(
                          LineAwesomeIcons.plus_circle, 
                          color: klr.theme.primaryAccent
                        ),
                        onPressed: (_) => _createPalette(),
                        shouldShow: (_, s) => !s,
                        legend: Text(t.start_createPalette_tpl_title)
                      ),
                      ListItemAction(
                        icon: Icon(
                          Icons.functions_sharp,
                          color: klr.theme.primaryAccent
                        ),
                        onPressed: (_) => _showGenerateDialog(),
                        shouldShow: (_, s) => !s,
                        legend: Text(t.start_createPalette_gen_title)
                      ),
                      ListItemAction(
                        icon: Icon(
                          Icons.photo_filter,
                          color:klr.theme.primaryAccent
                        ),
                        onPressed: (_) => _showExtractDialog(),
                        shouldShow: (_, s) => !s,
                        legend: Text(t.start_createPalette_img_title)
                      ),
                      ListItemAction(
                        icon: Icon(
                          LineAwesomeIcons.trash,
                          color: klr.theme.tertiaryAccent
                        ),
                        onPressed: (selected) => _deleteSelected(selected),
                        shouldShow: (i, s) => s && i.isNotEmpty,
                        legend: Text(t.start_deletePalettes)
                      )
                    ],
                    widgetBuilder: _paletteTile,
                    height: r.height - klr.tileHeightSM
                  ),

                  sliverSpacer(
                    size: klr.size(2),
                  ),
                ],
              )
            )
        )
      
    );
  }
}



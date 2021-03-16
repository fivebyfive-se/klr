import 'package:fbf/ryb.dart' as ryb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:klr/models/hsluv/hsluv-color.dart';
import 'package:klr/widgets/color-picker/color-picker.dart';
import 'package:klr/widgets/color-picker/color-wheel.dart';
import 'package:klr/widgets/dialogs/palette-generator-dialog.dart';
import 'package:klr/widgets/richer-text.dart';
import 'package:klr/widgets/selectable.dart';
import 'package:klr/widgets/tabber.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/klr.dart';
import 'package:klr/app/klr/colors.dart';

import 'package:klr/models/app-state.dart';
import 'package:klr/models/app-state/models/app-state.dart';

import 'package:klr/services/app-state-service.dart';

import 'package:klr/widgets/dialogs/image-picker-dialog.dart';

import 'page-data/start-page-data.dart';
import 'palette-page.dart';

class StartPage extends FbfPage<StartPageData> {
  static Color pageAccent = KlrColors.getInstance().pink95;
  static Color onPageAccent = KlrColors.getInstance().grey05; 
  static const String routeName = '/start';

  static bool mounted = false;

  StartPage() : super();

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with KlrConfigMixin {
  AppStateService _appStateService = AppStateService.getInstance();
  AppState get _appState => _appStateService.snapshot;


  Future<void> _createPalette() async {
    await _appStateService.createBuiltinPalette();
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

    return ListTile(
      leading: showDetails ? Icon(Icons.palette_outlined) : null,
      title: txt(p.name, klr.textTheme.subtitle1),
      subtitle: showDetails
        ? txt(
          t.start_palettes_item(p.colors.length),
          klr.textTheme.subtitle2
        ) : null,
    );
  }

  @override
  void initState() {
    super.initState();
    StartPage.mounted = true;
  }

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.of(context).size;

    return FbfStreamBuilder<KlrConfig, AppState>(
      stream: _appStateService.appStateStream,
      initialData: _appStateService.snapshot,
      builder: (context, config, snapshot) 
        => FbfScaffold<KlrConfig,StartPageData>(
              context: context,
              pageData: StartPageData(
                appState: snapshot,
                pageTitle: 'Dashboard'
              ),
              builder: (context, klr, pageData) => Container(
                child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Container(
                      height: 64,
                      child: ListTile(
                        title: Text(t.start_palettes_title, style: klr.textTheme.subtitle1),
                        subtitle: Text(t.start_palettes_subtitle, style: klr.textTheme.subtitle2)
                      )
                    )
                  ),
                  SelectableList<Palette>(
                    items: snapshot.palettes,
                    onPressed: (p) => _showPalette(p),
                    noItems: RicherText.from(
                      [
                        "You don't have any palettes yet.\n",
                        "Create a palette ",
                        [
                          "based on a template",
                          () => _createPalette()
                        ],
                        ", ",
                        [
                          "using generator functions",
                          () => _showGenerateDialog()
                        ],
                        ", or ",
                        [
                          "by extracting colors from an image",
                          () => _showExtractDialog()
                        ],
                        "."
                      ], 
                      baseStyle: klr.textTheme.subtitle1.copyWith(
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // noItems: RichText(
                    //   text: TextSpan(
                    //     style: klr.textTheme.bodyText2,
                    //     children: [
                    //       TextSpan(
                    //         text: "You don't have any palettes yet. "
                    //       ),
                    //       TextSpan(
                    //         text: "Create one "
                    //       ),
                    //       TextSpan(
                    //         text: "from the default template",
                    //         recognizer: TapGestureRecognizer()
                              
                    //       ),
                    //       TextSpan(text: ", "),
                    //       TextSpan(
                    //         text: "using generator functions"
                    //       ),
                    //       TextSpan(text: ", or "),
                    //       TextSpan(
                    //         text: "extract colors from an image"
                    //       ),
                    //       TextSpan(text: ".")
                    //     ]
                    //   )
                    // ),
                    actions: [
                      ListItemAction(
                        icon: Icon(
                          LineAwesomeIcons.plus_circle, 
                          color: klr.theme.primaryAccent
                        ),
                        onPressed: (_) => _createPalette()
                      ),
                      ListItemAction(
                        icon: Icon(
                          Icons.functions_sharp,
                          color: klr.theme.primaryAccent
                        ),
                        onPressed: (_) => _showGenerateDialog()
                      ),
                      ListItemAction(
                        icon: Icon(
                          Icons.photo_filter,
                          color:klr.theme.primaryAccent
                        ),
                        onPressed: (_) => _showExtractDialog()
                      )
                    ],
                    selectedActions: [
                      ListItemAction(
                        icon: Icon(
                          LineAwesomeIcons.trash,
                          color: klr.theme.tertiaryAccent
                        ),
                        onPressed: (selected) => _deleteSelected(selected)
                      )
                    ],
                    widgetBuilder: _paletteTile,
                    height: viewport.height - 100
                  ),
                  sliverSpacer(
                    size: klr.size(2),
                  ),
                  SliverGrid.count(
                    crossAxisCount: 2,
                    children: [
                      FbfTile.action(
                        icon: Icons.functions_sharp,
                        title: t.start_createPalette_tpl_title,
                        subtitle: t.start_createPalette_tpl_subtitle,
                        onTap: () => _showGenerateDialog()
                      ),
                      FbfTile.action(
                        icon: Icons.photo_filter,
                        title: t.start_createPalette_img_title,
                        subtitle: t.start_createPalette_img_subtitle,
                        onTap: () => _showExtractDialog()
                      )
                    ],
                  )
                ],
              )
            )
        )
      
    );
  }
}



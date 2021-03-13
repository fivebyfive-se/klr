import 'package:fbf/fbf.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/views/page-data/klr-page-data-base.dart';

class PalettePageData extends KlrPageDataBase
                    implements  FbfPageWithFabMenu
{
  PalettePageData({
    AppState appState,
    FabMenuConfig fabMenuConfig,
  }) 
    : _fabMenuConfig = fabMenuConfig,
      super(appState: appState, pageTitle: 'Palette', pageRoute: '/palette');

  final FabMenuConfig _fabMenuConfig;

  @override
  FabMenuConfig get fabMenuConfig => _fabMenuConfig;

}
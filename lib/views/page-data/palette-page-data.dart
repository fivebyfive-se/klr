import 'package:fbf/fbf.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/views/page-data/klr-page-data-base.dart';

class PalettePageData extends KlrPageDataBase
                    implements  FbfPageWithFabMenu<String>
{
  PalettePageData({
    AppState appState,
    FabMenuConfig<String> fabMenuConfig,
  }) 
    : _fabMenuConfig = fabMenuConfig,
      super(appState: appState, pageTitle: 'Palette', pageRoute: '/palette');

  final FabMenuConfig<String> _fabMenuConfig;

  @override
  FabMenuConfig<String> get fabMenuConfig => _fabMenuConfig;

}
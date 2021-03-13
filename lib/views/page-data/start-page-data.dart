import 'package:fbf/fbf.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/views/page-data/klr-page-data-base.dart';

class StartPageData extends KlrPageDataBase
                    implements  FbfPageWithFabMenu
{
  StartPageData({
    AppState appState,
    FabMenuConfig fabMenuConfig,
  }) 
    : _fabMenuConfig = fabMenuConfig,
      super(appState: appState, pageTitle: 'Dashboard', pageRoute: '/start');

  final FabMenuConfig _fabMenuConfig;

  @override
  FabMenuConfig get fabMenuConfig => _fabMenuConfig;

}
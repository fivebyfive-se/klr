import 'package:fbf/fbf.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/views/page-data/klr-page-data-base.dart';

class StartPageData extends KlrPageDataBase
                    implements  FbfPageWithFabMenu<String>
{
  StartPageData({
    AppState appState,
    FabMenuConfig<String> fabMenuConfig,
  }) 
    : _fabMenuConfig = fabMenuConfig,
      super(appState: appState, pageTitle: 'Dashboard', pageRoute: '/start');

  final FabMenuConfig<String> _fabMenuConfig;

  @override
  FabMenuConfig<String> get fabMenuConfig => _fabMenuConfig;

}
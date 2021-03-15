import 'package:klr/models/app-state.dart';
import 'package:klr/views/page-data/klr-page-data-base.dart';
import 'package:klr/views/views.dart';

class StartPageData extends KlrPageDataBase
{
  StartPageData({
    AppState appState,
    String pageTitle
  }) 
    : super(appState: appState, pageTitle: pageTitle, pageRoute: StartPage.routeName);
}
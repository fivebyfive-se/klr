import 'package:flutter/material.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/views/views.dart';

import 'klr-page-data-base.dart';

class StartPageData extends KlrPageDataBase
{
  StartPageData({
    AppState appState,
    String pageTitle,
    BuildContext context,
  }) 
    : super(
      appState: appState,
      pageTitle: pageTitle,
      pageRoute: StartPage.routeName,
      context: context,
    );
}
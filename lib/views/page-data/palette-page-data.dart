import 'package:fbf/fbf.dart';
import 'package:flutter/material.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/views/page-data/klr-page-data-base.dart';
import 'package:klr/views/palette-page.dart';

class PalettePageData extends KlrPageDataBase
{
  PalettePageData({
    AppState appState,
    String pageTitle,
    BuildContext context,
  }) 
    : super(
      appState: appState,
      pageTitle: pageTitle,
      pageRoute: PalettePage.routeName,
      context: context,
    );
}
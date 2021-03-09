import 'package:fbf/fbf.dart';
import 'package:flutter/material.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/views/palette-page.dart';
import 'package:klr/widgets/logo.dart';

import '../start-page.dart';

abstract class KlrPageDataBase extends FbfPageData
                              implements FbfPageWithBottomNavigation,
                                         FbfPageWithDrawer
{
  KlrPageDataBase({
    this.appState,
    String pageRoute,
    String pageTitle
  }) : super(pageRoute: pageRoute, pageTitle: pageTitle);
  
  final AppState appState;

  @override
  List<FbfDrawerItem> get drawerItems => <FbfDrawerItem>[
    FbfDrawerHeader(
      logo: Logo(logo: Logos.logo),
    )
  ];

  @override
  List<FbfBottomNavigationPage> get pages => [
    FbfBottomNavigationPage(
      label: 'Dashboard',
      routeName: StartPage.routeName,
      icon: Icons.dashboard,
      activeIcon: Icons.dashboard,
      disabledIcon: Icons.dashboard_outlined,
    ),
    FbfBottomNavigationPage(
      label: 'Palette',
      routeName: PalettePage.routeName,
      icon: Icons.palette,
      disabledIcon: Icons.palette_outlined,
      activeIcon: Icons.palette,
      disabled: appState.currentPalette == null
    )
  ];
}
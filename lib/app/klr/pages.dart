import 'package:flutter/material.dart';
import 'package:klr/classes/fbf.dart';
import 'package:klr/classes/fbf/routing/sub-page-route.dart';

import 'package:klr/views/splash-page.dart';
import 'package:klr/views/start-page.dart';
import 'package:klr/views/subpages/start/dashboard.dart';
import 'package:klr/views/subpages/start/palette.dart';

class KlrPages extends FbfPageRouteList {
  KlrPages() : super(<FbfPageRoute>[
    FbfPageRoute(
      routeName: SplashPage.routeName,
      builder: (context) => SplashPage(),
    ),
    FbfPageRoute(
      routeName: StartPage.routeName,
      builder: (context) => StartPage(),
      children: [
        DashboardSubPage.routeDefinition,
        PaletteSubPage.routeDefinition,
      ]
    ),
  ]);
}
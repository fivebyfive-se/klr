import 'package:fbf/flutter.dart';

import 'package:klr/views/views.dart';

class KlrPages extends FbfPageRouteList {
  KlrPages() : super(<FbfPageRoute>[
    FbfPageRoute(
      routeName: StartPage.routeName,
      builder: (context) => StartPage(),
    ),
    FbfPageRoute(
      routeName: PalettePage.routeName,
      builder: (context) => PalettePage(),
    ),
  ]);
}
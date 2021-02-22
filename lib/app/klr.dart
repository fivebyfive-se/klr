import 'package:flutter/material.dart';
import 'package:klr/app/klr/font-theme.dart';

import 'package:klr/classes/fbf.dart';
import 'package:klr/views/views.dart';

import 'klr/colors.dart';
import 'klr/pages.dart';
import 'klr/theme.dart';

export 'klr/colors.dart';
export 'klr/pages.dart';
export 'klr/theme.dart';

class Klr {
  static Widget makeApp() => _KlrApp();

  static const appTitle = 'klr';

  static KlrColors colors = KlrColors.getInstance();

  static FivebyfiveFontTheme fontTheme = KlrFontTheme();
  static FivebyfiveTheme theme = KlrTheme(fontTheme);

  static ThemeData get themeData => theme.toThemeData();
  static TextTheme get textTheme => themeData.textTheme;

  static FbfPageRouteList pages = KlrPages();

  static const iconSizeXLarge = 32.5;
  static const iconSizeLarge  = 21.0;

  static const sizeBase       = 10.5;
}

class _KlrApp extends StatelessWidget {
  Widget build(BuildContext context) 
    => MaterialApp(
      title: Klr.appTitle,
      theme: Klr.theme.toThemeData(),
      routes: Klr.pages.routes,
      initialRoute: SplashPage.routeName,
    );
}

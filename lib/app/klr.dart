import 'package:flutter/material.dart';
import 'package:klr/app/klr/font-theme.dart';

import 'package:fbf/flutter.dart';

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

  static FivebyfiveLayoutTheme layoutTheme = FivebyfiveLayoutTheme(
    baseSize: 8.0,
    baseBorderWidth: 2.0
  );
  static FivebyfiveFontTheme fontTheme = KlrFontTheme();
  static FivebyfiveTheme theme = KlrTheme(fontTheme);

  static ThemeData get themeData => theme.themeData;
  static TextTheme get textTheme => themeData.textTheme;
  static CodeTheme get codeTheme => themeData.codeTheme;

  static FbfLayoutBorder get border => layoutTheme.border;
  static FbfLayoutEdge   get edge   => layoutTheme.edgeInsets;

  static double size([double f = 1.0]) => layoutTheme.size(f);
  static double borderWidth([double f = 1.0]) => layoutTheme.borderWidth(f);

  static FbfPageRouteList pages = KlrPages();

  static const double iconSizeXLarge = 32.0;
  static const double iconSizeLarge  = 24.0;
  static const double baseSize       = 8.0;
  static const double baseBorderSize = 2.0;
  static const double baseFontSize   = 10.0;
}

class _KlrApp extends StatelessWidget {
  Widget build(BuildContext context) 
    => MaterialApp(
      title: Klr.appTitle,
      theme: Klr.theme.themeData,
      routes: Klr.pages.routes,
      home: SplashPage()
    );
}

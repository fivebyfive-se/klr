import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fbf/flutter.dart';
import 'package:klr/app/klr/font-theme.dart';

import 'colors.dart';

class KlrForty extends FbfTheme {
  static KlrColors klrs = KlrColors.getInstance();
}

class KlrTheme extends FbfTheme {
  static KlrColors klrs = KlrColors.getInstance();

  KlrTheme()
    : super(
      fontTheme: KlrFontTheme(),
      layoutTheme: FbfLayoutTheme(
        baseSize: 8.0,
        baseBorderWidth: 2.0
      ),
      background: klrs.grey05,
      foreground: klrs.grey95,
      foregroundDisabled: klrs.grey50,

      backgroundGradient: LinearGradient(
        colors: [klrs.grey20, klrs.grey10],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter
      ),
      cardBackground: klrs.steel20,
      cardForeground: klrs.grey95,

      dialogBackground: klrs.steel25,
      dialogForeground: klrs.grey95,

      error: Colors.red,
      warning: Colors.orange[800],

      primaryTriad: ColorTriad(klrs.pink70, klrs.pink55, klrs.pink90),
      secondaryTriad: ColorTriad(klrs.blue80, klrs.blue65, klrs.blue99),
      tertiaryTriad: ColorTriad(klrs.red80, klrs.red60, klrs.red95),

      onPrimary: klrs.grey99,
      onSecondary: klrs.grey99,
      onTertiary: klrs.bamboo99,

      highlight: ColorTriad(klrs.purple90, klrs.purple60, klrs.purple99),
      focus: ColorTriad(klrs.yellow90, klrs.yellow80, klrs.yellow90),

      appBarBackground: klrs.steel40,
      appBarForeground: klrs.bamboo99,

      bottomNavBackground: klrs.steel35,
      bottomNavForeground: klrs.grey95,
      bottomNavSelected: klrs.pink99,
      bottomNavDisabled: klrs.grey50,

      logoBackgroundGradient: 
        LinearGradient(
          colors: [klrs.pink80, klrs.steel50.withAlpha(0)],
          begin: Alignment(0, -2.0),
          end: Alignment.bottomCenter
        ),

      drawerBackgroundGradient:
        LinearGradient(
          colors: [klrs.steel60, klrs.steel35, klrs.grey14],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
        ),

      splashGradientStart: LinearGradient(
        begin: Alignment(2.5, -1.0),
        end:   Alignment(-1.0, 1.5),
        colors: [
          klrs.grey14,
          klrs.steel25,
          klrs.grey14
        ],
      ),

      splashGradientEnd: LinearGradient(
        begin: Alignment(2.0, -0.5),
        end:   Alignment(-0.5, 2.0),
        colors: [
          klrs.bamboo90,
          klrs.purple99,
          klrs.orange99,
          klrs.pink95,
          klrs.blue95,
          klrs.green90,
          klrs.yellow90,
        ],
      )
    );

    Color get selectableItemBackground => klrs.steel25;
    Color get selectableItemBorder => klrs.steel20;
    Color get selectableItemIcon => klrs.steel35;
    Color get selectableItemIconSelected => klrs.steel90;
    Color get selectableHeaderBackground => klrs.steel35;
    Color get selectableLegendBackground => klrs.steel40;
}
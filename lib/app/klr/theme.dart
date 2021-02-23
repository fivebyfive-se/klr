import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:klr/classes/fbf.dart';
import 'package:klr/helpers/color.dart';

import 'colors.dart';
import 'font-theme.dart';

class KlrForty extends FivebyfiveTheme {
  static KlrColors klrs = KlrColors.getInstance();
}

class KlrTheme extends FivebyfiveTheme {
  static KlrColors klrs = KlrColors.getInstance();

  KlrTheme(
    FivebyfiveFontTheme fontTheme
  )
    : super(
      fontTheme: fontTheme,
      background: klrs.grey05,
      foreground: klrs.grey95,
      foregroundDisabled: klrs.grey60,

      backgroundGradient: LinearGradient(
        colors: [klrs.grey17, klrs.grey05],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter
      ),
      cardBackground: klrs.steel20,
      cardForeground: klrs.grey95,

      dialogBackground: klrs.steel25,
      dialogForeground: klrs.grey95,

      error: Colors.red,
      warning: Colors.orange[800],

      primary: ColorTriad(klrs.pink70, klrs.pink55, klrs.pink90),
      secondary: ColorTriad(klrs.purple95, klrs.purple90, klrs.purple99),
      tertiary: ColorTriad(klrs.red90, klrs.red80, klrs.red95),

      highlight: ColorTriad(klrs.blue95, klrs.blue90, klrs.blue99),
      focus: ColorTriad(klrs.yellow90, klrs.yellow80, klrs.yellow90),

      appBarBackground: klrs.grey35,
      appBarForeground: klrs.bamboo90,

      bottomNavBackground: klrs.grey10,
      bottomNavForeground: klrs.grey80,
      bottomNavSelected: klrs.purple99,
      bottomNavDisabled: klrs.grey50,

      logoBackgroundGradient: 
        LinearGradient(
          colors: [klrs.yellow90, klrs.red40.withAlpha(0)],
          begin: Alignment(0, -2.0),
          end: Alignment.bottomCenter
        ),

      drawerBackgroundGradient:
        LinearGradient(
          colors: [klrs.grey17, klrs.pink20, klrs.pink55, klrs.purple99],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
        ),

      splashGradientStart: LinearGradient(
        begin: Alignment(2.5, -1.0),
        end:   Alignment(-1.0, 1.5),
        colors: [
          klrs.grey14,
          klrs.grey20,
          klrs.grey14
        ],
      ),

      splashGradientEnd: LinearGradient(
        begin: Alignment(2.0, -0.5),
        end:   Alignment(-0.5, 2.0),
        colors: [
          klrs.green35,
          klrs.purple45,
          klrs.purple99,
          klrs.orange99,
          klrs.pink95,
          klrs.blue70,
          klrs.grey25,
        ],
      )
    );
}
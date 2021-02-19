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

  KlrTheme()
    : super(
      fontTheme: KlrFontTheme(),
      background: klrs.grey05,
      foreground: klrs.grey95,
      foregroundDisabled: klrs.grey60,

      backgroundGradient: LinearGradient(
        colors: [klrs.grey17, klrs.grey05],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter
      ),
      cardBackground: klrs.grey20,
      cardForeground: klrs.grey95,

      dialogBackground: klrs.grey17,
      dialogForeground: klrs.grey95,

      error: Colors.red,
      warning: Colors.orange[800],

      primary: ColorTriad(klrs.pink70, klrs.pink55, klrs.pink90),
      secondary: ColorTriad(klrs.orange80, klrs.orange80, klrs.orange95),
      tertiary: ColorTriad(klrs.purple80, klrs.purple70, klrs.purple95),

      focus: ColorTriad(klrs.blue70, klrs.blue65, klrs.blue95),
      highlight: ColorTriad(klrs.green80, klrs.green60, klrs.green95),

      appBarBackground: klrs.grey35,
      appBarForeground: klrs.bamboo90,

      bottomNavBackground: klrs.grey25,
      bottomNavForeground: klrs.grey80,
      bottomNavSelected: klrs.pink95,
      bottomNavDisabled: klrs.grey50,

      logoBackgroundGradient: 
        LinearGradient(
          colors: [klrs.orange99, klrs.pink20.withAlpha(0)],
          begin: Alignment(0, -2.0),
          end: Alignment.bottomCenter
        ),

      drawerBackgroundGradient:
        LinearGradient(
          colors: [klrs.purple60, klrs.pink40, klrs.pink20],
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
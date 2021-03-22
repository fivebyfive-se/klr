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
  static KlrAltColors aklrs = KlrAltColors.getInstance();

  KlrTheme()
    : 
      super(
      fontTheme: KlrFontTheme(),
      layoutTheme: FbfLayoutTheme(
        baseSize: 8.0,
        baseBorderWidth: 2.0
      ),
      background: aklrs.darkestGrey,
      foreground: aklrs.lightestGrey,
      foregroundDisabled: aklrs.lighterGrey,

      backgroundGradient: LinearGradient(
        colors: [aklrs.darkestGrey, aklrs.darkerGrey],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter
      ),
      cardBackground: aklrs.darkGrey,
      cardForeground: aklrs.lighterGrey,

      dialogBackground: aklrs.darkGrey,
      dialogForeground: aklrs.lighterGrey,

      error: aklrs.red,
      warning: aklrs.orange,

      primaryTriad: ColorTriad(aklrs.darkYellow, aklrs.darkerYellow, aklrs.yellow),
      secondaryTriad: ColorTriad(aklrs.darkGreen, aklrs.darkerGreen, aklrs.green),
      tertiaryTriad: ColorTriad(aklrs.pink, aklrs.darkerPink, aklrs.lightPink),

      onPrimary: aklrs.darkestGrey,
      onSecondary: aklrs.darkestGrey,
      onTertiary: aklrs.darkestGrey,

      highlight: ColorTriad(aklrs.blue, aklrs.darkBlue, aklrs.lightBlue),
      focus: ColorTriad(aklrs.violet, aklrs.darkViolet, aklrs.lightViolet),

      appBarBackground: aklrs.yellow,
      appBarForeground: aklrs.darkerGrey,

      bottomNavBackground: aklrs.darkGrey,
      bottomNavForeground: aklrs.lighterGrey,
      bottomNavSelected: aklrs.yellow,
      bottomNavDisabled: aklrs.grey,

      logoBackgroundGradient: 
        LinearGradient(
          colors: [aklrs.darkerGrey, aklrs.grey.withAlpha(0)],
          begin: Alignment(0, -2.0),
          end: Alignment.bottomCenter
        ),

      drawerBackgroundGradient:
        LinearGradient(
          colors: [aklrs.grey, aklrs.darkestGrey],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
        ),

      splashGradientStart: LinearGradient(
        begin: Alignment(2.5, -1.0),
        end:   Alignment(-1.0, 1.5),
        colors: [aklrs.darkestGrey, aklrs.darkGrey, aklrs.darkerGrey, aklrs.darkestGrey],
      ),

      splashGradientEnd: LinearGradient(
        begin: Alignment(2.0, -0.5),
        end:   Alignment(-0.5, 2.0),
        colors: [
          aklrs.darkViolet,
          aklrs.yellow,
          aklrs.lightOrange,
          aklrs.darkGreen,
          aklrs.pink,
          aklrs.lighterOrange
        ],
      ),
      
    );

    Color get selectableItemBackground => aklrs.darkGrey;
    Color get selectableItemBorder => aklrs.darkestGrey;
    Color get selectableItemIcon => aklrs.darkerGrey;
    Color get selectableItemIconSelected => aklrs.lighterGrey;
    Color get selectableHeaderBackground => aklrs.grey;
    Color get selectableLegendBackground => aklrs.darkGrey;

    Color get tableHeaderColor => aklrs.darkGrey;
    Color get tableHeaderForegroundColor => aklrs.lightestGrey;
    Color get tableActiveHeaderColor => aklrs.lightYellow;
    Color get tableActiveHeaderForegroundColor => aklrs.darkestGrey;
    Color get tableSubHeaderColor => aklrs.lighterYellow;
    Color get tableSubHeaderForegroundColor => aklrs.darkestGrey;
    Color get tableBackground => aklrs.darkestGrey;

  // KlrTheme()
  //   : super(
  //     fontTheme: KlrFontTheme(),
  //     layoutTheme: FbfLayoutTheme(
  //       baseSize: 8.0,
  //       baseBorderWidth: 2.0
  //     ),
  //     background: klrs.grey05,
  //     foreground: klrs.grey95,
  //     foregroundDisabled: klrs.grey50,

  //     backgroundGradient: LinearGradient(
  //       colors: [klrs.grey20, klrs.grey10],
  //       begin: Alignment.topCenter,
  //       end: Alignment.bottomCenter
  //     ),
  //     cardBackground: klrs.steel20,
  //     cardForeground: klrs.grey95,

  //     dialogBackground: klrs.steel25,
  //     dialogForeground: klrs.grey95,

  //     error: Colors.red,
  //     warning: Colors.orange[800],

  //     primaryTriad: ColorTriad(klrs.pink70, klrs.pink55, klrs.pink90),
  //     secondaryTriad: ColorTriad(klrs.blue80, klrs.blue65, klrs.blue99),
  //     tertiaryTriad: ColorTriad(klrs.red80, klrs.red60, klrs.red95),

  //     onPrimary: klrs.grey99,
  //     onSecondary: klrs.grey99,
  //     onTertiary: klrs.bamboo99,

  //     highlight: ColorTriad(klrs.bamboo90, klrs.bamboo70, klrs.bamboo99),
  //     focus: ColorTriad(klrs.yellow90, klrs.yellow70, klrs.yellow90),

  //     appBarBackground: klrs.blue65,
  //     appBarForeground: klrs.bamboo99,

  //     bottomNavBackground: klrs.steel50,
  //     bottomNavForeground: klrs.grey99,
  //     bottomNavSelected: klrs.pink99,
  //     bottomNavDisabled: klrs.grey70,

  //     logoBackgroundGradient: 
  //       LinearGradient(
  //         colors: [klrs.pink80, klrs.steel50.withAlpha(0)],
  //         begin: Alignment(0, -2.0),
  //         end: Alignment.bottomCenter
  //       ),

  //     drawerBackgroundGradient:
  //       LinearGradient(
  //         colors: [klrs.steel60, klrs.steel35, klrs.grey14],
  //         begin: Alignment.topCenter,
  //         end: Alignment.bottomCenter
  //       ),

  //     splashGradientStart: LinearGradient(
  //       begin: Alignment(2.5, -1.0),
  //       end:   Alignment(-1.0, 1.5),
  //       colors: [
  //         klrs.grey14,
  //         klrs.steel25,
  //         klrs.grey14
  //       ],
  //     ),

  //     splashGradientEnd: LinearGradient(
  //       begin: Alignment(2.0, -0.5),
  //       end:   Alignment(-0.5, 2.0),
  //       colors: [
  //         klrs.bamboo90,
  //         klrs.purple99,
  //         klrs.orange99,
  //         klrs.pink95,
  //         klrs.blue95,
  //         klrs.green90,
  //         klrs.yellow90,
  //       ],
  //     )
  //   );

  //   Color get selectableItemBackground => klrs.steel25;
  //   Color get selectableItemBorder => klrs.steel15;
  //   Color get selectableItemIcon => klrs.steel35;
  //   Color get selectableItemIconSelected => klrs.steel90;
  //   Color get selectableHeaderBackground => klrs.steel40;
  //   Color get selectableLegendBackground => klrs.steel40;

  //   Color get tableHeaderColor => klrs.steel35;
  //   Color get tableSubHeaderColor => klrs.steel30;
  //   Color get tableBackground => klrs.steel25;
}

class EditorTileTheme {
  const EditorTileTheme({
    this.backgroundColor,
    this.foregroundColor,
    this.fieldStyle,
    this.labelStyle
  });

  final Color backgroundColor;
  final Color foregroundColor;

  final TextStyle fieldStyle;
  final TextStyle labelStyle;
}
import 'package:flutter/material.dart';
import 'package:klr/helpers/color.dart';

import 'color-triad.dart';
import 'font-theme.dart';

class FivebyfiveTheme {
  FivebyfiveTheme({
    this.fontTheme,
    this.brightness = Brightness.dark,

    this.background = Colors.black,
    this.foreground = Colors.white,
    this.foregroundDisabled = Colors.grey,

    this.primaryTriad,
    this.secondaryTriad,
    this.tertiaryTriad,

    this.appBarBackground,
    this.appBarForeground,

    ColorTriad focus,
    ColorTriad highlight,
  
    LinearGradient drawerBackgroundGradient,
    LinearGradient backgroundGradient,
    LinearGradient logoBackgroundGradient,
    LinearGradient splashGradientStart,
    LinearGradient splashGradientEnd,

    Color cardBackground,
    Color cardForeground,

    Color dialogBackground,
    Color dialogForeground,

    Color bottomNavBackground,
    Color bottomNavForeground,
    Color bottomNavSelected,
    Color bottomNavDisabled,

    Color error,
    Color warning,

  }) :
      this.focusTriad = focus ?? primaryTriad,
      this.highlightTriad = highlight ?? secondaryTriad,

      this.backgroundGradient = backgroundGradient 
        ?? background.gradientTo(background.withAlpha(0x80)),

      this.logoBackgroundGradient = logoBackgroundGradient
        ?? primaryTriad.base.gradientTo(secondaryTriad.base),
      this.drawerBackgroundGradient = drawerBackgroundGradient
        ?? focus.base.gradientTo(tertiaryTriad.light),
      this.splashGradientStart = splashGradientStart ?? logoBackgroundGradient,
      this.splashGradientEnd   = splashGradientEnd ?? logoBackgroundGradient.reverse(),

      this.cardBackground = cardBackground ?? background,
      this.cardForeground = cardForeground ?? foreground,
      this.dialogBackground = dialogBackground ?? background,
      this.dialogForeground = dialogForeground ?? foreground,

      this.bottomNavBackground = bottomNavBackground ?? cardBackground,
      this.bottomNavForeground = bottomNavForeground ?? cardForeground,
      this.bottomNavSelected = bottomNavSelected ?? highlight?.light ?? secondaryTriad.light,
      this.bottomNavDisabled = bottomNavDisabled ?? foregroundDisabled,

      this.error = error ?? Colors.redAccent,
      this.warning = warning ?? Colors.deepOrangeAccent
    ;

  final FivebyfiveFontTheme fontTheme;

  final Brightness brightness;

  final ColorTriad primaryTriad;
  final ColorTriad secondaryTriad;
  final ColorTriad tertiaryTriad;

  final ColorTriad focusTriad;
  final ColorTriad highlightTriad;
  
  final Color background;
  final Color foreground;
  final Color foregroundDisabled;

  final LinearGradient backgroundGradient;
  final LinearGradient logoBackgroundGradient;
  final LinearGradient drawerBackgroundGradient;
  final LinearGradient splashGradientStart;
  final LinearGradient splashGradientEnd;

  final Color cardBackground;
  final Color cardForeground;

  final Color dialogBackground;
  final Color dialogForeground;

  final Color appBarBackground;
  final Color appBarForeground;

  final Color bottomNavBackground;
  final Color bottomNavForeground;
  final Color bottomNavSelected;
  final Color bottomNavDisabled;

  final Color error;
  final Color warning;

  bool get isDark => brightness == Brightness.dark;

  Color get primary => primaryTriad.base;
  Color get secondary => secondaryTriad.base;
  Color get tertiary => tertiaryTriad.base;
  Color get focus => focusTriad.base;
  Color get highlight => highlightTriad.base;

  Color get primaryAccent => isDark ? primaryTriad.light : primaryTriad.dark;
  Color get secondaryAccent => isDark ? secondaryTriad.light : secondaryTriad.dark;
  Color get tertiaryAccent => isDark ? tertiaryTriad.light : tertiaryTriad.dark;
  Color get focusAccent => isDark ? focusTriad.light : focusTriad.dark;
  Color get highlightAccent => isDark ? highlightTriad.light : highlightTriad.dark;


  @protected
  Map<String,TextStyle> _codeHighlightTheme;

  Map<String,TextStyle> get codeHighlightTheme
    => _codeHighlightTheme ?? (_codeHighlightTheme = {
    'root':
        TextStyle(color: foreground, backgroundColor: background),
    'comment': TextStyle(color: foregroundDisabled, fontStyle: FontStyle.italic),
    'quote': TextStyle(color: focusAccent, fontStyle: FontStyle.italic),
    'keyword': TextStyle(color: highlightAccent, fontWeight: FontWeight.bold),
    'selector-tag':
        TextStyle(color: highlightAccent, fontWeight: FontWeight.bold),
    'subst': TextStyle(color: highlightAccent, fontWeight: FontWeight.normal),
    'number': TextStyle(color: primaryAccent),
    'literal': TextStyle(color: secondaryAccent),
    'variable': TextStyle(color: tertiaryAccent),
    'template-variable': TextStyle(color: tertiaryTriad.base),
    'string': TextStyle(color: focusAccent),
    'doctag': TextStyle(color: focusTriad.base),
    'title': TextStyle(color: focusTriad.base, fontWeight: FontWeight.bold),
    'section': TextStyle(color: focusTriad.base, fontWeight: FontWeight.bold),
    'selector-id':
        TextStyle(color: highlightTriad.base, fontWeight: FontWeight.bold),
    'type': TextStyle(color: highlightTriad.dark, fontWeight: FontWeight.bold),
    'tag': TextStyle(color: highlightAccent, fontWeight: FontWeight.normal),
    'name': TextStyle(color: highlightTriad.base, fontWeight: FontWeight.normal),
    'attribute':
        TextStyle(color: highlightTriad.dark, fontWeight: FontWeight.normal),
    'regexp': TextStyle(color: focusAccent),
    'link': TextStyle(color: primaryTriad.dark),
    'symbol': TextStyle(color: tertiaryAccent),
    'bullet': TextStyle(color: highlightAccent),
    'built_in': TextStyle(color: tertiaryTriad.base),
    'builtin-name': TextStyle(color: tertiaryTriad.dark),
    'meta': TextStyle(color: secondaryAccent, fontWeight: FontWeight.bold),
    'deletion': TextStyle(backgroundColor: error),
    'addition': TextStyle(backgroundColor: highlightAccent),
    'emphasis': TextStyle(fontStyle: FontStyle.italic),
    'strong': TextStyle(fontWeight: FontWeight.bold),
  });
 


  @protected
  ThemeData _themeData;

  ThemeData get themeData => _themeData ?? (
    _themeData = ThemeData(
      brightness:      brightness,
      backgroundColor: background,
      canvasColor:     background,

      primaryColor:    primaryTriad.base,
      primaryColorDark: primaryTriad.dark,
      primaryColorLight: primaryTriad.light,

      accentColor:     secondaryTriad.base,

      splashColor:     tertiaryTriad.base,
      focusColor:      focusTriad.base,
      
      errorColor:      error,
      
      cardColor:       cardBackground,
      buttonColor:     primaryTriad.base,

      dialogBackgroundColor: dialogBackground,
      
      textTheme: fontTheme.textTheme,
      fontFamily: fontTheme.fontBody,
      
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        backgroundColor: appBarBackground,
        foregroundColor: appBarForeground,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: tertiaryTriad.base,
        focusColor: tertiaryAccent,
        hoverColor: tertiaryAccent
      )
    ).withCodeTheme(
      fontTheme.codeTheme
    )
  );
}
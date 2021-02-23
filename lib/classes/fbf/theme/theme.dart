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

    this.primary,
    this.secondary,
    this.tertiary,

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
      this.focus = focus ?? primary,
      this.highlight = highlight ?? secondary,

      this.backgroundGradient = backgroundGradient 
        ?? background.gradientTo(background.withAlpha(0x80)),

      this.logoBackgroundGradient = logoBackgroundGradient
        ?? primary.base.gradientTo(secondary.base),
      this.drawerBackgroundGradient = drawerBackgroundGradient
        ?? focus.base.gradientTo(tertiary.light),
      this.splashGradientStart = splashGradientStart ?? logoBackgroundGradient,
      this.splashGradientEnd   = splashGradientEnd ?? logoBackgroundGradient.reverse(),

      this.cardBackground = cardBackground ?? background,
      this.cardForeground = cardForeground ?? foreground,
      this.dialogBackground = dialogBackground ?? background,
      this.dialogForeground = dialogForeground ?? foreground,

      this.bottomNavBackground = bottomNavBackground ?? cardBackground,
      this.bottomNavForeground = bottomNavForeground ?? cardForeground,
      this.bottomNavSelected = bottomNavSelected ?? highlight?.light ?? secondary.light,
      this.bottomNavDisabled = bottomNavDisabled ?? foregroundDisabled,

      this.error = error ?? Colors.redAccent,
      this.warning = warning ?? Colors.deepOrangeAccent
    ;

  final FivebyfiveFontTheme fontTheme;

  final Brightness brightness;

  final ColorTriad primary;
  final ColorTriad secondary;
  final ColorTriad tertiary;

  final ColorTriad focus;
  final ColorTriad highlight;
  
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

  Color get primaryAccent => isDark ? primary.light : primary.dark;
  Color get secondaryAccent => isDark ? secondary.light : secondary.dark;
  Color get tertiaryAccent => isDark ? tertiary.light : tertiary.dark;
  Color get focusAccent => isDark ? focus.light : focus.dark;
  Color get highlightAccent => isDark ? highlight.light : highlight.dark;

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
    'template-variable': TextStyle(color: tertiary.base),
    'string': TextStyle(color: focusAccent),
    'doctag': TextStyle(color: focus.base),
    'title': TextStyle(color: focus.base, fontWeight: FontWeight.bold),
    'section': TextStyle(color: focus.base, fontWeight: FontWeight.bold),
    'selector-id':
        TextStyle(color: highlight.base, fontWeight: FontWeight.bold),
    'type': TextStyle(color: highlight.dark, fontWeight: FontWeight.bold),
    'tag': TextStyle(color: highlightAccent, fontWeight: FontWeight.normal),
    'name': TextStyle(color: highlight.base, fontWeight: FontWeight.normal),
    'attribute':
        TextStyle(color: highlight.dark, fontWeight: FontWeight.normal),
    'regexp': TextStyle(color: focusAccent),
    'link': TextStyle(color: primary.dark),
    'symbol': TextStyle(color: tertiaryAccent),
    'bullet': TextStyle(color: highlightAccent),
    'built_in': TextStyle(color: tertiary.base),
    'builtin-name': TextStyle(color: tertiary.dark),
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

      primaryColor:    primary.base,
      primaryColorDark: primary.dark,
      primaryColorLight: primary.light,

      accentColor:     secondary.base,

      splashColor:     tertiary.base,
      focusColor:      focus.base,
      
      errorColor:      error,
      
      cardColor:       cardBackground,
      buttonColor:     primary.base,

      dialogBackgroundColor: dialogBackground,
      
      textTheme: fontTheme.textTheme,
      fontFamily: fontTheme.fontBody,
      
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        backgroundColor: appBarBackground,
        foregroundColor: appBarForeground,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: tertiary.base,
        focusColor: tertiaryAccent,
        hoverColor: tertiaryAccent
      )
    ).withCodeTheme(
      fontTheme.codeTheme
    )
  );
}
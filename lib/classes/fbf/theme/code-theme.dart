import 'package:flutter/material.dart';

extension CodeThemeExtension on ThemeData {
  static CodeTheme _codeTheme;
  
  CodeTheme get codeTheme => _codeTheme ?? CodeTheme();
  set codeTheme(CodeTheme theme) => _codeTheme = theme;

  ThemeData withCodeTheme(CodeTheme codeTheme) {
    this.codeTheme = codeTheme;
    return this;
  }
}

class CodeTheme {
  CodeTheme({
    this.subtitle1,
    this.subtitle2,
    this.bodyText1,
    this.bodyText2
  });

  TextStyle subtitle1;
  TextStyle subtitle2;
  TextStyle bodyText1;
  TextStyle bodyText2;

  CodeTheme copyWith({
    TextStyle subtitle1,
    TextStyle subtitle2,
    TextStyle bodyText1,
    TextStyle bodyText2
  }) => CodeTheme(
    subtitle1: subtitle1 ?? this.subtitle1,
    subtitle2: subtitle2 ?? this.subtitle2,
    bodyText1: bodyText1 ?? this.bodyText1,
    bodyText2: bodyText2 ?? this.bodyText2
  );
}
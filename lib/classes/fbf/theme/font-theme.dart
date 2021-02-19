import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:klr/classes/range.dart';

typedef TextThemeBuilder = TextTheme Function(TextTheme);

class FivebyfiveFontTheme {
  FivebyfiveFontTheme(
    this.fontHeadings,
    this.fontBody, {
      double minFontSize = 10.5,
      double maxFontSize
  }) : minFontSize = minFontSize,
      maxFontSize = maxFontSize ?? (minFontSize * minFontSize);

  final String fontHeadings;
  final String fontBody;
  final double minFontSize;
  final double maxFontSize; 

  @protected
  NumRange _sizeRange;

  NumRange get fontSizeRange => _sizeRange ?? (
    _sizeRange = NumRange(
      min: minFontSize,
      max: maxFontSize
    ));

  double calcFontSize(double ratio) 
    => fontSizeRange.lerp(ratio);

  TextTheme _textTheme;
  TextStyle _lastStyle;

  TextStyle _style({
    String fontFamily,
    double fontRatio,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
  })
    => _lastStyle = (_lastStyle ?? TextStyle())
          .copyWith(
            fontFamily: fontFamily,
            fontSize:fontRatio != null 
              ? calcFontSize(fontRatio) 
              : fontSize,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            letterSpacing: letterSpacing
          );

  TextStyle heading({
    double fontRatio,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
  }) => _style(
    fontFamily: fontHeadings,
    fontRatio: fontRatio,
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    letterSpacing: letterSpacing
  );

  TextStyle body({
    double fontRatio,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
  }) => _style(
    fontRatio: fontRatio,
    fontFamily: fontBody,
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    letterSpacing: letterSpacing
  );

  TextTheme get textTheme => _textTheme ?? (_textTheme = _createTextTheme());

  @protected
  TextTheme _createTextTheme() =>
    TextTheme(
      headline1: heading(
        fontRatio: .95,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.italic,
      )
    ).copyWith(headline2: heading(fontRatio: .75)
    ).copyWith(headline3: heading(fontRatio: .45)
    ).copyWith(
      headline4: heading(fontRatio: 0.3,
        fontWeight: FontWeight.w800,
      )
    ).copyWith(headline5: heading(fontRatio: .2)
    ).copyWith(headline6: heading(fontRatio: .15)
    
    ).copyWith(
      subtitle1: body(
        fontRatio: .085,
        fontWeight: FontWeight.w800,
        fontStyle: FontStyle.normal
      )
    ).copyWith(subtitle2: body(fontRatio: .06)

    ).copyWith(
      bodyText1: body(
        fontRatio: .06,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal
      )
    ).copyWith(bodyText2: body(fontRatio: .045)
    ).copyWith(
      button: body(fontWeight: FontWeight.w500)
    ).copyWith(
      caption: body(
        fontRatio: .015,
        fontWeight: FontWeight.w400
      )
    ).copyWith(
      overline: body(
        fontRatio: 0,
        fontWeight: FontWeight.w100
      ),
  );
    
}


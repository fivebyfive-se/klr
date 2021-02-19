import 'package:flutter/material.dart';
import 'package:klr/klr.dart';

class Txt extends StatelessWidget {
  Txt(this.text, this.type, {TextStyle style})
    : style = style ?? TextStyle();

  final String text;
  final TxtType type;
  final TextStyle style;

  Txt.p(String text, {TextStyle style})
    : this(text, TxtType.paragraph, style: style);

  Txt.h1(String text, {TextStyle style})
    : this(text, TxtType.h1, style: style);

  Txt.h2(String text, {TextStyle style})
    : this(text, TxtType.h2, style: style);

  Txt.h3(String text, {TextStyle style})
    : this(text, TxtType.h3, style: style);

  Txt.h4(String text, {TextStyle style})
    : this(text, TxtType.h4, style: style);
  Txt.h5(String text, {TextStyle style})
    : this(text, TxtType.h5, style: style);
  Txt.h6(String text, {TextStyle style})
    : this(text, TxtType.h6, style: style);

  Txt.sub1(String text, {TextStyle style})
    : this(text, TxtType.sub1, style: style);
  Txt.sub2(String text, {TextStyle style})
    : this(text, TxtType.sub2, style: style);
  Txt.overline(String text, {TextStyle style})
    : this(text, TxtType.overline, style: style);  

  Txt.strong(String text, {TextStyle style})
    : this(text, TxtType.strong, style: style);

  Txt.em(String text, {TextStyle style})
    : this(text, TxtType.em, style: style);

  Txt.light(String text, {TextStyle style})
    : this(text, TxtType.light, style: style);

  // TextStyle get computedStyle 
  //   => typeToStyle(type).merge(style ?? TextStyle());

  @override
  Widget build(BuildContext context)
    => Text(text, style: typeToStyle(type).merge(style));
}

TextStyle typeToStyle(TxtType type) {
  final t = Klr.theme.fontTheme.textTheme;
  switch (type) {
    case TxtType.h6:
      return t.headline6;
    case TxtType.h5:
      return t.headline5;
    case TxtType.h4:
      return t.headline4;
    case TxtType.h3:
      return t.headline3;
    case TxtType.h2:
      return t.headline2;
    case TxtType.h1:
      return t.headline1;
    case TxtType.sub1:
      return t.subtitle1;
    case TxtType.sub2:
      return t.subtitle2;
    case TxtType.overline:
      return t.overline;
    case TxtType.strong:
      return t.bodyText1.copyWith(fontWeight: FontWeight.w600);
    case TxtType.em:
      return t.bodyText1.copyWith(fontStyle: FontStyle.italic);
    case TxtType.light:
      return t.bodyText1.copyWith(fontWeight: FontWeight.w100);
    case TxtType.paragraph:
    default:
      return t.bodyText1;
  }
}

enum TxtType {
  paragraph,
  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
  sub1,
  sub2,
  overline,
  strong,
  em,
  light
}
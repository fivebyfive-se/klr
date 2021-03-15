import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/klr.dart';

class RicherText extends StatelessWidget {
  const RicherText({
    Key key,
    this.text,
    this.baseStyle,
    this.linkStyle,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
  }) : super(key: key);

  factory RicherText.from(List<dynamic> list, {
    TextStyle baseStyle,
    TextStyle linkStyle,
    TextAlign textAlign = TextAlign.start,
    TextDirection textDirection = TextDirection.ltr,
    TextOverflow overflow = TextOverflow.clip,
    double textScaleFactor = 1.0,
    int maxLines,
    Locale locale,
    StrutStyle strutStyle,
    TextWidthBasis textWidthBasis = TextWidthBasis.parent,
    TextHeightBehavior textHeightBehavior,
    bool softWrap = true,
  })
    => RicherText(
        text: RicherTextList.parse(list),
        baseStyle: baseStyle,
        linkStyle: linkStyle,

        textAlign: textAlign,
        textDirection: textDirection,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        locale: locale,
        strutStyle: strutStyle,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        softWrap: softWrap,
      );

  final RicherTextList text;
  final TextStyle baseStyle;
  final TextStyle linkStyle;

  final TextAlign textAlign;
  final TextDirection textDirection;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int maxLines;
  final Locale locale;
  final StrutStyle strutStyle;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior textHeightBehavior;
  final bool softWrap;

  @override
  Widget build(BuildContext context) {
    final klr = KlrConfig.of(context);
    final defaultTextStyle = baseStyle ?? klr.textTheme.bodyText2;
    final linkTextStyle = linkStyle ?? (
      defaultTextStyle.withColor(klr.theme.primaryAccent)
    );
    
    return text.toRichText(
      defaultTextStyle,
      linkTextStyle,

      textAlign: textAlign,
      textDirection: textDirection,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      softWrap: softWrap,
    );
  }
}

class RicherTextList {
  const RicherTextList({this.items, this.style});

  factory RicherTextList.parse(List<dynamic> list, {TextStyle style}) {
    return RicherTextList(
      items: list.map((item) {
        if (item is String) {
          return RicherTextItem(item);
        } else if (item is List<dynamic>) {
          final String text = item.firstWhere(
            (it) => it is String,
            orElse: () => ""
          );
          final VoidCallback onTap = item.firstWhere(
            (it) => it is VoidCallback,
            orElse: () => null
          );
          final TextStyle spanStyle = item.firstWhere(
            (it) => it is TextStyle,
            orElse: () => null
          );
          return RicherTextItem(
            text, 
            onTap: onTap, 
            style: spanStyle
          );
        }
        return RicherTextItem("");
      }).toList(),
      style: style
    );
  }

  final List<RicherTextItem> items;
  final TextStyle style;

  RichText toRichText(
    TextStyle defaultTextStyle,
    TextStyle linkTextStyle, {
    TextAlign textAlign = TextAlign.start,
    TextDirection textDirection = TextDirection.ltr,
    TextOverflow overflow = TextOverflow.clip,
    double textScaleFactor = 1.0,
    int maxLines,
    Locale locale,
    StrutStyle strutStyle,
    TextWidthBasis textWidthBasis = TextWidthBasis.parent,
    TextHeightBehavior textHeightBehavior,
    bool softWrap,
  }) => RichText(
          textAlign: textAlign,
          textDirection: textDirection,
          overflow: overflow,
          textScaleFactor: textScaleFactor,
          maxLines: maxLines,
          locale: locale,
          strutStyle: strutStyle,
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
          softWrap: softWrap,

          text: TextSpan(
            children: items.map((i) => i.toSpan(linkTextStyle)).toList(),
            style: defaultTextStyle.merge(style)
          ),
        );
}

class RicherTextItem {
  const RicherTextItem(this.text, {this.onTap, this.style});

  final String text;
  final TextStyle style;
  final void Function() onTap;

  TextSpan toSpan(TextStyle linkTextStyle) => TextSpan(
    text: text,
    recognizer: onTap != null
      ? (TapGestureRecognizer()..onTap = onTap)
      : null,
    style: onTap != null
      ? linkTextStyle.merge(style)
      : style
  );
}
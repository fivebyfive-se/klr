import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:uuid/uuid.dart';

import 'package:klr/helpers/iterable.dart';

class OfficeTheme {
  OfficeTheme({
    this.name,
    OfficeColorScheme colorScheme,
    OfficeFontScheme fontScheme,
  }) :  this.colorScheme = colorScheme,
        this.fontScheme = fontScheme ?? OfficeFontScheme.defaultFontScheme,
        this.id = Uuid().v4(),
        this.vid = Uuid().v4();

  final String id;
  final String vid;
  final String name;
  final OfficeColorScheme colorScheme;
  final OfficeFontScheme fontScheme;
}

class OfficeColorScheme {
  OfficeColorScheme({
    this.name,
    this.colors,
  });

  final String name;
  final List<OfficeColor> colors;

  static OfficeColorScheme get defaultScheme =>
    OfficeColorScheme(
      name: 'KlrDefaultColors',
      colors: <OfficeColor>[
        OfficeColor.dark1(Colors.black),
        OfficeColor.light1(Colors.white),
        OfficeColor.dark2(Colors.black),
        OfficeColor.light2(Colors.white),
        OfficeColor.accent1(Colors.black),
        OfficeColor.accent2(Colors.black),
        OfficeColor.accent3(Colors.black),
        OfficeColor.accent4(Colors.black),
        OfficeColor.accent5(Colors.black),
        OfficeColor.accent6(Colors.black),
        OfficeColor.link(Colors.black),
        OfficeColor.linkFol(Colors.black),
      ]
    );


  static OfficeColorScheme automatic(String name, List<Color> sourceColors) {
    if (sourceColors.length < 2) {
      return null;
    }

    final sorted = sourceColors.schwartz(
      decorator: (c) => c.computeLuminance(),
      comparer: (a, b) => (a - b).round(),
    );


    final dark1  = sorted.removeAt(0);
    final light1 = sorted.removeLast();
    final dark2  = sorted.popOr(dark1);
    final light2 = sorted.unshiftOr(light1);

    final accent1 = sorted.popOr(dark2);
    final accent2 = sorted.popOr(accent1);
    final accent3 = sorted.popOr(accent2);
    final accent4 = sorted.popOr(accent3);
    final accent5 = sorted.popOr(accent4);
    final accent6 = sorted.popOr(accent5);
    final link = sorted.popOr(accent6);
    final linkFol = sorted.popOr(link);

    return OfficeColorScheme(
      name: name,
      colors: <OfficeColor>[
        OfficeColor.dark1(dark1),
        OfficeColor.light1(light1),
        OfficeColor.dark2(dark2),
        OfficeColor.light2(light2),
        OfficeColor.accent1(accent1),
        OfficeColor.accent2(accent2),
        OfficeColor.accent3(accent3),
        OfficeColor.accent4(accent4),
        OfficeColor.accent5(accent5),
        OfficeColor.accent6(accent6),
        OfficeColor.link(link),
        OfficeColor.linkFol(linkFol),
      ]
    );
  }
}

class OfficeColor {
  OfficeColor(
    this.name,
    this.color,
    [String friendlyName,]
  ) : this.friendlyName = friendlyName ?? name;
  
  final String name;
  final String friendlyName;
  final Color color;

  static const names = [
    'dk1',
    'lt1',
    'dk2',
    'lt2',
    'accent1',
    'accent2',
    'accent3',
    'accent4',
    'accent5',
    'accent6',
    'hlink',
    'folHlink',
  ];

  static OfficeColor dark1(Color color)
    => OfficeColor('dk1', color, 'Text background - dark 1');
  static OfficeColor light1(Color color)
    => OfficeColor('lt1', color, 'Text background - light 1');
  static OfficeColor dark2(Color color)
    => OfficeColor('dk2', color, 'Text background - dark 2');
  static OfficeColor light2(Color color)
    => OfficeColor('lt2', color, 'Text background - light 2');
  static OfficeColor accent1(Color color)
    => OfficeColor('accent1', color, 'Accent 1');
  static OfficeColor accent2(Color color)
    => OfficeColor('accent2', color, 'Accent 2');
  static OfficeColor accent3(Color color)
    => OfficeColor('accent3', color, 'Accent 3');
  static OfficeColor accent4(Color color)
    => OfficeColor('accent4', color, 'Accent 4');
  static OfficeColor accent5(Color color)
    => OfficeColor('accent5', color, 'Accent 5');
  static OfficeColor accent6(Color color)
    => OfficeColor('accent6', color, 'Accent 6');
  static OfficeColor link(Color color)
    => OfficeColor('hlink', color, 'Hyperlink');
  static OfficeColor linkFol(Color color)
    => OfficeColor('folHlink', color, 'Followed hyperlink');
}

class OfficeFontScheme {
  OfficeFontScheme({
    this.name,
    this.majorFont,
    this.minorFont
  });
  final String name;
  final String majorFont;
  final String minorFont;

  static OfficeFontScheme get defaultFontScheme
    => OfficeFontScheme(
      name: 'KlrDefaultFonts',
      majorFont: 'Arial Black',
      minorFont: 'Arial'
    );
}
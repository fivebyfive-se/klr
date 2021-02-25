import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:uuid/uuid.dart';

import 'package:fbf/dart_extensions.dart';

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
    OfficeColorScheme.fromColors(
      'KlrDefaultColors',
      <Color>[
        Colors.black,
        Colors.white,
        Colors.black,
        Colors.white,
        Colors.black,
        Colors.black,
        Colors.black,
        Colors.black,
        Colors.black,
        Colors.black,
        Colors.black,
        Colors.black,
      ]
    );


  static OfficeColorScheme fromColors(String name, List<Color> colors)
    =>  OfficeColorScheme(
      name: name,
      colors: colors.mapIndex<Color,OfficeColor>(
        (c, i) => OfficeColor(OfficeColors.nameByIndex(i), c)
      )
    );

  static OfficeColorScheme automatic(String name, List<Color> sourceColors) {
    if (sourceColors.length < 2) {
      return null;
    }

    final colorsByLuminance = sourceColors.schwartz(
      decorator: (c) => c.computeLuminance(),
      comparer: (a, b) => (a - b).round(),
    );

    final List<Color> sorted = []; 
    sorted.add(colorsByLuminance.removeFirst()); // dark1
    sorted.add(colorsByLuminance.removeLast());  // light1
    sorted.add(colorsByLuminance.removeFirst()); // dark2
    sorted.add(colorsByLuminance.removeLast());  // light2
    sorted.addAll(
      colorsByLuminance.extend<Color>(
        OfficeColors.numColors - sorted.length,
        colorsByLuminance.isEmpty ? sorted.first : colorsByLuminance.last
      )
    );

    return OfficeColorScheme.fromColors(name, sorted);
  }
}

class OfficeColors {
  static const String dark1 = 'dk1';
  static const String light1 = 'lt1';
  static const String dark2 = 'dk2';
  static const String light2 = 'lt2';
  static const String accent1 = 'accent1';
  static const String accent2 = 'accent2';
  static const String accent3 = 'accent3';
  static const String accent4 = 'accent4';
  static const String accent5 = 'accent5';
  static const String accent6 = 'accent6';
  static const String hlink = 'hlink';
  static const String folHlink = 'folHlink'; 

  static const List<String> names = [
    OfficeColors.dark1,
    OfficeColors.light1,
    OfficeColors.dark2,
    OfficeColors.light2,
    OfficeColors.accent1,
    OfficeColors.accent2,
    OfficeColors.accent3,
    OfficeColors.accent4,
    OfficeColors.accent5,
    OfficeColors.accent6,
    OfficeColors.hlink,
    OfficeColors.folHlink,
  ];

  static int get numColors => names.length;
  static String nameByIndex(int index) => names[index];
  static String friendlyNameByIndex(int index) 
    => friendly[names[index]];

  static const Map<String,String> friendly = {
    OfficeColors.dark1: 'Text background - dark 1',
    OfficeColors.light1: 'Text background - light 1',
    OfficeColors.dark2: 'Text background - dark 2',
    OfficeColors.light2: 'Text background - light 2',
    OfficeColors.accent1: 'Accent 1',
    OfficeColors.accent2: 'Accent 2',
    OfficeColors.accent3: 'Accent 3',
    OfficeColors.accent4: 'Accent 4',
    OfficeColors.accent5: 'Accent 5',
    OfficeColors.accent6: 'Accent 6',
    OfficeColors.hlink: 'Hyperlink',
    OfficeColors.folHlink: 'Followed hyperlink',
  };
 
}

class OfficeColor {
  OfficeColor(
    this.name,
    this.color,
    [String friendlyName,]
  ) : this.friendlyName = friendlyName ?? OfficeColors.friendly[name];

  final String name;
  final String friendlyName;
  final Color color;

  static OfficeColor dark1(Color color)
    => OfficeColor(OfficeColors.dark1, color);
  static OfficeColor light1(Color color)
    => OfficeColor(OfficeColors.light1, color);
  static OfficeColor dark2(Color color)
    => OfficeColor(OfficeColors.dark2, color);
  static OfficeColor light2(Color color)
    => OfficeColor(OfficeColors.light2, color);
  static OfficeColor accent1(Color color)
    => OfficeColor(OfficeColors.accent1, color);
  static OfficeColor accent2(Color color)
    => OfficeColor(OfficeColors.accent2, color);
  static OfficeColor accent3(Color color)
    => OfficeColor(OfficeColors.accent3, color);
  static OfficeColor accent4(Color color)
    => OfficeColor(OfficeColors.accent4, color);
  static OfficeColor accent5(Color color)
    => OfficeColor(OfficeColors.accent5, color);
  static OfficeColor accent6(Color color)
    => OfficeColor(OfficeColors.accent6, color);
  static OfficeColor hlink(Color color)
    => OfficeColor(OfficeColors.hlink, color);
  static OfficeColor folHlink(Color color)
    => OfficeColor(OfficeColors.folHlink, color);
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
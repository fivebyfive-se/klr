import 'package:fbf/flutter.dart';

import 'colors.dart';

class KlrFontTheme extends FbfFontTheme {
  static const fontSans  = 'BeVietnam';
  static const fontSerif = 'BodoniModa';
  static const fontMono  = 'SpaceMono';

  static KlrColors get klrs => KlrColors.getInstance(); 

  KlrFontTheme() : super(
    fontSerif, fontSans, fontMono,
    minFontSize: 10.0,
    textColor: klrs.grey95
  //maxFontSize: Klr.sizeBase * Klr.sizeBase
  );
}
import 'package:klr/app/klr.dart';
import 'package:klr/classes/fbf.dart';

class KlrFontTheme extends FivebyfiveFontTheme {
  static const fontSans  = 'BeVietnam';
  static const fontSerif = 'BodoniModa';
  static const fontMono  = 'SpaceMono';

  KlrFontTheme() : super(fontSerif, fontSans, fontMono,
    minFontSize: Klr.sizeBase,
  //maxFontSize: Klr.sizeBase * Klr.sizeBase
  );
}
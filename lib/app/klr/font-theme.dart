import 'package:klr/app/klr.dart';
import 'package:klr/classes/fbf.dart';

class KlrFontTheme extends FivebyfiveFontTheme {
  static const fontSans  = 'BeVietnam';
  static const fontSerif = 'BodoniModa';
  static const fontMono  = 'SpaceMono';

  KlrFontTheme() : super(
    fontSerif, fontSans, fontMono,
    minFontSize: Klr.baseFontSize,
    textColor: Klr.colors.grey95
  //maxFontSize: Klr.sizeBase * Klr.sizeBase
  );
}
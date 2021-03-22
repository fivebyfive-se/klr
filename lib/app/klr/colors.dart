import 'dart:ui';

import 'package:fbf/fbf.dart';

class KlrColors {
  Color grey05 = Color(0xff0D0B0A);
  Color grey10 = Color(0xff1A1715);
  Color grey14 = Color(0xff24201D);
  Color grey17 = Color(0xff2B2824);
  Color grey20 = Color(0xff332D29);
  Color grey25 = Color(0xff3B3632);
  Color grey35 = Color(0xff59524C);
  Color grey40 = Color(0xff665A53);
  Color grey50 = Color(0xff7D736A);
  Color grey60 = Color(0xff99887C);
  Color grey70 = Color(0xffB39F91);
  Color grey80 = Color(0xffCCB5A5);
  Color grey95 = Color(0xffF2D7C4);
  Color grey99 = Color(0xffFFE9D9);

  Color bamboo30 = Color(0xff4D3926);
  Color bamboo40 = Color(0xff664D33);
  Color bamboo50 = Color(0xff806040);
  Color bamboo60 = Color(0xff99734D);
  Color bamboo70 = Color(0xffB38659);
  Color bamboo80 = Color(0xffCC9966);
  Color bamboo90 = Color(0xffE6B27E);
  Color bamboo99 = Color(0xffFCCA97);

  Color yellow50 = Color(0xff80630D);
  Color yellow60 = Color(0xff99770F);
  Color yellow70 = Color(0xffB38A12);
  Color yellow80 = Color(0xffCC9E14);
  Color yellow90 = Color(0xffE6B217);

  Color steel15 = Color(0xff1B1E26);
  Color steel20 = Color(0xff242833);  
  Color steel25 = Color(0xff2D3240);
  Color steel30 = Color(0xff383F4D);
  Color steel35 = Color(0xff3E4759);
  Color steel40 = Color(0xff475266);
  Color steel45 = Color(0xff505C73);
  Color steel50 = Color(0xff596680);
  Color steel60 = Color(0xff737F99);
  Color steel70 = Color(0xff8695B3);
  Color steel80 = Color(0xff99AACC);
  Color steel90 = Color(0xffACBFE6);
  Color steel95 = Color(0xffC2D2F2);

  Color teal20 = Color(0xff0A3329);
  Color teal30 = Color(0xff0F4D3D);
  Color teal40 = Color(0xff146652);
  Color teal55 = Color(0xff1C8C70);
  Color teal70 = Color(0xff24B38F);

  Color orange40 = Color(0xff663E0F);
  Color orange50 = Color(0xff805019);
  Color orange60 = Color(0xff99590F);
  Color orange70 = Color(0xffB36812);
  Color orange80 = Color(0xffCC7614);
  Color orange90 = Color(0xffE6902E);
  Color orange95 = Color(0xffF29D3D);
  Color orange99 = Color(0xffFCAA4C);
// orange/red #BC5E55 / D97E16
// red/orange #E5173B

  Color pink20 = Color(0xff33002A);
  Color pink30 = Color(0xff4D0040);
  Color pink40 = Color(0xff660055);
  Color pink55 = Color(0xff8C0075);
  Color pink70 = Color(0xffB30095);
  Color pink80 = Color(0xffCC29B1);
  Color pink90 = Color(0xffE645CB);
  Color pink95 = Color(0xffF261DA);
  Color pink99 = Color(0xffFF80EA);

  Color purple45 = Color(0xff371773);
  Color purple60 = Color(0xff3F0F99);
  Color purple70 = Color(0xff4A12B3);
  Color purple80 = Color(0xff6229CC);
  Color purple90 = Color(0xff7641D9);
  Color purple95 = Color(0xff8C55F2);
  Color purple99 = Color(0xff9A65FC);

  Color blue20 = Color(0xff002233);
  Color blue30 = Color(0xff00334D);
  Color blue40 = Color(0xff004466);
  Color blue50 = Color(0xff005580); 
  Color blue65 = Color(0xff0871A6);
  Color blue70 = Color(0xff127DB3);
  Color blue80 = Color(0xff2996CC);
  Color blue90 = Color(0xff45B0E6);
  Color blue95 = Color(0xff55BEF2);
  Color blue99 = Color(0xff66CCFF);

  Color green15 = Color(0xff062600);
  Color green25 = Color(0xff0B4000);
  Color green35 = Color(0xff0F5900);
  Color green50 = Color(0xff158000);
  Color green60 = Color(0xff209908);
  Color green70 = Color(0xff2DB312);
  Color green80 = Color(0xff3BCC1F);
  Color green90 = Color(0xff4CE62E);
  Color green95 = Color(0xff5BF23D);
  Color green99 = Color(0xff69FC4C);

  Color red40 = Color(0xff660A34);
  Color red50 = Color(0xff801344);
  Color red60 = Color(0xff991751);
  Color red70 = Color(0xffB3366E);
  Color red80 = Color(0xffCC3D7D);
  Color red90 = Color(0xffE65093);
  Color red95 = Color(0xffF2559C);
  Color red99 = Color(0xffFF66AB);

  static KlrColors _instance;

  static KlrColors getInstance() => _instance ?? (_instance = KlrColors());
}

class KlrAltColors {
  Color lighterGreen = Color(0xff4aada3).deltaLightness(10);
  Color lightGreen = Color(0xff4aada3).deltaLightness(6);
  Color green = Color(0xff4aada3);
  Color darkGreen = Color(0xff4aada3).deltaLightness(-6);
  Color darkerGreen = Color(0xff4aada3).deltaLightness(-10);

  Color lightestYellow = Color(0xffd4c959).deltaLightness(18); 
  Color lighterYellow = Color(0xffd4c959).deltaLightness(12);
  Color lightYellow = Color(0xffd4c959).deltaLightness(6);
  Color yellow = Color(0xffd4c959);
  Color darkYellow = Color(0xffd4c959).deltaLightness(-6);
  Color darkerYellow = Color(0xffd4c959).deltaLightness(-12);

  Color lighterOrange = Color(0xffCC613D).deltaLightness(16);
  Color lightOrange = Color(0xffCC613D).deltaLightness(8);
  Color orange = Color(0xffCC613D);
  Color darkOrange = Color(0xffCC613D).deltaLightness(-8);
  Color darkerOrange = Color(0xffCC613D).deltaLightness(-16);

  Color lighterRed = Color(0xffD9364D).deltaLightness(16);
  Color lightRed = Color(0xffD9364D).deltaLightness(8);
  Color red = Color(0xffD9364D);
  Color darkRed = Color(0xffD9364D).deltaLightness(-8);
  Color darkerRed = Color(0xffD9364D).deltaLightness(-16);
  
  Color lighterPink = Color(0xffea52ce).deltaLightness(16);
  Color lightPink = Color(0xffea52ce).deltaLightness(8);
  Color pink = Color(0xffea52ce);
  Color darkPink = Color(0xffea52ce).deltaLightness(-8);
  Color darkerPink = Color(0xffea52ce).deltaLightness(-16);

  Color lighterViolet = Color(0xff8C45B0).deltaLightness(16);
  Color lightViolet = Color(0xff8C45B0).deltaLightness(8);
  Color violet = Color(0xff8C45B0);
  Color darkViolet = Color(0xff8C45B0).deltaLightness(-8);
  Color darkerViolet = Color(0xff8C45B0).deltaLightness(-16);


  Color lighterBlue = Color(0xff4997ce).deltaLightness(10);
  Color lightBlue = Color(0xff4997ce).deltaLightness(6);
  Color blue = Color(0xff4997ce);
  Color darkBlue = Color(0xff4997ce).deltaLightness(-6);
  Color darkerBlue = Color(0xff4997ce).deltaLightness(-10);

  Color lightestGrey = Color(0xffc9c9c9);
  Color lighterGrey = Color(0xffaaaaaa);
  Color lightGrey = Color(0xff8f8f8f);
  Color grey = Color(0xff767676);
  Color darkGrey = Color(0xff555555);
  Color darkerGrey = Color(0xff404040);
  Color darkestGrey = Color(0xff2f2f2f);

  static KlrAltColors _instance;

  static KlrAltColors getInstance() => _instance ?? (_instance = KlrAltColors());
}

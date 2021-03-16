import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  Logo({
    @required this.logo
  }) : assert(logo != null, '{logo} must be set!');

  final Logos logo;
  
  @override
  Widget build(BuildContext context) {
    try {
      return Image(
        image: logoProvider(logo: logo),
        filterQuality: FilterQuality.high,
      );
    } catch (e) {
      print(e);
    }
    return Placeholder();
  }
}

AssetImage logoProvider({Logos logo})
  => AssetImage(
    (() {
      switch (logo) {
        case Logos.logo:
          return "images/logo.png";
        case Logos.logoElevated:
          return "images/logo_e.png";
        case Logos.logoBorder:
          return "images/logo_eb.png";
        case Logos.logoBackdrop:
          return "images/logo_ebb.png";

        case Logos.fivebyfive:
          return "images/fivebyfive.png";
      }
    })()
  );

enum Logos {
  logo,
  logoElevated,
  logoBorder,
  logoBackdrop,
  fivebyfive
}
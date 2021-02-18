import 'package:flutter/material.dart';
import 'package:klr/classes/fbf/routing/sub-page-route.dart';
import 'package:klr/views/base/page-arguments.dart';
import 'package:klr/views/views.dart';
import 'package:klr/widgets/txt.dart';

class PaletteSubPage extends SubPageBase {
  static const String routeName = 'palette';
  static const String routeLabel = 'Palette';
  static const IconData routeIcon = Icons.palette_outlined;
  static const IconData routeActiveIcon = Icons.palette;
  
  static FbfSubPageRoute routeDefinition = FbfSubPageRoute(
    routeName: routeName,
    label: routeLabel,
    icon: routeIcon,
    activeIcon: routeActiveIcon,
    builder: (_) => PaletteSubPage()
  );

  PaletteSubPage(): super(routeName);

  @override
  _PaletteSubPageState createState()
    => _PaletteSubPageState();
}

class _PaletteSubPageState extends State<PaletteSubPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Txt.h2(PaletteSubPage.routeLabel)
      ],
    );
  }
}

class PaletteConfig extends PageConfig<PaletteArguments> {}
class PaletteArguments extends PageArguments {}

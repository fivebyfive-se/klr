import 'package:flutter/material.dart';
import 'package:klr/classes/fbf/routing/_page-route-base.dart';

typedef SubPageBuilder = 
Widget Function(
    BuildContext context,
    FbfSubPageRoute routeData
);

class FbfSubPageRoute extends FbfPageRouteBase {
  FbfSubPageRoute({
    String routeName,
    WidgetBuilder builder,
    this.icon,
    this.label,
    this.isAvailable = true,
    IconData activeIcon,
  }) :  activeIcon = activeIcon ?? icon,
        super(routeName, builder);

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isAvailable;
}
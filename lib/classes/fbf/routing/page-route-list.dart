import 'package:flutter/material.dart';

import 'page-route.dart';

class FbfPageRouteList {
  FbfPageRouteList(this.pageRoutes);

  final List<FbfPageRoute> pageRoutes;

  int 
  get numRoutes => pageRoutes.length;

  FbfPageRoute routeAt(int index) 
    => index >= 0 && index < numRoutes ? pageRoutes[index] : null;

  FbfPageRoute routeByName(String routeName)
    => routeExists(routeName) ? routeAt(indexOf(routeName)) : null;

  bool routeExists(String routeName) => indexOf(routeName) >= 0;

  int indexOf(String routeName)
    => pageRoutes.indexWhere((r) => r.routeName == routeName);

  String
  get initialRoute => pageRoutes.first.routeName;

  Map<String, WidgetBuilder>
  get routes => Map.fromEntries(pageRoutes.map((r) => r.toEntry()));

  FbfPageRoute nextRoute(String routeName) {
    final idx = indexOf(routeName);
    return (idx >= 0 && idx + 1 < numRoutes)
      ? pageRoutes[idx + 1] 
      : null;
  }
}

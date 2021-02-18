import 'package:flutter/material.dart';
import 'package:klr/classes/fbf/routing/_page-route-base.dart';
import 'package:klr/views/base/_page-base.dart';

import 'sub-page-route.dart';

class FbfPageRoute extends FbfPageRouteBase {
  FbfPageRoute({
    String routeName,
    WidgetBuilder builder,
    Iterable<FbfSubPageRoute> children,
  }) :  children = children ?? [],
        super(routeName, builder);

  final  Iterable<FbfSubPageRoute> children;

  static FbfPageRoute fromPage<T extends PageBase>(T page)
    => FbfPageRoute(routeName: page.pageRoute, builder: (context) => page);
}
import 'package:flutter/material.dart';
import 'package:klr/classes/fbf/routing/_page-route-base.dart';
import 'package:klr/views/base/_page-base.dart';

class FbfPageRoute extends FbfPageRouteBase {
  FbfPageRoute({
    String routeName,
    this.builder,
  }) :  super(routeName);

  final WidgetBuilder builder;

  MapEntry<String, WidgetBuilder> toEntry()
    => MapEntry(routeName, builder);

  static FbfPageRoute fromPage<T extends PageBase>(T page)
    => FbfPageRoute(routeName: page.pageRoute, builder: (context) => page);
}
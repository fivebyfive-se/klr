import 'package:flutter/material.dart';

abstract class FbfPageRouteBase {
  FbfPageRouteBase(this.routeName, this.builder);

  final String routeName;
  final WidgetBuilder builder;

  MapEntry<String, WidgetBuilder> toEntry()
    => MapEntry(routeName, builder);
}

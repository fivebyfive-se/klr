import 'package:flutter/material.dart';

class PageArguments {
  PageArguments({this.title});

  final String title;

  static T of<T extends PageArguments>(BuildContext context)
    => ModalRoute.of(context).settings.arguments as T;
}
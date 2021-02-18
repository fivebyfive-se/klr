import 'package:flutter/material.dart';
import 'package:klr/views/base/page-arguments.dart';
import 'package:klr/views/views.dart';

Widget scaffoldFab<C extends PageConfig,A extends PageArguments>(
  BuildContext context,
  C config,
  A arguments
) {
  return (config is PageConfig_ScaffoldFloatingButton)
      ? FloatingActionButton(
          onPressed: config.fabOnPressed,
          child: Icon(config.fabIcon),          
        )
      : null;
}
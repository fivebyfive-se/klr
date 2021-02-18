import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klr/views/base/page-arguments.dart';
import 'package:klr/views/views.dart';
import 'package:klr/widgets/bottom-navigation.dart';

Widget scaffoldBottomNavigation<C extends PageConfig, A extends PageArguments>(
  BuildContext context,
  C config,
  A arguments
) {
  return (config is PageConfig_HasSubPages) 
    ? BottomAppBar(
        child: BottomNavigation(config.navigationConfig)
    )
    : null;
}
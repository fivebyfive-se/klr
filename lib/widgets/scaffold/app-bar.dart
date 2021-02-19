import 'package:flutter/material.dart';
import 'package:klr/klr.dart';
import 'package:klr/views/base/page-arguments.dart';

import 'package:klr/views/views.dart';

AppBar scaffoldAppBar<C extends PageConfig, A extends PageArguments>(
  BuildContext context,
  C config,
  A arguments
) => (config is PageConfig_ScaffoldShowAppBar) 
      ? AppBar(
          iconTheme: IconThemeData(
            color: Klr.colors.bamboo99,
            opacity: 1.0,
          ),
          title: Text(
            "${Klr.appTitle} ${config.pageTitle}",
            style: Klr.textTheme.headline5
              .copyWith(
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                color: Klr.theme.appBarForeground
              )
          ),
          bottomOpacity: 0.5,
      )
      : null;
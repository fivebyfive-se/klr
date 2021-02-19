import 'package:flutter/material.dart';

import 'package:klr/klr.dart';
import 'package:klr/helpers/size-helpers.dart';
import 'package:klr/views/base/page-arguments.dart';

import 'package:klr/views/views.dart';
import 'package:klr/widgets/scaffold/bottom-nav.dart';
import 'package:klr/widgets/scaffold/fab.dart';

import './app-bar.dart';
import './drawer.dart';

Widget scaffoldPage<C extends PageConfig,A extends PageArguments>(
  BuildContext context,
  C config,
  A arguments,
  PageConfigBuilder<C,A> builder
) {
  final callBuilder = () => builder.call(context, config, arguments);

  if (config is PageConfig_ScaffoldOff) {
    return callBuilder();
  }

  final viewportSize = MediaQuery.of(context).size;
  final appBar = scaffoldAppBar(context, config, arguments);
  final navBar = scaffoldBottomNavigation<C,A>(context, config, arguments);
  final fab = scaffoldFab<C,A>(context, config, arguments);
  final drawer = scaffoldDrawer<C,A>(context, config, arguments);
  return Scaffold(
    backgroundColor: Klr.theme.background,

    appBar: appBar,

    bottomNavigationBar: navBar,

    floatingActionButton: fab,
    floatingActionButtonLocation: 
    (config is PageConfig_ScaffoldShowNavigation)
      ? FloatingActionButtonLocation.miniCenterDocked
      : FloatingActionButtonLocation.centerDocked,

    drawer: drawer,

    body: (config is PageConfig_ScaffoldNoContainer) 
      ? callBuilder() 
      : Container(
          width: viewportSize.width,
          height: viewportSize.height - appBar.preferredSize.height,
          padding: padding(horizontal: 1, vertical: 1),
          decoration: BoxDecoration(
            gradient: Klr.theme.backgroundGradient
          ),
          child: callBuilder()
        ),
  
  );
}

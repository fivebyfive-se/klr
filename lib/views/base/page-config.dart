
import 'package:flutter/material.dart';
import 'package:klr/app/klr.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/widgets/bottom-navigation.dart';
import 'package:klr/widgets/bottom-sheet-menu.dart';

import 'page-arguments.dart';

typedef PageConfigBuilder<P extends PageConfig,A extends PageArguments> 
  = Widget Function(BuildContext context, P config, A arguments);

abstract class PageConfig<A extends PageArguments> {}

/*
 * Mixins:
 */
mixin PageConfig_ScaffoldShowNavigation<A extends PageArguments>
  on PageConfig<A> {
    AppState appStateSnapshot;
  }

mixin PageConfig_ScaffoldShowAppBar<A extends PageArguments>
  on PageConfig<A> {
    String pageTitle;
  }

mixin PageConfig_ScaffoldHideAppBar<A extends PageArguments> 
  on PageConfig<A> {}

mixin PageConfig_ScaffoldHideDrawer<A extends PageArguments> 
  on PageConfig<A> {}

mixin PageConfig_ScaffoldNoContainer<A extends PageArguments>
  on PageConfig<A> {}

mixin PageConfig_ScaffoldOff<A extends PageArguments> 
  on PageConfig<A> {}

mixin PageConfig_ScaffoldShowFabMenu<A extends PageArguments>
  on PageConfig<A> {
  Color fabBackgroundColor;
  Color fabIconColor;
  List<BottomSheetMenuItem<String>> fabMenuItems;
  void Function(String) fabOnSelect;
  String fabTitle;
  IconData fabTitleIcon;
}

class DefaultPageConfig<A extends PageArguments> extends PageConfig<A> 
                         with PageConfig_ScaffoldShowAppBar<A>,
                              PageConfig_ScaffoldShowFabMenu<A>, 
                              PageConfig_ScaffoldShowNavigation<A>
{
  DefaultPageConfig({
    this.pageTitle,
    this.fabTitle,
    this.fabBackgroundColor,
    this.fabIconColor,
    this.fabTitleIcon,
    this.appStateSnapshot,
    this.fabMenuItems,
    this.fabOnSelect,
  });

  final AppState appStateSnapshot;
  final List<BottomSheetMenuItem<String>> fabMenuItems;
  final void Function(String) fabOnSelect;

  final String pageTitle;
  final String fabTitle;
  
  final Color fabBackgroundColor;
  final Color fabIconColor;
  final IconData fabTitleIcon;
}


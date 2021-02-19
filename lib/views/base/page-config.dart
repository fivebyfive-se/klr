
import 'package:flutter/material.dart';
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


mixin PageConfig_ScaffoldHideAppBar<A extends PageArguments> 
  on PageConfig<A> {}

mixin PageConfig_ScaffoldHideDrawer<A extends PageArguments> 
  on PageConfig<A> {}

mixin PageConfig_ScaffoldNoContainer<A extends PageArguments>
  on PageConfig<A> {}

mixin PageConfig_ScaffoldOff<A extends PageArguments> 
  on PageConfig<A> {}

mixin PageConfig_ScaffoldHasFabMenu<A extends PageArguments>
  on PageConfig<A> {
  Color fabBackgroundColor;
  Color fabIconColor;
  List<BottomSheetMenuItem<String>> fabMenuItems;
  void Function(String) fabOnSelect;
  String fabTitle;
  IconData fabTitleIcon;
}


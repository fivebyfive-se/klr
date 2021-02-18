import 'package:flutter/material.dart';

import '../page-config.dart';

mixin PageConfig_ScaffoldHideAppBar  on PageConfig {}
mixin PageConfig_ScaffoldHideDrawer  on PageConfig {}
mixin PageConfig_ScaffoldNoContainer on PageConfig {}
mixin PageConfig_ScaffoldOff  on PageConfig {}

mixin PageConfig_ScaffoldFloatingButton on PageConfig {
  IconData fabIcon;
  Function fabOnPressed;
}

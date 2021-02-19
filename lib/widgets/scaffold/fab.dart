import 'package:flutter/material.dart';
import 'package:klr/views/base/page-arguments.dart';
import 'package:klr/views/views.dart';
import 'package:klr/widgets/bottom-sheet-menu.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:klr/helpers/color.dart';

Widget scaffoldFab<C extends PageConfig,A extends PageArguments>(
  BuildContext context,
  C config,
  A arguments
) {
  
  return (config is PageConfig_ScaffoldHasFabMenu)
      ? FloatingActionButton(
          backgroundColor: config.fabBackgroundColor,
          hoverColor: config.fabBackgroundColor.deltaLightness(-10),
          focusColor: config.fabBackgroundColor.deltaLightness(-10),
          onPressed: () {
            BottomSheetMenu.showBottomSheet<String>(
              context: context,
              items: config.fabMenuItems,
              title: config.fabTitle,
              titleIcon: Icon(config.fabTitleIcon, color: config.fabIconColor),
              titleColor: config.fabIconColor,
              titleBackgroundColor: config.fabBackgroundColor,
              onSelect: (v) {
                config.fabOnSelect?.call(v);
              }
            );
          },
          child: Icon(
            LineAwesomeIcons.angle_double_up,
            color: config.fabIconColor
          ),  
        )
      : null;
}
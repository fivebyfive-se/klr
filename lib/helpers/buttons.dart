import 'package:flutter/material.dart';
import 'package:klr/klr.dart';
import 'package:klr/helpers/size-helpers.dart';

import 'package:klr/widgets/txt.dart';

Widget btnLabel({
  String label,
  Color labelColor
}) => Txt.p(
  label, 
  style: TextStyle(color: labelColor)
);

Widget btnLabelIcon({
  Color backgroundColor,
  String label,
  Color labelColor,
  IconData icon,
  Color iconColor,
  EdgeInsetsGeometry padding,
  void Function() onPressed
}) {
  labelColor = labelColor ?? Klr.theme.foreground;

  return FlatButton.icon(
    color: backgroundColor ?? Klr.theme.primary.base,
    icon: Icon(icon, color: iconColor ?? labelColor),
    label: btnLabel(label: label, labelColor: labelColor),
    onPressed: onPressed,
    padding: padding
  );
}

Widget btnIcon({
  IconData icon,
  void Function() onPressed,
  Color color
}) => IconButton(
  icon: Icon(icon, color: color ?? Klr.theme.primary.light),
  onPressed: onPressed
);

Widget btnDialog({
  String label,
  IconData icon,
  void Function() onPressed,
  Color color,
  Color foregroundColor
})
  => btnLabelIcon(
    backgroundColor: color ?? Klr.theme.primary.light,
    icon: icon,
    iconColor: foregroundColor ?? Klr.theme.background,
    label: label,
    labelColor: foregroundColor ?? Klr.theme.background,
    onPressed: onPressed,
    padding: padding(horizontal: 2, vertical: 1),
  );
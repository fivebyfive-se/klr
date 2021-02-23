import 'package:flutter/material.dart';
import 'package:klr/klr.dart';
import 'package:klr/helpers/color.dart';

import 'btn.dart';
import 'txt.dart';

Widget listTile({
  IconData icon,
  String title,
  String subtitle = '',
  Function() onTap,
  Color foreground,
  Color background
}) => ListTile(
    leading: Icon(
      icon,
      color: foreground
    ),
    title: Text(title),
    subtitle: Text(subtitle),
    onTap: onTap,
    tileColor: background,
  );

Widget titleTile({IconData icon, String title, String subtitle})
=> ListTile(
    leading: icon == null ? null : Icon(icon),
    title: Txt.subtitle1(title),
    subtitle: Text(subtitle ?? ''),
    tileColor: Klr.theme.dialogBackground,
  );

Widget actionTile({
  IconData icon,
  String title,
  String subtitle = '',
  Function() onTap,
}) => listTile(
  icon: icon,
  title: title,
  subtitle: subtitle,
  onTap: onTap,
  foreground: colorAction(),
  background: Klr.theme.cardBackground
);

Widget infoTile({
  IconData icon,
  String title,
  String subtitle = '',
  Function() onTap,
}) => listTile(
  icon: icon,
  title: title,
  subtitle: subtitle,
  onTap: onTap,
  foreground: colorInfo(),
  background: Klr.theme.cardBackground
);

Widget removeTile({
  IconData icon,
  String title,
  String subtitle = '',
  Function() onTap,
}) => listTile(
  icon: icon,
  title: title,
  subtitle: subtitle,
  onTap: onTap,
  foreground: colorRemove(),
  background: Klr.theme.cardBackground
);

Widget choiceTile({
  IconData icon,
  String title,
  String subtitle = '',
  Function() onTap,
  bool selected
}) => listTile(
    icon: icon,
    title: title,
    subtitle: subtitle,
    onTap: onTap,

    background: selected 
        ? colorChoice(darker: true)
        : Klr.theme.cardBackground
  );

Widget checkboxTile({
  IconData icon,
  String title,
  String subtitle = '',
  bool value,
  Function(bool) onChange,
}) => CheckboxListTile(
    value: value,
    onChanged: onChange,
    title: Text(title),
    subtitle: Text(subtitle),
    controlAffinity: ListTileControlAffinity.leading,
    activeColor: colorChoice(),
    tileColor: Klr.theme.cardBackground,
    selectedTileColor: Klr.theme.cardBackground.deltaLightness(20),
  );
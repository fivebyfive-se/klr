import 'package:flutter/material.dart';
import 'package:klr/klr.dart';
import 'package:klr/widgets/txt.dart';

Widget btnAction(String label, {
  Function() onPressed, TextStyle style
}) => btn(label,
  onPressed: onPressed,
  style: style,
  backgroundColor: colorAction(darker: true)
);
Widget btnChoice(String label, {
  Function() onPressed, TextStyle style
}) => btn(label,
  onPressed: onPressed,
  style: style,
  backgroundColor: colorChoice(darker: true)
);
Widget btnRemove(String label, {
  Function() onPressed, TextStyle style
}) => btn(label,
  onPressed: onPressed,
  style: style,
  backgroundColor: colorRemove(darker: true)
);

ButtonStyle btnStyle({Color backgroundColor}) 
  => ButtonStyle(
  padding: MaterialStateProperty.all(
    EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0)
  ),
  backgroundColor: MaterialStateProperty.all(
    backgroundColor ?? Klr.theme.primaryAccent
  ),
  minimumSize: MaterialStateProperty.all(Size(100.0, 30.0)),
);

Widget btn(String label, {
  Function() onPressed,
  Color backgroundColor,
  TextStyle style
}) 
  => ElevatedButton(
    style: btnStyle(backgroundColor: backgroundColor),
    child: Text(label, style: Txt.typeStyle(TxtType.subtitle3).merge(style)),
    onPressed: onPressed,
  );

Widget btnIcon(String label, {
  IconData icon,
  Function() onPressed,
  Color backgroundColor,
  TextStyle style
}) => ElevatedButton.icon(
  style: btnStyle(backgroundColor: backgroundColor),
  onPressed: onPressed,
  icon: Icon(icon),
  label: Text(label, style: Txt.typeStyle(TxtType.subtitle3).merge(style)),
);

TextStyle styleColorAction() 
  => TextStyle(color: colorAction());
TextStyle styleColorActionDarker()
  => TextStyle(color: colorAction(darker: true));

Color colorAction({bool darker = false})
  => darker ? Klr.theme.primary.base : Klr.theme.primaryAccent;

TextStyle styleColorChoice() 
  => TextStyle(color: colorChoice());
TextStyle styleColorChoiceDarker()
  => TextStyle(color: colorChoice(darker: true));

Color colorChoice({bool darker = false})
  => darker ? Klr.theme.secondary.base : Klr.theme.secondaryAccent;

TextStyle styleColorRemove() 
  => TextStyle(color: colorRemove());
TextStyle styleColorRemoveDarker()
  => TextStyle(color: colorRemove(darker: true));

Color colorRemove({bool darker = false})
  => darker ? Klr.theme.tertiary.base : Klr.theme.tertiaryAccent;

TextStyle styleColorInfo() 
  => TextStyle(color: colorInfo());
TextStyle styleColorInfoDarker()
  => TextStyle(color: colorInfo(darker: true));

Color colorInfo({bool darker = false})
  => darker ? Klr.theme.highlight.base : Klr.theme.highlightAccent;

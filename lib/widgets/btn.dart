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

ButtonStyle btnStyle({
  Color backgroundColor,
  Color borderColor,
  double baseSize = 2.0,
  double width,
  double height 
}) 
  => ButtonStyle(
  padding: MaterialStateProperty.all(
    Klr.edge.xy(baseSize, baseSize / 2)
  ),
  side: MaterialStateProperty.all(
    BorderSide(color: borderColor ?? backgroundColor, width: Klr.baseBorderSize)
  ),
  backgroundColor: MaterialStateProperty.all(
    backgroundColor ?? Klr.theme.primaryAccent
  ),
  
  minimumSize: MaterialStateProperty.all(
    Size(width ?? 200, height ?? 50)
  ),
);

Widget btn(String label, {
  Function() onPressed,
  Color backgroundColor,
  Color borderColor,
  double baseSize = 2.0,
  TextStyle style,
  double width,
  double height
}) 
  => ElevatedButton(
    style: btnStyle(
      backgroundColor: backgroundColor, 
      borderColor: borderColor, 
      baseSize: baseSize,
      width: width,
      height: height
    ),
    child: Text(label, style: Txt.typeStyle(TxtType.subtitle3).merge(style)),
    onPressed: onPressed,
  );

Widget btnIcon(String label, {
  IconData icon,
  Function() onPressed,
  Color backgroundColor,
  Color borderColor,
  Color iconColor,
  TextStyle style,
  double baseSize = 2.0,
}) => ElevatedButton.icon(
  style: btnStyle(
    backgroundColor: backgroundColor,
    baseSize: baseSize,
    borderColor: borderColor
  ),
  onPressed: onPressed,
  icon: Icon(icon, size: Klr.size(2 * baseSize), color: iconColor),
  label: Text(
    label, 
    style: Txt.typeStyle(TxtType.subtitle3).merge(style)
  ),
);

TextStyle styleColorAction() 
  => TextStyle(color: colorAction());
TextStyle styleColorActionDarker()
  => TextStyle(color: colorAction(darker: true));

Color colorAction({bool darker = false})
  => darker ? Klr.theme.primary : Klr.theme.primaryAccent;

TextStyle styleColorChoice() 
  => TextStyle(color: colorChoice());
TextStyle styleColorChoiceDarker()
  => TextStyle(color: colorChoice(darker: true));

Color colorChoice({bool darker = false})
  => darker ? Klr.theme.secondary : Klr.theme.secondaryAccent;

TextStyle styleColorRemove() 
  => TextStyle(color: colorRemove());
TextStyle styleColorRemoveDarker()
  => TextStyle(color: colorRemove(darker: true));

Color colorRemove({bool darker = false})
  => darker ? Klr.theme.tertiary : Klr.theme.tertiaryAccent;

TextStyle styleColorInfo() 
  => TextStyle(color: colorInfo());
TextStyle styleColorInfoDarker()
  => TextStyle(color: colorInfo(darker: true));

Color colorInfo({bool darker = false})
  => darker ? Klr.theme.highlight : Klr.theme.highlightAccent;

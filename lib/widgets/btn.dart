import 'package:flutter/material.dart';
import 'package:klr/klr.dart';
import 'package:klr/widgets/txt.dart';

Widget btn(String label, {
  Function() onPressed,
  Color backgroundColor,
  TextStyle style
}) 
  => ElevatedButton(
    style: ButtonStyle(
      padding: MaterialStateProperty.all(
        EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0)
      ),
      backgroundColor: MaterialStateProperty.all(
        backgroundColor ?? Klr.theme.primaryAccent
      ),
      minimumSize: MaterialStateProperty.all(Size(100.0, 30.0)),
    ),
    child: Text(label, style: Txt.typeStyle(TxtType.subtitle3).merge(style)),
    onPressed: onPressed,
  );
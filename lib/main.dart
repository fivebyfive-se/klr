import 'package:flutter/material.dart';
import 'package:klr/klr.dart';
import 'package:klr/services/app-state-service.dart'
  show appStateService;

Future main() async {
  await appStateService().init();

  runApp(Klr.makeApp());
}

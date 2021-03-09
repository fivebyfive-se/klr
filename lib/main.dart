import 'package:flutter/material.dart';
import 'package:klr/klr.dart';
import 'package:klr/services/app-state-service.dart'
  show appStateService;

import 'package:klr/services/color-name-service.dart'
  show colorNameService;

Future main() async {
  await appStateService().init();
  await colorNameService().init();

  runApp(KlrApp());
}

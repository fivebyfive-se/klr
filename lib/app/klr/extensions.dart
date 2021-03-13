import 'package:fbf/fbf.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension StateLocalizationExtensions on State<FbfPage> {
  AppLocalizations get t => AppLocalizations.of(context);
}

extension StatelessLocalizationExtensions on StatelessWidget {
  AppLocalizations t(BuildContext c) => AppLocalizations.of(c);
}

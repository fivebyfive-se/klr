import 'package:flutter/material.dart';
import 'package:fbf/fbf.dart';

import 'klr/colors.dart';
import 'klr/pages.dart';
import 'klr/theme.dart';

class KlrConfig extends FbfAppConfig<KlrTheme,KlrPages> {
  KlrConfig() : super(
    appName: 'Klr',
    theme: KlrTheme(),
    routes: KlrPages()
  );
  KlrColors get colors => KlrColors.getInstance();

  static KlrConfig of(BuildContext context)
    => FbfAppConfig.of<KlrConfig>(context);
}

class KlrApp extends FbfApp<KlrConfig> {
  KlrApp() : super(config: KlrConfig());
}

class KlrBuilder extends FbfAppBuilder<KlrConfig> {
  KlrBuilder({
    Key key,
    FbfAppWidgetBuilder<KlrConfig> builder
  }) : super(key: key, builder: builder);
}

class KlrStatefulBuilder extends FbfStatefulBuilder<KlrConfig> {
  KlrStatefulBuilder({
    Key key,
    FbfStatefulWidgetBuilder<KlrConfig> builder
  }) : super(key: key, builder: builder);
}

mixin KlrConfigMixin<W extends StatefulWidget> on State<W> {
  KlrConfig get klr => KlrConfig.of(super.context); 
} 
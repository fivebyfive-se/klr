import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:fbf/fbf.dart';

import 'klr/colors.dart';
import 'klr/pages.dart';
import 'klr/theme.dart';

export 'klr/extensions.dart';

class KlrConfig extends FbfAppConfig<KlrTheme,KlrPages> {
  KlrConfig() : super(
    appName: 'Klr',
    theme: KlrTheme(),
    routes: KlrPages()
  );
  KlrColors get colors => KlrColors.getInstance();

  static KlrConfig of(BuildContext context)
    => FbfAppConfig.of<KlrConfig>(context);

  static AppLocalizations t(BuildContext context)
    => AppLocalizations.of(context);
}

class KlrApp extends FbfApp<KlrConfig> {
  KlrApp() : super(config: KlrConfig());

  @override
  Widget build(BuildContext context)
    => FbfAppContainer(
      config: config,
      child: FbfAppBuilder<KlrConfig>(
        builder: (ctx, cfg) => MaterialApp(
          title: cfg.appName,
          theme: cfg.theme.themeData,
          routes: cfg.routes.routes,
          initialRoute: cfg.routes.initialRoute,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
//              GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', ''), // English, no country code
            const Locale('sv', ''), // Arabic, no country code
          ],
        )
      )
    );
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
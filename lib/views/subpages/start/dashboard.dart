import 'package:flutter/material.dart';
import 'package:klr/classes/fbf/routing/sub-page-route.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/services/app-state-service.dart';
import 'package:klr/views/base/page-arguments.dart';
import 'package:klr/views/views.dart';
import 'package:klr/widgets/txt.dart';

class DashboardSubPage extends SubPageBase {
  static const String routeName = 'dashboard';
  static const String routeLabel = 'Dashboard';
  static const IconData routeIcon = Icons.dashboard_outlined;
  static const IconData routeActiveIcon = Icons.dashboard;

  static FbfSubPageRoute routeDefinition = FbfSubPageRoute(
    routeName: routeName,
    label: routeLabel,
    icon: routeIcon,
    activeIcon: routeActiveIcon,
    builder: (_) => DashboardSubPage()
  );

  DashboardSubPage(): super(routeName);

  @override
  _DashboardSubPageState createState()
    => _DashboardSubPageState();
}

class _DashboardSubPageState extends State<DashboardSubPage> {
  AppStateService _appStateService = AppStateService.getInstance();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppState>(
      initialData: _appStateService.snapshot,
      stream: _appStateService.appStateStream,
      builder: (context, appState) => ListView(
        children: <Widget>[
          Txt.h2(DashboardSubPage.routeLabel),
          Txt.h3("Palettes"),
          ...(appState.data.palettes == null 
            ? [] 
            : appState.data.palettes.map(
                (p) => ListTile(
                  title: Txt.h3(p.name)
                )
              ).toList()
            )
        ],
      ),
    );
  }
}

class DashboardConfig extends PageConfig<DashboardArguments> {}
class DashboardArguments extends PageArguments {}

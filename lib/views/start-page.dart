import 'package:flutter/material.dart';
import 'package:klr/app/klr.dart';
import 'package:klr/classes/fbf/routing/sub-page-route.dart';
import 'package:klr/models/app-state/models/app-state.dart';
import 'package:klr/services/app-state-service.dart';
import 'package:klr/views/base/page-arguments.dart';
import 'package:klr/views/subpages/start/palette.dart';
import 'package:klr/widgets/bottom-navigation.dart';

import 'base/_page-base.dart';

class StartPage extends PageBase<StartPageConfig> {
  static const String routeName = '/start';
  static const String title = 'Start';

  StartPage() : super(routeName);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  AppStateService _appStateService = AppStateService.getInstance();
  AppState get _appState => _appStateService.snapshot;
  int _currentPageIndex = 0;

  Widget _buildCurrentPage(BuildContext context)
    => getChildren()
        .elementAt(_currentPageIndex)
        .builder(context);

  List<BottomNavigationPage> _buildPageList() {
    return getChildren().map((c) => BottomNavigationPage(
      label: c.label,
      icon: c.icon,
      activeIcon: c.activeIcon,
      disabledIcon: c.icon,
      disabled: c.routeName == 'palette' && _appState.currentPalette == null
    )).toList();
  }

  void _pageIndexChanged(int index)
    => setState(() => _currentPageIndex = index); 

  Future<void> _fabPressed() async {
    await _appStateService.createPalette();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppState>(
      stream: _appStateService.appStateStream,
      initialData: _appStateService.snapshot,
      builder: (context, appData) => scaffold<StartPageConfig,PageArguments>(
        context: context,
        config: StartPageConfig(
          fabIcon: Icons.add_box_outlined,
          fabOnPressed: _fabPressed,
          initialSelectedIndex: _currentPageIndex,
          onSelectedIndexChanged: _pageIndexChanged,
          pages: _buildPageList()
        ),
        builder: (context, data, _) 
          => Container(
            child: _buildCurrentPage(context)
          )
      )
    );
  }
}

class StartPageConfig extends PageConfig 
                         with PageConfig_HasSubPages,
                              PageConfig_ScaffoldFloatingButton
{
  StartPageConfig({
    int initialSelectedIndex = 0,
    Iterable<BottomNavigationPage> pages,
    Function(int) onSelectedIndexChanged,
    this.fabIcon,
    this.fabOnPressed,
  }) : this.navigationConfig = BottomNavigationConfig(
    intialSelectedIndex: initialSelectedIndex,
    pages: pages.toList(),
    onSelectedIndexChanged: onSelectedIndexChanged
  );

  final BottomNavigationConfig navigationConfig;
  final IconData fabIcon;
  final Function fabOnPressed;
}



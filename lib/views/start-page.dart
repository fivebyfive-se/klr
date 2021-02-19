import 'package:flutter/material.dart';
import 'package:klr/app/klr.dart';

import 'package:klr/models/app-state/models/app-state.dart';
import 'package:klr/services/app-state-service.dart';

import 'package:klr/views/base/page-arguments.dart';
import 'package:klr/widgets/bottom-navigation.dart';
import 'package:klr/widgets/bottom-sheet-menu.dart';

import 'base/_page-base.dart';

class StartPage extends PageBase<StartPageConfig> {
  static Color pageAccent = Klr.colors.pink95;
  static Color onPageAccent = Klr.colors.grey05; 
  static const String routeName = '/start';
  static const String title = 'Dashboard';

  static BottomNavigationPage makeNavigationPage(AppState state)
    => BottomNavigationPage(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
      routeName: routeName,
      disabled: false
    );

  StartPage() : super(routeName);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  AppStateService _appStateService = AppStateService.getInstance();
  AppState get _appState => _appStateService.snapshot;

  List<BottomSheetMenuItem<String>> get _menuItems => [
    BottomSheetMenuItem<String>(
      icon: Icon(Icons.add_box_outlined, color: Klr.theme.primaryAccent),
      title: "New palette",
      subtitle: "Create a new color palette",
      value: "Create"
    ),
    BottomSheetMenuItem<String>(
      icon: Icon(Icons.cancel_outlined, color: Klr.theme.secondaryAccent),
      title: "Cancel",
      subtitle: "Close this menu",
      value: "Cancel"
    )
  ];

  Future<void> _createPalette() async {
    final p = await _appStateService.createPalette();
    await _appStateService.setCurrentPalette(p);
  }

  void _onMenuSelect(String value) {
    if (value == "Create") {
      _createPalette();
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = PageArguments.of<StartPageArguments>(context);

    return StreamBuilder<AppState>(
      stream: _appStateService.appStateStream,
      initialData: _appStateService.snapshot,
      builder: (context, snapshot) => scaffold<StartPageConfig,StartPageArguments>(
        context: context,
        config: StartPageConfig(
          appStateSnapshot: snapshot.data,
          fabMenuItems: _menuItems,
          fabOnSelect: _onMenuSelect,
        ),
        builder: (context, data, _) => Container(
          child: Container()
        )
      )
    );
  }
}

class StartPageArguments extends PageArguments {}

class StartPageConfig extends PageConfig<StartPageArguments> 
                         with PageConfig_ScaffoldHasFabMenu<StartPageArguments>, 
                              PageConfig_ScaffoldShowNavigation<StartPageArguments>
{
  StartPageConfig({
    this.appStateSnapshot,
    this.fabMenuItems,
    this.fabOnSelect
  });

  final AppState appStateSnapshot;
  final List<BottomSheetMenuItem<String>> fabMenuItems;
  final void Function(String) fabOnSelect;
  final String fabTitle = 'Dashboard actions';
  final Color fabBackgroundColor = StartPage.pageAccent;
  final Color fabIconColor = StartPage.onPageAccent;
  final IconData fabTitleIcon = Icons.dashboard;
}



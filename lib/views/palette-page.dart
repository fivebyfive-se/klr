import 'package:flutter/material.dart';
import 'package:klr/klr.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/services/app-state-service.dart';
import 'package:klr/views/views.dart';
import 'package:klr/widgets/bottom-navigation.dart';
import 'package:klr/widgets/bottom-sheet-menu.dart';

class PalettePage extends PageBase<PalettePageConfig> {
  static Color pageAccent = Klr.colors.orange99;
  static Color onPageAccent = Klr.colors.grey05; 

  static const String routeName = '/palette';
  static const String title = 'Palette';

  static BottomNavigationPage makeNavigationPage(AppState state)
    => BottomNavigationPage(
      icon: Icons.palette_outlined,
      activeIcon: Icons.palette,
      label: 'Palette',
      routeName: routeName,
      disabled: state.currentPalette == null
    );

  PalettePage() : super(routeName);

  @override
  _PalettePageState createState() => _PalettePageState();
}

class _PalettePageState extends State<PalettePage> {
  AppStateService _appStateService = AppStateService.getInstance();

  List<BottomSheetMenuItem<String>> get _menuItems => [
    BottomSheetMenuItem<String>(
      icon: Icon(Icons.add_box_outlined, color: Klr.theme.tertiaryAccent),
      title: "New color",
      subtitle: "Create a new color in this palette",
      value: "Create"
    ),
    BottomSheetMenuItem<String>(
      icon: Icon(Icons.cancel_outlined, color: Klr.theme.secondaryAccent),
      title: "Cancel",
      subtitle: "Close this menu",
      value: "Cancel"
    )
  ];

  void _onMenuSelect(String value) {

  }

  @override
  Widget build(BuildContext context) {
    final args = PageArguments.of<PalettePageArguments>(context);

    return StreamBuilder<AppState>(
      stream: _appStateService.appStateStream,
      initialData: _appStateService.snapshot,
      builder: (context, snapshot) => scaffold<PalettePageConfig,PalettePageArguments>(
        context: context,
        config: PalettePageConfig(
          appStateSnapshot: snapshot.data,
          fabMenuItems: _menuItems,
          fabOnSelect: _onMenuSelect
        ),
        builder: (context, data, _) => Container(
          child: Container()
        )
      )
    );
  }
}

class PalettePageArguments extends PageArguments {}

class PalettePageConfig extends PageConfig<PalettePageArguments> 
                         with PageConfig_ScaffoldHasFabMenu<PalettePageArguments>, 
                              PageConfig_ScaffoldShowNavigation<PalettePageArguments>
{
  PalettePageConfig({
    this.appStateSnapshot,
    this.fabMenuItems,
    this.fabOnSelect,
  });

  final AppState appStateSnapshot;
  final List<BottomSheetMenuItem<String>> fabMenuItems;
  final void Function(String) fabOnSelect;
  final String fabTitle = 'Palette actions';
  final Color fabBackgroundColor = PalettePage.pageAccent;
  final Color fabIconColor = PalettePage.onPageAccent;
  final IconData fabTitleIcon = Icons.palette;
}



import 'package:flutter/material.dart';

import 'package:klr/app/klr.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/views/views.dart';

class BottomNavigation extends StatefulWidget {
  BottomNavigation(this.appState);

  final AppState appState;
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  List<BottomNavigationPage> get _pages => [
    StartPage.makeNavigationPage(widget.appState),
    PalettePage.makeNavigationPage(widget.appState),
  ];


  BottomNavigationBarItem _pageToItem(BottomNavigationPage p) 
    => BottomNavigationBarItem(
      icon: Icon(
        p.disabled
          ? p.disabledIcon
          : p.icon,
        color: p.disabled 
          ? Klr.theme.bottomNavDisabled
          : Klr.theme.bottomNavForeground
      ),
      activeIcon: Icon(p.activeIcon),
      label: p.disabled ? "" : p.label,
      tooltip: p.label
    );

  void _onItemTapped(int index) {
    if (!_pages[index].disabled) {
      Navigator.pushNamed(context, _pages[index].routeName);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final nav = Navigator.of(context);
    final currentRoute = ModalRoute.of(context).settings.name;
    final currentIndex = _pages.indexWhere((p) => p.routeName == currentRoute);

    return BottomNavigationBar(
      currentIndex: currentIndex < 0 ? 0 : currentIndex,
      backgroundColor: Klr.theme.bottomNavBackground,
      unselectedItemColor: Klr.theme.bottomNavForeground,
      selectedItemColor: Klr.theme.bottomNavSelected,
      onTap: _onItemTapped,
      items: _pages.map((p) => _pageToItem(p)).toList()
    );
  }
}

class BottomNavigationPage {
  BottomNavigationPage({
    this.disabled = false,
    this.label,
    this.icon,
    this.routeName,
    IconData activeIcon,
    IconData disabledIcon
  }) : activeIcon = activeIcon ?? icon,
       disabledIcon = disabledIcon ?? icon;

  final bool disabled;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final IconData disabledIcon;
  final String routeName;
}

class BottomNavigationConfig {
  BottomNavigationConfig({
    this.pages,
    this.activePageRoute
  });

  final List<BottomNavigationPage> pages;
  final String activePageRoute;
}
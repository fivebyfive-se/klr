import 'package:flutter/material.dart';
import 'package:klr/app/klr.dart';

class BottomNavigation extends StatefulWidget {
  BottomNavigation(this.config);

  final BottomNavigationConfig config;

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  BottomNavigationConfig get _config => widget.config;

  List<BottomNavigationBarItem> _buildItems() => _config.pages.map(
    (p) => BottomNavigationBarItem(
      icon: Icon(
        p.disabled ? p.disabledIcon : p.icon,
        color: p.disabled ? Klr.theme.bottomNavDisabled : Klr.theme.bottomNavForeground
      ),
      activeIcon: Icon(p.activeIcon),
      label: p.disabled ? "" : p.label,
      tooltip: p.label
    )).toList();

  void _onItemTapped(int index) {
    if (!_config.pages[index].disabled) {
      setState(() {
        _selectedIndex = index;
        _config.onSelectedIndexChanged?.call(_selectedIndex);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = _config.intialSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      backgroundColor: Klr.theme.bottomNavBackground,
      unselectedItemColor: Klr.theme.bottomNavForeground,
      selectedItemColor: Klr.theme.bottomNavSelected,
      showUnselectedLabels: false,
      onTap: _onItemTapped,
      items: _buildItems()
    );
  }
}

class BottomNavigationPage {
  BottomNavigationPage({
    this.disabled = false,
    this.label,
    this.icon,
    IconData activeIcon,
    IconData disabledIcon
  }) : activeIcon = activeIcon ?? icon,
       disabledIcon = disabledIcon ?? icon;

  final bool disabled;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final IconData disabledIcon;
}

class BottomNavigationConfig {
  BottomNavigationConfig({
    this.intialSelectedIndex,
    this.pages,
    this.onSelectedIndexChanged
  });

  final int intialSelectedIndex;
  final List<BottomNavigationPage> pages;
  final void Function(int) onSelectedIndexChanged;
}
import 'dart:math' show min;

import 'package:flutter/material.dart';

import 'package:fbf/fbf.dart';
import 'package:klr/app/klr.dart';

class Tabber extends StatefulWidget {
  const Tabber({
    Key key,
    this.width,
    this.height,
    this.tabs,
    this.title,
    this.initialTab,
  }) : super(key: key);

  final double width;
  final double height;
  final List<TabberTab> tabs;
  final String title;

  final int initialTab;

  @override
  _TabberState createState() => _TabberState();
}

class _TabberState extends State<Tabber> {
  List<TabberTab> get _tabs 
    => widget.tabs;

  int _activeTabIndex;

  TabberTab get _activeTab
    => _activeTabIndex == null || _activeTabIndex >= _tabs.length
          ? null 
          : _tabs.elementAt(_activeTabIndex);

  void _setTab(int idx)
    => setState(() => _activeTabIndex = idx);

  @override
  void initState() {
    super.initState();

    _activeTabIndex = widget.initialTab ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final vp = MediaQuery.of(context).size;
    final klr = KlrConfig.of(context);

    final containerWidth = widget.width ?? vp.width;
    final containerHeight = widget.height ?? vp.height;

    final getColor = (int idx) => idx == _activeTabIndex 
      ? klr.theme.foreground
      : klr.theme.foregroundDisabled; 

    final tabBarItems = _tabs.length;
    final tabBarWidth = (containerWidth / 2) - klr.size(2);

    final tabBarHeight = 100.0;
    final currentTabBarBorderSize = 2.0;
    final contentHeight = containerHeight 
      - tabBarHeight * 2 
      - currentTabBarBorderSize;

    return Container(
      width: containerWidth,
      height: containerHeight,
      color: klr.theme.cardBackground,
      child: Column(
        children: [
          Container(
            height: tabBarHeight,
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: tabBarWidth / (tabBarHeight / 2),
              children: [
                ..._tabs.mapIndex(
                  (t, i) => Container(
                    child: ListTile(
                      leading: t.icon == null ? null : Icon(t.icon, color: getColor(i)),
                      tileColor: i == _activeTabIndex 
                        ? klr.theme.cardBackground 
                        : klr.theme.cardBackground.deltaLightness(-5.0),
                      title: Text(
                        t.label,
                        style: TextStyle(color: getColor(i))
                      ),
                      onTap: () => _setTab(i),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: BorderSide.none
                      ),
                    )
                  )
                ).toList()
              ]
            ),
          ),
          SizedBox(
            height: contentHeight,
            width: containerWidth,
            child: _activeTab == null 
              ? Container() 
              : Container(
                  height: contentHeight,
                  child: _activeTab.contentBuilder.call(context)
                )
          )
        ],
      )
    );
  }
}

class TabberTab {
  TabberTab({
    this.label,
    this.icon,
    this.contentBuilder
  });
  
  final String label;
  final IconData icon;
  final Widget Function(BuildContext context) contentBuilder;
}
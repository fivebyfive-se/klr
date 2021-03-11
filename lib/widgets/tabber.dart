import 'package:flutter/material.dart';

import 'package:fbf/fbf.dart';
import 'package:klr/app/klr.dart';

class Tabber extends StatefulWidget {
  const Tabber({
    Key key,
    this.width,
    this.height,
    this.tabs,
    this.initialTab,
  }) : super(key: key);

  final double width;
  final double height;
  final List<TabberTab> tabs;

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
    final wp = MediaQuery.of(context).size;
    final klr = KlrConfig.of(context);
    final getColor = (int idx) => idx == _activeTabIndex 
      ? klr.theme.primaryAccent
      : klr.theme.foreground; 

    return Container(
      width: widget.width ?? wp.width,
      color: klr.theme.cardBackground,
      child: Column(
        children: [
          Container(
            height: 60.0,
            child: Row(
              children: _tabs.mapIndex(
                (t, i) => Expanded(
                  flex: 1,
                  child: ListTile(
                    leading: Icon(t.icon, color: getColor(i)),
                    title: Text(t.label, style: TextStyle(color: getColor(i))),
                    onTap: () => _setTab(i),
                  )
                )
              ).toList()
            ),
          ),
          Divider(color: klr.theme.primary),
          Expanded(
            child: _activeTab == null 
              ? Container() 
              : _activeTab.contentBuilder.call(context)
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
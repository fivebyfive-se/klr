import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/klr.dart';

import 'bx.dart';

class ExpandingTable extends StatefulWidget {
  const ExpandingTable({
    Key key,
    this.headerIcon,
    this.headerLabel,
    this.contentBuilder,
    this.headerBuilder
  }) : super(key: key);

  final IconData headerIcon;

  final String headerLabel;

  final Widget Function(BuildContext context, bool isActive)
    contentBuilder;

  final Widget Function(BuildContext context, bool isActive)
    headerBuilder;

  @override
  _ExpandingTableState createState() => _ExpandingTableState();
}

class _ExpandingTableState extends State<ExpandingTable> {
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.of(context).size;
    final klr = KlrConfig.of(context);
    final duration = const Duration(milliseconds: 400);
    final headerColor = _isActive
      ? klr.theme.tableActiveHeaderForegroundColor
      : klr.theme.tableHeaderForegroundColor;

    return SliverStickyHeader(
      header: AnimatedContainer(
        duration: duration,
        height: _isActive ? klr.tileHeightLG : klr.tileHeightSM,
        width: viewport.width,
        color: klr.theme.tableSubHeaderColor,
        child: BxCol(
          children: <Widget>[
            Container(
              color: _isActive 
                ? klr.theme.tableActiveHeaderColor
                : klr.theme.tableHeaderColor,
              child: ListTile(
                leading: Icon(
                  widget.headerIcon,
                  color: headerColor
                ),
                title: Text(
                  widget.headerLabel,
                  style: klr.textTheme.subtitle1.withColor(headerColor)
                ),
                onTap: () => setState(() => _isActive = !_isActive),
                trailing: Icon(
                  _isActive ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: headerColor
                ),
                minVerticalPadding: klr.size(1),
              ),
            ),
            ...(_isActive 
              ? [AnimatedOpacity(
                  duration: duration,
                  opacity: _isActive ? 1.0 : 0.0,
                  child: _isActive 
                    ? Theme(
                        child: widget.headerBuilder(context, _isActive),
                        data: klr.themeData.copyWith(
                          textTheme: klr.textTheme.copyWith(
                            
                          ),
                          popupMenuTheme: PopupMenuThemeData(
                            color: klr.theme.tableSubHeaderColor,
                            textStyle: klr.textTheme.subtitle2
                              .withColor(klr.theme.tableSubHeaderForegroundColor)
                          )
                        ),
                      ) 
                    : Container()
                )] 
              : []
            )
          ],
        )
      ),
      sliver: SliverToBoxAdapter(
        child: AnimatedContainer(
          duration: duration,
          height: _isActive ? viewport.height / 2.5 : 0.0,
          width: viewport.width,
          color: klr.theme.tableBackground,
          child: widget.contentBuilder(context, _isActive)),      
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/klr.dart';

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
      ? klr.theme.foreground
      : klr.theme.foregroundDisabled;

    return SliverStickyHeader(
      header: Container(
        height: klr.size(8),
        width: viewport.width,
        color: klr.theme.cardBackground,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
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
              )
            ),
            Expanded(
              flex: 2,
              child: AnimatedOpacity(
                duration: duration,
                opacity: _isActive ? 1.0 : 0.0,
                child: _isActive ? widget.headerBuilder(context, _isActive) : Container()
              )
            )
          ],
        )
      ),
      sliver: SliverToBoxAdapter(
        child: AnimatedContainer(
          duration: duration,
          height: _isActive ? viewport.height / 2.5 : 0.0,
          width: viewport.width,
          child: widget.contentBuilder(context, _isActive)),      
      ),
    );
  }
}
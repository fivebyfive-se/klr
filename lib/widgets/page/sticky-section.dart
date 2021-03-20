import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:klr/klr.dart';

class StickySection extends StatelessWidget {
  const StickySection({
    Key key,
    this.icon,
    this.title,
    this.child
  })
    : super(key: key);

  factory StickySection.list({
    Key key,
    Widget icon,
    Widget title,
    List<Widget> children,
  }) => StickySection(
    key: key,
    icon: icon,
    title: title,
    child: SliverList(
      delegate: SliverChildListDelegate(children),
    )
  );

  factory StickySection.box({
    Key key,
    Widget icon,
    Widget title,
    Widget child,
  }) => StickySection(
    key: key,
    icon: icon,
    title: title,
    child: SliverToBoxAdapter(
      child: child
    )
  );

  factory StickySection.text({
    Key key,
    Widget icon,
    Widget title,
    String text,
  }) => StickySection(
    key: key,
    icon: icon,
    title: title,
    child: SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 16.0, bottom: 32.0),
        child: Text(text),
      )
    )
  );


  final Widget icon;
  final Widget title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final klr = KlrConfig.of(context);

    return SliverStickyHeader(
      header: Container(
        height: klr.smallTileHeight,
        color: klr.theme.bottomNavBackground,
        child: DefaultTextStyle(
          child: ListTile(
            leading: icon,
            title: title
          ),
          style: klr.textTheme.subtitle2
        )
      ),
      sliver: child
    );
  }
}
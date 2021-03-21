import 'package:flutter/material.dart';
import 'package:klr/klr.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({
    Key key,
    this.title,
    this.subtitle,
    this.icon
  }) : super(key: key);

  factory PageTitle.text({
    Key key,
    String title,
    String subtitle,
    IconData icon
  }) => PageTitle(
    key: key,
    title: Text(title ?? ''),
    subtitle: Text(subtitle ?? ''),
    icon: Icon(icon ?? Icons.crop_square)
  );

  final Widget title;
  final Widget subtitle;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final klr = KlrConfig.of(context);

    return SliverToBoxAdapter(
      child: Container(
        height: klr.tileHeightx15,
        alignment: Alignment.centerLeft,
        child: ListTile(
          leading: icon,          
          title: DefaultTextStyle(
            child: title,
            style: klr.textTheme.subtitle1,
          ),
          subtitle: subtitle == null ? null : DefaultTextStyle(
            child: subtitle,
            style: klr.textTheme.subtitle2
          )
        )
      )
    );
  }
}
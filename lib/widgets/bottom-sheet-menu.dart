import 'package:flutter/material.dart';
import 'package:klr/app/klr.dart';
import 'package:klr/widgets/txt.dart';

typedef BottomSheetMenuItemBuilder<T>
  = BottomSheetMenuItem<T> Function(T item);

class BottomSheetMenu<T> extends StatelessWidget {
  BottomSheetMenu({
    this.title,
    this.titleIcon,
    this.titleColor,
    this.titleBackgroundColor,
    this.items,
    this.onSelect
  });

  final String title;
  final List<BottomSheetMenuItem<T>> items;
  final Function(T) onSelect;
  final Color titleColor;
  final Color titleBackgroundColor;
  final Widget titleIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: titleIcon,
            tileColor: Klr.theme.focusTriad.dark,
            title: Txt.subtitle2(
              title,
              style: TextStyle(color: titleColor ?? Klr.theme.secondaryAccent)
            )
          ),
          Divider(),
          ...items.map(
            (item) {
              return ListTile(
                leading: item.icon,
                title: Text(item.title),
                subtitle: item.subtitle == null ? null : Text(item.subtitle),
                onTap: () {
                  onSelect?.call(item.value);
                  Navigator.pop(context);
                }
              );
            }
          ).toList()
        ],
      )
    );
  }

  static void showBottomSheet<X>({BuildContext context,
    String title,
    Widget titleIcon,
    Color titleColor,
    Color titleBackgroundColor,
    List<BottomSheetMenuItem<X>> items,
    Function(X) onSelect,
  }) {
    showModalBottomSheet<void>(
      backgroundColor: Klr.theme.cardBackground,
      context: context,
      builder: (context) => BottomSheetMenu<X>(
        title: title,
        titleIcon: titleIcon,
        titleColor: titleColor,
        titleBackgroundColor: titleBackgroundColor,
        items: items,
        onSelect: onSelect, 
      )
    );
  }
}

class BottomSheetMenuItem<T> {
  BottomSheetMenuItem({this.value, this.icon, this.title, this.subtitle});

  final T value;
  final Widget icon;
  final String title;
  final String subtitle;
}

class BottomSheetMenuCommand {

}
  import 'package:flutter/material.dart';

Widget listToGrid(
  List<Widget> list, {
    int crossAxisCount = 2,
    double crossAxisSpacing = 5.0,
    double mainAxisExtent = 75.0
})
  => SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisExtent: mainAxisExtent,        
      ),
      delegate: SliverChildListDelegate(list),
    );

Widget sliverSpacer({double size = 64.0})
  => SliverToBoxAdapter(child: Container(height: size));

Widget listToList(
  List<Widget> list
) => SliverList(
    delegate: SliverChildListDelegate(list)
  );

EdgeInsetsGeometry verticalPadding({double length = 32.0})
  => EdgeInsets.symmetric(vertical: length);

double defaultPaddingLength() => 32.0;
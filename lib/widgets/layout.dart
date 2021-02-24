  import 'package:flutter/material.dart';
import 'package:klr/klr.dart';

Widget listToGrid(
  List<Widget> list, {
    int crossAxisCount = 2,
    double crossAxisSpacing,
    double mainAxisExtent
})
  => SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing ?? Klr.size(0.5),
        mainAxisExtent: mainAxisExtent ?? Klr.size(9.0),        
      ),
      delegate: SliverChildListDelegate(list),
    );

Widget sliverSpacer({double size})
  => SliverToBoxAdapter(child: Container(height: size ?? Klr.size(4)));

Widget listToList(
  List<Widget> list
) => SliverList(
    delegate: SliverChildListDelegate(list)
  );

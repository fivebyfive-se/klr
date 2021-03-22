import 'package:flutter/material.dart';

class BxFlowDelegate extends FlowDelegate {
  BxFlowDelegate({
    this.mainAxis = Axis.vertical,
    this.crossAxisCount = 1,
    this.mainAxisCount = 1
  });

  final Axis mainAxis;
  final int crossAxisCount;
  final int mainAxisCount;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints box) {
    return mainAxis == Axis.vertical 
      ? box.copyWith(
          maxWidth: box.maxWidth / crossAxisCount,
          minWidth: box.minWidth / crossAxisCount,
          maxHeight: box.maxHeight / mainAxisCount,
          minHeight: box.minHeight / mainAxisCount
        )
      : box.copyWith(
          maxWidth: box.maxWidth / mainAxisCount,
          minWidth: box.minWidth / mainAxisCount,
          maxHeight: box.maxHeight / crossAxisCount,
          minHeight: box.minHeight / crossAxisCount
        );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    final numRows = mainAxisCount;
    final v = mainAxis == Axis.vertical;
    final cellSize  = Size(
      context.size.width  / (v ? crossAxisCount : numRows),
      context.size.height / (v ? numRows : crossAxisCount)
    );
    int row = 0;
    int col = 0;

    for (int i = 0; i < context.childCount; i++) {
      if (i > 0 && i % crossAxisCount == 0) {
        row++;
        col = 0;
      }
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          (v ? col : row) * cellSize.width,
          (v ? row : col) * cellSize.height,
          0,
        ),
      );
      col++;
    }
  }

  @override
  bool shouldRepaint(covariant BxFlowDelegate old)
    => old.mainAxis != mainAxis ||
       old.crossAxisCount != crossAxisCount;
}

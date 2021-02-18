import 'stepped-num-range.dart';

class RangeMapping {
  RangeMapping(List<List<double>> rangePairs)
    : sourceRange = SteppedNumRange(
        steps: rangePairs.map((p) => p.first).toList()
      ),
      targetRange = SteppedNumRange(
        steps: rangePairs.map((p) => p.last).toList()
      );

  final SteppedNumRange sourceRange;
  final SteppedNumRange targetRange;

  double apply(double value, {bool reverse = false})
    => reverse ? targetRange.mapTo(value, sourceRange)
               : sourceRange.mapTo(value, targetRange);
}
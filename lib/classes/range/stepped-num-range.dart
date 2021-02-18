import 'package:flutter/foundation.dart';

import 'num-range.dart';

class SteppedNumRange {
  SteppedNumRange({this.steps});

  final List<double> steps;
  
  @protected
  List<NumRange> _subranges;

  double get min => steps.first;
  double get max => steps.last;

  List<NumRange> get subranges {
    if (_subranges == null) {
      _subranges = <NumRange>[];
      for (int i = 0; i < steps.length - 1; i++) {
        _subranges.add(NumRange(min: steps[i], max: steps[i+1]));
      }
    }
    return _subranges;
  }

  NumRange get indexRange => NumRange(min: 0.0, max: steps.length.toDouble());

  NumRange findRange(double value)
    => subranges.firstWhere((element) => element.inRange(value));

  int findRangeIndex(double value)
    => subranges.indexWhere((element) => element.inRange(value));

  double modValue(double value)
    => value < min ? value + (max - min) : value;

  double mapTo(double value, SteppedNumRange targetRange) {
    final mapIndex = 
      (int i) => steps.length == targetRange.steps.length 
        ? i
        : indexRange
            .mapTo(i.toDouble(), targetRange.indexRange)
            .toInt();
    final val = modValue(value);
    final sourceIndex = findRangeIndex(val);

    return sourceIndex < 0 
      ? targetRange.max 
      : targetRange.subranges[mapIndex(sourceIndex)]
          .mapFrom(val, subranges[sourceIndex]);
  }
}


class NumRange {
  NumRange({this.min, this.max});

  final double min;
  final double max;

  bool inRange(double value) => value >= min && value <= max;

  /// Linear interpolation: get value between `min` and `max`
  /// at the ratio `a`. 
  double lerp(double ratio)
    => min * (1.0 - ratio) + max * ratio;

  double invlerp(double value)
    => ((value - min) / (max - min)).clamp(0.0, 1.0);

  double mapTo(double value, NumRange targetRange)
    => targetRange.lerp(invlerp(value));

  double mapFrom(double value, NumRange sourceRange)
    => lerp(sourceRange.invlerp(value));
}

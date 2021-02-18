import './helpers.dart';


extension NumExtensions on num {
  /// Where this number falls between `min` and `max`
  /// as a ratio 0.0 - 1.0
  double invlerp(num min, num max)
    => ((this - min) / (max - min)).clamp(0.0, 1.0);

  /// Map this value from source range to target range
  num rangeMap(
    num sourceMin, num sourceMax,
    num targetMin, num targetMax
  ) => lerp(targetMin, targetMax, this.invlerp(sourceMin, sourceMax));

}
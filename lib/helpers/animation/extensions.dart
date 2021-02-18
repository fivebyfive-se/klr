extension DurationExtensions on Duration {
  Duration add(Duration other)
    => Duration(microseconds: this.inMicroseconds + other.inMicroseconds);

  Duration subtract(Duration other)
    => Duration(microseconds: this.inMicroseconds - other.inMicroseconds);

  Duration multiplyBy(double n)
    => Duration(microseconds: (this.inMicroseconds * n).toInt());

  Duration divideBy(double n)
    => Duration(microseconds: this.inMicroseconds ~/ n);
}

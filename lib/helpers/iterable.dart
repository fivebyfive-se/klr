import 'package:klr/classes/tuple.dart';

extension IterableExtensions on Iterable {
  Iterable<T> distinctBy<T,V>(V Function(T item) selectValue) sync* {
    final values = Set<V>();

    for (T item in this) {
      final v = selectValue(item);
      if (!values.contains(v)) {
        values.add(v);
        yield item;
      }
    }
  }

  List<T> schwartz<T,D>({
    D Function(T item) decorator,
    int Function(D a, D b) comparer,
  }) {
    final decorated = (this ?? <T>[])
      .cast<T>()
      .map((v) => Tuple2<T,D>(v, decorator.call(v)))
      .toList();
    decorated.sort((a,b) => comparer.call(a.item2, b.item2));

    return decorated.map((t) => t.item1).toList();
  } 

  Iterable<T> order<T>(int Function(T a, T b) comparator) {
    final temp = [...(this ?? []).cast<T>()];
    temp.sort(comparator);
    return temp.toList();
    
  }

  T min<T extends num>() {
    T min = this.first;
    for (T item in this) {
      if (item < min) {
        min = item;
      }
    }
    return min;
  }
  
  T max<T extends num>() {
    T max = this.first;
    for (T item in this) {
      if (item > max) {
        max = item;
      }
    }
    return max;
  }
}

extension ListExtensions on List {
  T unshiftOr<T>(T orElse) 
    => this.isEmpty ? orElse : this.removeAt(0) as T;
  T popOr<T>(T orElse)
    => this.isEmpty ? orElse : this.removeLast() as T;

  List<T> extend<T>(int len, [T value]) {
    final out = this.toList();
    final fillVal = value ?? this.last;
    while (out.length < len) {
      out.add(value);
    }
    return out;
  }
}
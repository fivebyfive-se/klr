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
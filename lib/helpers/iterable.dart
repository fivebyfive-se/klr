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

  Iterable<T> order<T>(int Function(T a, T b) comparator) sync* {
    final temp = [...(this ?? []).cast<T>()];
    temp.sort(comparator);
    for (T item in temp) {
      yield item;
    }
  }
}
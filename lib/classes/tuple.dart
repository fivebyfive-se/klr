class Tuple2<T,V> {
  Tuple2({this.item1, this.item2});

  Tuple2.fromMapEntry(MapEntry<T,V> entry)
    : item1 = entry.key,
      item2 = entry.value;


  T item1;
  V item2;
}

class Tuple3<T,V,U> extends Tuple2<T,V> {
  Tuple3({T item1, V item2, this.item3})
    : super(item1: item1, item2: item2);

  Tuple3.fromMapEntry(MapEntry<T,Tuple2<V,U>> entry)
    : item3 = entry.value.item2,
      super(item1: entry.key, item2: entry.value.item1);

  U item3;
}
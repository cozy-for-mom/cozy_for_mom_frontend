extension MapWithIndex<E> on List<E> {
  List<T> mapWithIndex<T>(T Function(E item, int index) transform) {
    List<T> result = [];
    for (int i = 0; i < length; i++) {
      result.add(transform(this[i], i));
    }
    return result;
  }
}

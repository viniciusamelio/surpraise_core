abstract class ValueObject<T> {
  ValueObject(
    this._value,
  );

  // ignore: unused_field
  late final T _value;

  @override
  String toString();
}

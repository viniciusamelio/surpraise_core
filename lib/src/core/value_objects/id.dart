import 'package:equatable/equatable.dart';
import 'package:surpraise_core/src/core/value_objects/base_value_object.dart';

class Id extends Equatable implements ValueObject<String> {
  Id(String value) {
    if (value.isEmpty) {
      throw Exception("Invalid Id");
    }
    _value = value;
  }

  late final String _value;

  String get value => _value;

  @override
  String toString() {
    return _value;
  }

  @override
  List<Object?> get props => [_value];
}

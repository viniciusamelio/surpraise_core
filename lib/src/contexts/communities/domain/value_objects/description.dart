import 'package:equatable/equatable.dart';
import 'package:surpraise_core/src/core/exceptions/exceptions.dart';
import 'package:surpraise_core/src/core/value_objects/base_value_object.dart';

class Description extends Equatable implements ValueObject<String> {
  Description(String value) {
    if (value.isEmpty) {
      throw ValidationException("Invalid Description");
    }
    _value = value;
  }
  late final String _value;

  String get value => _value;

  @override
  String toString() {
    return value;
  }

  @override
  List<Object?> get props => [_value];
}

import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../exceptions/validation_exception.dart';
import 'base_value_object.dart';

class Id extends Equatable implements ValueObject<String> {
  Id(String value) {
    if (value.isEmpty || !isUUID(value)) {
      throw ValidationException("Invalid Id");
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

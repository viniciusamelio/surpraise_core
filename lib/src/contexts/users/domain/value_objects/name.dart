import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../../../core/exceptions/validation_exception.dart';
import '../../../../core/value_objects/base_value_object.dart';

class Name extends Equatable implements ValueObject<String> {
  Name(
    String value,
  ) {
    _validate(value);
    _value = value;
  }

  void _validate(String value) {
    if (value.trim().split(" ").length < 2) {
      throw ValidationException("Name must contains both name and surname");
    }
  }

  late final String _value;

  String get value => _value;

  @override
  List<Object?> get props => [
        _value,
      ];
}

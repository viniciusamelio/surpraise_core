import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';
import 'package:surpraise_core/src/core/exceptions/exceptions.dart';
import 'package:surpraise_core/src/core/value_objects/base_value_object.dart';

class Message extends Equatable implements ValueObject<String> {
  Message(String value) {
    _validate(value);
    _value = value;
  }
  late final String _value;

  void _validate(String value) {
    if (value.length > 280) {
      throw ValidationException(
        "Praise message should not contain more than 280 characters",
      );
    } else if (value.isEmpty) {
      throw ValidationException(
        "Message should not be empty",
      );
    }
  }

  @override
  List<Object?> get props => [_value];
}
